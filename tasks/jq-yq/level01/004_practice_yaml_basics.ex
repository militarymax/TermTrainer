META
# Track: jq-yq
# Title: Свитки YAML
# Number: 004
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/deploy.yaml" << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spell-service
  labels:
    app: spells
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spells
  template:
    spec:
      containers:
        - name: spell-api
          image: uu/spell-api:v1.2.3
          ports:
            - containerPort: 8080
EOF

TASK
📜 **Свитки YAML**

YAML — основной формат конфигураций в Университете. Деплойменты, сервисы, конфиги — всё в YAML. Научись читать и конвертировать их.

ASSIGNMENT
📋 **Задания**:
1. Выведи весь YAML: `yq '.' deploy.yaml`
2. Pretty print: `yq -P '.' deploy.yaml`
3. Извлеки имя деплоймента: `yq '.metadata.name' deploy.yaml`
4. Количество реплик: `yq '.spec.replicas' deploy.yaml`
5. Образ контейнера: `yq '.spec.template.spec.containers[0].image' deploy.yaml`
6. Конвертируй в JSON: `yq -o json '.' deploy.yaml`
7. Сохрани JSON: `yq -o json '.' deploy.yaml > deploy.json`

📂 Рабочий каталог: `~/.termtrainer/jqyq_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_004"
score=0

result1=$(yq '.metadata.name' "$DIR/deploy.yaml" 2>/dev/null)
[ "$result1" = "spell-service" ] && { echo "✓ Имя извлечено"; score=$((score+1)); }

result2=$(yq '.spec.replicas' "$DIR/deploy.yaml" 2>/dev/null)
[ "$result2" = "3" ] && { echo "✓ Реплики найдены"; score=$((score+1)); }

if [ -f "$DIR/deploy.json" ]; then
  echo "✓ JSON файл создан"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Свитки YAML освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Весь YAML: yq '.' файл.yaml
Поле: yq '.metadata.name' файл.yaml
Массив: yq '.containers[0].image' файл.yaml
YAML→JSON: yq -o json '.' файл.yaml
Сохранить: yq -o json '.' файл.yaml > файл.json
Pretty: yq -P '.' файл.yaml — красивое форматирование
