META
# Track: jq-yq
# Title: Мутации свитков YAML
# Number: 009
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/deploy.yaml" << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spell-service
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: spell-api
          image: uu/spell-api:v1.0.0
          ports:
            - containerPort: 8080
EOF

TASK
✏️ **Мутации свитков YAML**

Казначей хочет обновлять конфиги не вручную, а через yq — менять версию образа, количество реплик, добавлять переменные.

📋 **Задания**:
1. Обнови версию образа: `yq '.spec.template.spec.containers[0].image = "uu/spell-api:v2.0.0"' deploy.yaml`
2. Обнови на месте: `yq -i '.spec.replicas = 5' deploy.yaml`
3. Проверь: `yq '.spec.replicas' deploy.yaml`
4. Используй переменную окружения: `export TAG=v3.0.0 && yq -i '.spec.template.spec.containers[0].image = "uu/spell-api:" + strenv(TAG)' deploy.yaml`
5. Создай новый документ: `yq -n '.name = "new-service" | .port = 9090' > service.yaml`
6. Слей два документа: создай второй yaml и используй `yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)'`

📖 **Ключевые команды yq**:
• `yq '.path = "value"' файл` — обновить значение (вывод в stdout)
• `yq -i '.path = "value"' файл` — обновить файл на месте!
• `strenv(VAR)` — подставить переменную окружения
• `yq -n '.'` — создать новый документ с нуля

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_009"
score=0

replicas=$(yq '.spec.replicas' "$DIR/deploy.yaml" 2>/dev/null)
[ "$replicas" = "5" ] && { echo "✓ Реплики обновлены"; score=$((score+1)); }

image=$(yq '.spec.template.spec.containers[0].image' "$DIR/deploy.yaml" 2>/dev/null)
echo "$image" | grep -q 'v2\|v3' && { echo "✓ Образ обновлён: $image"; score=$((score+1)); }

if [ -f "$DIR/service.yaml" ]; then
  echo "✓ service.yaml создан"
  score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Мутации YAML освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Обновить поле: yq '.path.key = "value"' файл.yaml
На месте: yq -i '.path.key = "value"' файл.yaml — изменяет файл!
Env var: export VER=v2; yq '.image.tag = strenv(VER)' файл.yaml
Создать: yq -n '.key = "value"' > новый.yaml
Поиск в массиве: yq '.items[] | select(.name == "foo")' файл.yaml
