META
# Track: kubectl
# Title: Глубокий допрос кластера
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #014: Глубокий допрос кластера

Архиканцлер вызвал тебя в Тайную Комнату:
«Ринсвинд! Мне нужен ПОЛНЫЙ аудит кластера. Все поды, все проблемы,
все ресурсы — в одном отчёте через jq. Напиши скрипт,
который извлекает данные из API и форматирует их красиво.
Если ты не умеешь парсить JSON через jq — на CKA ты пропал.»

📋 **Задания**:

1. **jsonpath — мощные запросы**:
   ```bash
   # Все IP подов в кластере:
   kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'
   
   # Поды не в Running:
   kubectl get pods -A --field-selector=status.phase!=Running
   
   # Контейнерные образы всех подов:
   kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].image}{"\n"}{end}'
   ```

2. **jq для сложного анализа**:
   ```bash
   # Поды по нодам (сколько на каждой?):
   kubectl get pods -A -o json | jq -r '.items | group_by(.spec.nodeName) | map({node: .[0].spec.nodeName, count: length}) | .[]'
   
   # CrashLoopBackOff поды:
   kubectl get pods -A -o json | jq -r '.items[] | select(.status.containerStatuses[]?.state.waiting?.reason == "CrashLoopBackOff") | .metadata.name'
   
   # Рестарты больше 5:
   kubectl get pods -A -o json | jq -r '.items[] | select(.status.containerStatuses[]?.restartCount > 5) | "\(.metadata.name): \(.status.containerStatuses[0].restartCount) restarts"'
   ```

3. **Напиши `cluster_audit.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   echo "═══ Cluster Audit Report ═══"
   echo "Date: $(date)"
   
   echo ""
   echo "── Node Status ──"
   kubectl get nodes -o wide
   
   echo ""
   echo "── Problem Pods ──"
   kubectl get pods -A --field-selector=status.phase!=Running 2>/dev/null || echo "(all running!)"
   
   echo ""
   echo "── High Restart Pods (>5) ──"
   kubectl get pods -A -o json 2>/dev/null | \
     jq -r '.items[] | select(.status.containerStatuses[]?.restartCount > 5) | "\(.metadata.namespace)/\(.metadata.name): \(.status.containerStatuses[0].restartCount) restarts"' 2>/dev/null || echo "(none)"
   
   echo ""
   echo "── Resource Usage ──"
   kubectl top nodes 2>/dev/null || echo "(metrics-server not installed)"
   
   echo ""
   echo "── Pod Count by Namespace ──"
   kubectl get pods -A -o json 2>/dev/null | \
     jq -r '.items | group_by(.metadata.namespace) | map({ns: .[0].metadata.namespace, count: length}) | sort_by(-.count) | .[] | "\(.ns): \(.count)"' 2>/dev/null
   
   echo ""
   echo "═══ End of Audit ═══"
   ```

4. Запусти: `chmod +x cluster_audit.sh && ./cluster_audit.sh > $DIR/audit.txt`

📂 Рабочий каталог: `~/.termtrainer/kubectl_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_014"
score=0

if [ -f "$DIR/cluster_audit.sh" ]; then
  chmod +x "$DIR/cluster_audit.sh"
  out=$(bash "$DIR/cluster_audit.sh" 2>&1)
  echo "$out" | grep -q "Node\|Pod\|Audit\|Namespace" && { echo "✓ cluster_audit.sh работает"; score=$((score+1)); }
fi

nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)
[ -n "$nodes" ] && { echo "✓ jsonpath запрос работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Продвинутый дебаг освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Напиши cluster_audit.sh (баллов: $score/2)"
exit 1

HINTS
Jsonpath: kubectl get X -o jsonpath='{range .items[*]}{.field}{"\n"}{end}'
Field selector: kubectl get pods --field-selector=status.phase!=Running
JQ group_by: group_by(.field) → map → aggregate — группировка данных
JQ select: select(.field > N) — фильтрация по условию
JQ restarts: .status.containerStatuses[]?.restartCount — счётчик рестартов
Top nodes: kubectl top nodes — CPU/RAM по нодам (нужен metrics-server!)
Top pods: kubectl top pods -A — CPU/RAM по подам
