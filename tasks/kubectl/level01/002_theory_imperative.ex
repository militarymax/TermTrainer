META
# Track: kubectl
# Title: Императивная магия
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #002: Императивная магия

Декан Чартер показал тебе короткие заклинания:
«Ринсвинд! На экзамене CKA время — твой главный враг.
Не пиши YAML вручную! Используй императивные команды
и --dry-run=client -o yaml для генерации шаблонов.
Это как заклинание-шорткат — произносишь одно слово,
а получаешь целый свиток.»

───────────────────────────────────────
🔹 ИМПЕРАТИВНЫЕ КОМАНДЫ (БЕЗ YAML!)
───────────────────────────────────────

```bash
# Создать деплоймент
kubectl create deployment nginx --image=nginx

# Создать сервис (экспонировать под)
kubectl expose pod nginx --port=80 --type=NodePort
kubectl expose deployment nginx --port=80 --type=ClusterIP

# Масштабировать
kubectl scale deployment nginx --replicas=3

# Создать неймспейс
kubectl create namespace tower-dev

# Создать ConfigMap из literal
kubectl create configmap app-config --from-literal=DB_HOST=localhost

# Создать Secret
kubectl create secret generic db-secret --from-literal=password=s3cret
```

───────────────────────────────────────
🔹 DRY-RUN — ГЕНЕРАЦИЯ YAML
───────────────────────────────────────

```bash
# Сгенерировать YAML НЕ создавая ресурс!
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deploy.yaml

kubectl expose pod nginx --port=80 --type=NodePort --dry-run=client -o yaml > svc.yaml
```

💡 **Стратегия экзамена**: генерируй через --dry-run → редактируй → применяй!

───────────────────────────────────────
🔹 KUBECTL EXPLAIN — ДОКУМЕНТАЦИЯ В ТЕРМИНАЛЕ
───────────────────────────────────────

```bash
kubectl explain pod                          # Структура Pod
kubectl explain pod.spec.containers          # Контейнеры внутри пода
kubectl explain deploy.spec.strategy         # Стратегия обновления
```

📂 Рабочий каталог: `~/.termtrainer/kubectl_002`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/kubectl_002
📋 **Попробуй**:
1. `kubectl create deployment test --image=nginx --dry-run=client -o yaml | head -20`
2. `kubectl explain pod.spec.containers | head -20`
3. `kubectl create ns tower-test && kubectl get ns tower-test && kubectl delete ns tower-test`

VALIDATION
#!/bin/bash
score=0

yaml=$(kubectl run test-dry --image=nginx --dry-run=client -o yaml 2>/dev/null | grep -c "kind:\|apiVersion:\|name:")
[ "$yaml" -ge 2 ] && { echo "✓ dry-run YAML генерируется"; score=$((score+1)); }

explain=$(kubectl explain pod 2>/dev/null | head -5)
[ -n "$explain" ] && { echo "✓ kubectl explain работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Императивные команды освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Убедитесь что kubectl подключён к кластеру"
exit 1

HINTS
Create deploy: kubectl create deployment NAME --image=IMAGE — без YAML!
Expose: kubectl expose pod/deploy NAME --port=N --type=Type — создать сервис
Scale: kubectl scale deployment NAME --replicas=N — масштабировать
Dry-run: --dry-run=client -o yaml > file.yaml — сгенерировать шаблон!
Explain: kubectl explain RESOURCE — документация в терминале
Namespace: kubectl create ns NAME — создать пространство имён
ConfigMap: kubectl create configmap NAME --from-literal=KEY=VAL
Secret: kubectl create secret generic NAME --from-literal=KEY=VAL
