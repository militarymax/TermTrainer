META
# Track: kubectl
# Title: Квоты ресурсов и архив Башни
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #013: Квоты ресурсов и архив Башни

Архиканцлер указал на переполненные поды:
«Ринсвинд! Без ограничений один маг может сожрать ВСЮ ману кластера!
LimitRange задаёт лимиты по умолчанию. ResourceQuota ограничивает
весь неймспейс. А etcd — это Архив Башни, где хранится ВСЁ состояние.
Если Архив сгорит — кластер умрёт. Навсегда.»

───────────────────────────────────────
🔹 LIMITRANGE — ЛИМИТЫ ПО УМОЛЧАНИЮ
───────────────────────────────────────

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: tower-limits
spec:
  limits:
  - type: Container
    default:              # По умолчанию если не указано
      cpu: "500m"
      memory: "256Mi"
    defaultRequest:       # Запрос по умолчанию
      cpu: "100m"
      memory: "128Mi"
    max:                  # Максимум!
      cpu: "2"
      memory: "1Gi"
```

───────────────────────────────────────
🔹 RESOURCEQUOTA — КВОТА НА НЕЙМСПЕЙС
───────────────────────────────────────

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tower-quota
spec:
  hard:
    requests.cpu: "4"          # Всего CPU запросов в NS
    requests.memory: "8Gi"     # Всего памяти запросов в NS
    limits.cpu: "8"
    limits.memory: "16Gi"
    pods: "20"                  # Максимум подов в NS!
    services: "10"
    persistentvolumeclaims: "5"
```

Проверить: `kubectl describe quota -n <namespace>`

───────────────────────────────────────
🔹 ETCD BACKUP/RESTORE — АРХИВ БАШНИ
───────────────────────────────────────

```bash
# Бэкап (на control-plane ноде!):
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Проверить бэкап:
ETCDCTL_API=3 etcdctl snapshot status /tmp/etcd-backup.db --write-table

# Восстановление (ОСТАНОВИТЬ etcd СНАЧАЛА!):
ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcd-backup.db \
  --data-dir=/var/lib/etcd-restore
```

⚠️ Это критичный для CKA топик! Обязательно практикуй!

📂 Рабочий каталог: `~/.termtrainer/kubectl_013`

📋 **Попробуй**:
1. `kubectl get quota -A` — есть ли квоты?
2. `kubectl describe limitrange -A` — есть ли лимиты?

VALIDATION
#!/bin/bash
score=0

quota=$(kubectl get resourcequota -A 2>/dev/null | head -3)
[ -n "$quota" ] && { echo "✓ ResourceQuota API доступен"; score=$((score+1)); }

limits=$(kubectl get limitrange -A 2>/dev/null | head -3)
[ -n "$limits" ] && { echo "✓ LimitRange API доступен"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Квоты и etcd освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
LimitRange: дефолтные лимиты (default/defaultRequest/max) на контейнер
ResourceQuota: общие ограничения на весь неймспейс (CPU/RAM/pods/services)
Describe quota: kubectl describe quota NAME — сколько использовано из квоты
Etcd backup: ETCDCTL_API=3 etcdctl snapshot save + certs — критично для CKA!
Etcd restore: остановить etcd → restore → перезапустить с новым data-dir
Etcd certs: --cacert/--cert/--key обязательны для аутентификации!
Kubeadmin upgrade: kubeadm upgrade plan + apply — обновление кластера
