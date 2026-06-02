META
# Track: kubectl
# Title: Печати башен и притяжение существ
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: Печати башен и притяжение существ

В Тайной Комнате Архиканцлер открыл древний свиток:
«Ринсвинд! Taints — это печати на башнях-нодах, которые ОТТАЛКИВАЮТ
существ без допуска. Tolerations — это допуск существа пройти
через печать. Affinity — это ПРИТЯЖЕНИЕ: существо хочет быть
рядом с определённой башнёй или другими существами.
Anti-Affinity — ОТТАЛКИВАЕТ от других. Это высшая магия планирования!»

───────────────────────────────────────
🔹 TAINTS И TOLERATIONS
───────────────────────────────────────

```bash
# Наложить печать на ноду:
kubectl taint nodes <node> key=value:NoSchedule     # Не размещать поды!
kubectl taint nodes <node> dedicated=tower:NoExecute # Даже выгнать работающие!

# Убрать печать:
kubectl taint nodes <node> key:value-

# Допуск в поде (Toleration):
tolerations:
- key: "dedicated"
  operator: "Equal"
  value: "tower"
  effect: "NoSchedule"
```

📖 **Эффекты печатей**:
• `NoSchedule` — новые поды не попадут на ноду
• `PreferNoSchedule` — постараются не ставить, но могут
• `NoExecute` — выгнать даже работающие поды!

📖 **Стандартные печати** (уже есть на control-plane):
`node-role.kubernetes.io/control-plane:NoSchedule`

───────────────────────────────────────
🔹 NODE AFFINITY — ПРИТЯЖЕНИЕ К БАШНЕ
───────────────────────────────────────

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:   # ОБЯЗАТЕЛЬНО!
      nodeSelectorTerms:
      - matchExpressions:
        - key: disktype
          operator: In
          values: ["ssd"]
    preferredDuringSchedulingIgnoredDuringExecution:  # Желательно
    - weight: 80
      preference:
        matchExpressions:
        - key: region
          operator: In
          values: ["eu"]
```

───────────────────────────────────────
🔹 POD ANTI-AFFINITY — РАЗДЕЛЕНИЕ СУЩЕСТВ
───────────────────────────────────────

```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels:
          app: api
      topologyKey: kubernetes.io/hostname
    # Никакие два api-пода на одной ноде!
```

📂 Рабочий каталог: `~/.termtrainer/kubectl_012`

ASSIGNMENT
📋 **Попробуй**:
1. `kubectl get nodes -o jsonpath='{.items[*].spec.taints}' | jq '.'`
2. `kubectl taint nodes <node> test=true:NoSchedule && kubectl taint nodes <node> test=true-`

VALIDATION
#!/bin/bash
score=0

taints=$(kubectl get nodes -o jsonpath='{.items[0].spec.taints}' 2>/dev/null)
[ -n "$taints" ] && { echo "✓ Taints найдены"; score=$((score+1)); }

nodes=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
[ "$nodes" -ge 1 ] && { echo "✓ Ноды доступны ($nodes)"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Taints и Affinity освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Taint node: kubectl taint nodes NAME key=value:Effect — наложить печать
Remove taint: kubectl taint nodes NAME key:value- — убрать печать (минус в конце!)
Effects: NoSchedule / PreferNoSchedule / NoExecute — сила печати
Toleration in pod: tolerations: [{key, operator, value, effect}] — допуск через печать
NodeAffinity required: ОБЯЗАТЕЛЬНО на подходящей ноде
NodeAffinity preferred: желательно, но не обязательно (с весом)
PodAntiAffinity: не ставить два пода с одной меткой на одну ноду
Control-plane taint: уже имеет NoSchedule — обычные поды туда не попадают
