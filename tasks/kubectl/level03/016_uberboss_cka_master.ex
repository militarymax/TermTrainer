META
# Track: kubectl
# Title: Архимаг Кластера
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/kubectl_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
👑 UBERBOSS #016: Архимаг Кластера

Архиканцлер стоял на вершине Башни, ветер развевал его мантию:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Создай production-стек в кластере:
неймспейс, деплоймент с ConfigMap+Secret+Probes, сервис,
Ingress, RBAC, ResourceQuota и скрипт аудита.
Используй ВСЁ: императивные команды, --dry-run, jq, jsonpath.
Если справишься — ты Архимаг Кластера.
Если нет... знаешь того кактуса? Он до сих пор колется.»

📋 **БЛОК 1 — Неймспейс и квоты**:

```bash
kubectl create ns tower-production

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tower-quota
  namespace: tower-production
spec:
  hard:
    requests.cpu: "4"
    requests.memory: "8Gi"
    pods: "20"
    services: "10"
EOF
```

📋 **БЛОК 2 — Конфигурация**:

```bash
kubectl create configmap app-config -n tower-production \
  --from-literal=DB_HOST=postgres.tower-production.svc \
  --from-literal=TOWER_NAME="Unseen University"

kubectl create secret generic db-creds -n tower-production \
  --from-literal=DB_PASSWORD=s3cret
```

📋 **БЛОК 3 — Деплоймент с Probes**:

Создай `$DIR/deploy.yaml` через --dry-run + редактирование:
```bash
kubectl create deployment api-server --image=nginx --replicas=3 \
  -n tower-production --dry-run=client -o yaml > $DIR/deploy.yaml
```

Добавь в YAML:
- envFrom из ConfigMap и Secret
- livenessProbe (httpGet / на 80)
- readinessProbe (httpGet / на 80)
- resources requests/limits

```bash
kubectl apply -f $DIR/deploy.yaml -n tower-production
```

📋 **БЛОК 4 — Сервисы и Ingress**:

```bash
kubectl expose deployment api-server --port=80 --type=ClusterIP -n tower-production

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tower-ingress
  namespace: tower-production
spec:
  rules:
  - host: tower.unseen.edu
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-server
            port:
              number: 80
EOF
```

📋 **БЛОК 5 — RBAC**:

```bash
kubectl create sa tower-reader -n tower-production
kubectl create role pod-reader --verb=get,list,watch --resource=pods -n tower-production
kubectl create rolebinding reader-bind --role=pod-reader --serviceaccount=tower-production:tower-reader -n tower-production
```

📋 **БЛОК 6 — Скрипт аудита**:

Напиши `$DIR/cluster_audit.sh`:
```bash
#!/bin/bash
set -euo pipefail
NS="${1:-tower-production}"

echo "═══ Tower Cluster Audit ═══"
echo "Date: $(date)"
echo ""

echo "── Nodes ──"; kubectl get nodes -o wide
echo ""; echo "── Namespace ──"; kubectl get ns "$NS"
echo ""; echo "── Quota ──"; kubectl describe quota -n "$NS" 2>/dev/null || echo "(no quota)"
echo ""; echo "── Deployment ──"; kubectl get deploy -n "$NS" -o wide
echo ""; echo "── Pods ──"; kubectl get pods -n "$NS" -o wide
echo ""; echo "── Services ──"; kubectl get svc -n "$NS"
echo ""; echo "── Ingress ──"; kubectl get ingress -n "$NS"
echo ""; echo "── RBAC ──"; kubectl get sa,role,rolebinding -n "$NS"
echo ""; echo "── ConfigMap ──"; kubectl get cm -n "$NS"
echo ""; echo "── Secrets ──"; kubectl get secrets -n "$NS"
echo ""
echo "── RBAC Test ──"
kubectl auth can-i get pods -n "$NS" --as=system:serviceaccount:${NS}:tower-reader
kubectl auth can-i delete pods -n "$NS" --as=system:serviceaccount:${NS}:tower-reader
echo ""
echo "═══ End of Audit ═══"
```

Запусти: `chmod +x cluster_audit.sh && ./cluster_audit.sh > $DIR/full_audit.txt`

📂 Рабочий каталог: `~/.ninja_trainer/kubectl_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/kubectl_016"
score=0
max=5

[ -f "$DIR/deploy.yaml" ] && grep -qi "livenessProbe\|readinessProbe\|envFrom\|resources" "$DIR/deploy.yaml" && { echo "✓ deploy.yaml создан с probes"; score=$((score+1)); }

[ -f "$DIR/cluster_audit.sh" ] && head -1 "$DIR/cluster_audit.sh" | grep -q '^#!' && { echo "✓ cluster_audit.sh создан"; score=$((score+1)); }

[ -d "$DIR" ] && ls "$DIR"/*.yaml &>/dev/null && { echo "✓ YAML файлы есть"; score=$((score+1)); }

ns=$(kubectl get ns tower-production -o jsonpath='{.metadata.name}' 2>/dev/null)
[ "$ns" = "tower-production" ] && { echo "✓ Неймспейс создан"; score=$((score+1)); }

cm=$(kubectl get cm app-config -n tower-production -o jsonpath='{.data.DB_HOST}' 2>/dev/null)
[ -n "$cm" ] && { echo "✓ ConfigMap работает: $cm"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 3 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Namespace + ResourceQuota — ограничить ресурсы неймспейса

=== БЛОК 2 ===
ConfigMap + Secret — конфигурация приложения

=== БЛОК 3 ===
Deploy with probes: livenessProbe/readinessProbe/resources/envFrom
Dry-run strategy: kubectl create ... --dry-run=client -o yaml > file.yaml → edit → apply

=== БЛОК 4 ===
Service ClusterIP + Ingress — экспонировать приложение

=== БЛОК 5 ===
SA + Role + RoleBinding — минимальные права доступа

=== БЛОК 6 ===
Audit script: собрать все данные кластера в один отчёт
Auth can-i: проверить что RBAC работает правильно
