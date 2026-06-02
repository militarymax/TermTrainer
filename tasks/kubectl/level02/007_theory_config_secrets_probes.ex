META
# Track: kubectl
# Title: Свитки конфигурации и зонды жизни
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #007: Свитки конфигурации и зонды жизни

Библиотекарь положил перед тобой два типа свитков:
«Ууук!» — это означало: «ConfigMap — это свиток, который может прочитать
любой. Secret — запечатанный свиток, который видит только тот, кому
предназначен. А Probes — это заклинания проверки: жив ли маг?
Готов ли он принимать заклинания? Без probes кластер не узнает,
что существо уже мертво. Как в прошлый раз. Мы заметили через неделю.»

───────────────────────────────────────
🔹 CONFIGMAP И SECRETS
───────────────────────────────────────

```bash
# ConfigMap — публичная конфигурация
kubectl create configmap tower-config \
  --from-literal=DB_HOST=postgres.tower.svc \
  --from-literal=TOWER_NAME="Unseen University"

# Secret — секретная конфигурация (base64!)
kubectl create secret generic tower-secret \
  --from-literal=DB_PASSWORD=s3cret \
  --from-literal=API_KEY=magic-key-42

# Использование в поде (как env vars):
kubectl run app --image=nginx --dry-run=client -o yaml > pod.yaml
# Добавить в yaml:
#   envFrom:
#   - configMapRef:
#       name: tower-config
#   - secretRef:
#       name: tower-secret

# Или как файлы:
#   volumes:
#   - name: config-vol
#     configMap: { name: tower-config }
```

⚠️ Secrets хранятся в base64 — это НЕ шифрование! Включи encryption at rest!

───────────────────────────────────────
🔹 LIVENESS И READINESS PROBES
───────────────────────────────────────

📖 **Liveness Probe** — «Жив ли?» → если нет, перезапустить!
📖 **Readiness Probe** — «Готов?» → если нет, убрать из Service!
📖 **Startup Probe** — «Запустился?» → ждать пока стартанёт!

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 15    # Подождать перед первой проверкой
  periodSeconds: 10          # Проверять каждые 10 сек
  failureThreshold: 3        # После 3 провалов → перезапуск

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  periodSeconds: 5
```

📂 Рабочий каталог: `~/.termtrainer/kubectl_007`

ASSIGNMENT
📋 **Попробуй**:
1. `kubectl create configmap test-cm --from-literal=key=val && kubectl get cm test-cm -o yaml`
2. `kubectl create secret generic test-sec --from-literal=pw=secret && kubectl get secret test-sec -o yaml`
3. Очистка: `kubectl delete cm test-cm && kubectl delete secret test-sec`

VALIDATION
#!/bin/bash
score=0

kubectl create configmap tower-cm --from-literal=TOWER=test &>/dev/null
cm=$(kubectl get cm tower-cm -o jsonpath='{.data.TOWER}' 2>/dev/null)
[ "$cm" = "test" ] && { echo "✓ ConfigMap работает"; score=$((score+1)); }

kubectl create secret generic tower-sec --from-literal=pw=secret &>/dev/null
sec=$(kubectl get secret tower-sec -o jsonpath='{.data.pw}' 2>/dev/null | base64 -d)
[ "$sec" = "secret" ] && { echo "✓ Secret работает"; score=$((score+1)); }

kubectl delete cm tower-cm &>/dev/null; kubectl delete secret tower-sec &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: ConfigMap и Secrets освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
ConfigMap literal: kubectl create configmap NAME --from-literal=KEY=VAL
Secret literal: kubectl create secret generic NAME --from-literal=KEY=VAL
From file: --from-file=key=path/to/file — создать из файла
As env vars: envFrom.configMapRef / secretRef в YAML пода
As volume: volumes.configMap / secret + volumeMounts в YAML
Liveness probe: жив ли контейнер? Нет → перезапуск!
Readiness probe: готов ли принимать трафик? Нет → убрать из Endpoints
Startup probe: запустился ли? Ждать до первого успеха
