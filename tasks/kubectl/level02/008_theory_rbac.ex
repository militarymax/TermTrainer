META
# Track: kubectl
# Title: Печати доступа
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #008: Печати доступа

Архиканцлер указал на дверь с тремя замками:
«Ринсвинд! В Башне не каждый может войти куда угодно.
ServiceAccount — это удостоверение личности. Role — это список прав.
RoleBinding — это печать, которая связывает личность с правами.
Без печати — никуда. С неправильной печатью — тоже никуда.
Как в прошлый раз, когда ты получил права на удаление ВСЕХ подов...»

───────────────────────────────────────
🔹 SERVICE ACCOUNT — УДОСТОВЕРЕНИЕ ЛИЧНОСТИ
───────────────────────────────────────

```bash
kubectl create serviceaccount tower-wizard    # Создать SA
kubectl get sa                                # Все аккаунты
kubectl describe sa tower-wizard              # Детали + токен
```

───────────────────────────────────────
🔹 ROLE И ROLEBINDING — ПЕЧАТИ ДОСТУПА
───────────────────────────────────────

📖 **Role** — ЧТО можно делать (в рамках одного NS):
```bash
kubectl create role pod-reader \
  --verb=get,list,watch \
  --resource=pods
```

📖 **RoleBinding** — КТО может делать (связывает SA + Role):
```bash
kubectl create rolebinding tower-reader \
  --role=pod-reader \
  --serviceaccount=tower-wizard
```

📖 **ClusterRole** — права на ВЕСЬ кластер (nodes, PV и т.д.):
```bash
kubectl create clusterrole node-viewer \
  --verb=get,list,watch \
  --resource=nodes
```

📖 **ClusterRoleBinding** — кластерная привязка:
```bash
kubectl create clusterrolebinding tower-node-viewer \
  --clusterrole=node-viewer \
  --serviceaccount=default:tower-wizard
```

⚠️ Проверь права:
```bash
kubectl auth can-i get pods --as=system:serviceaccount:default:tower-wizard
kubectl auth can-i delete pods --as=system:serviceaccount:default:tower-wizard
```

📂 Рабочий каталог: `~/.termtrainer/kubectl_008`

ASSIGNMENT
📋 **Попробуй**:
1. `kubectl create sa test-sa && kubectl create role test-role --verb=get,list --resource=pods`
2. `kubectl create rolebinding test-rb --role=test-role --serviceaccount=test-sa`
3. `kubectl auth can-i get pods --as=system:serviceaccount:default:test-sa` → yes!
4. Очистка: `kubectl delete sa test-sa && kubectl delete role test-role && kubectl delete rolebinding test-rb`

VALIDATION
#!/bin/bash
score=0

kubectl create serviceaccount tower-sa &>/dev/null
kubectl create role tower-role --verb=get,list --resource=pods &>/dev/null
kubectl create rolebinding tower-rb --role=tower-role --serviceaccount=tower-sa &>/dev/null

can=$(kubectl auth can-i get pods --as=system:serviceaccount:default:tower-sa 2>/dev/null)
[ "$can" = "yes" ] && { echo "✓ RBAC работает: can get pods"; score=$((score+1)); }

cannot=$(kubectl auth can-i delete pods --as=system:serviceaccount:default:tower-sa 2>/dev/null)
[ "$cannot" = "no" ] && { echo "✓ RBAC ограничивает: cannot delete pods"; score=$((score+1)); }

kubectl delete sa tower-sa &>/dev/null; kubectl delete role tower-role &>/dev/null; kubectl delete rolebinding tower-rb &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: RBAC освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Create SA: kubectl create serviceaccount NAME — создать аккаунт
Create Role: kubectl create role NAME --verb=get,list --resource=pods — права в одном NS
Create RoleBinding: kubectl create rolebinding NAME --role=X --serviceaccount=Y — привязать права
ClusterRole: права на весь кластер (nodes, PV, namespaces)
ClusterRoleBinding: привязка ClusterRole к SA на уровне кластера
Check access: kubectl auth can-i VERB RESOURCE --as=SA — проверить права
Namespace scope: Role+RoleBinding = один NS; ClusterRole+ClusterRoleBinding = весь кластер
