META
# Track: jq-yq
# Title: Пайплайн Казначейства
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/inventory.json" << 'EOF'
{
  "склад": "Главный",
  "зелья": [
    {"id": 1, "название": "невидимость", "цена": 100, "тип": "подкрепление", "наличие": 15},
    {"id": 2, "название": "огненный_шар", "цена": 300, "тип": "атака", "наличие": 5},
    {"id": 3, "название": "лечение", "цена": 50, "тип": "подкрепление", "наличие": 30},
    {"id": 4, "название": "щит", "цена": 200, "тип": "защита", "наличие": 8},
    {"id": 5, "название": "молния", "цена": 250, "тип": "атака", "наличие": 0},
    {"id": 6, "название": "телепорт", "цена": 500, "тип": "утилита", "наличие": 2}
  ]
}
EOF
cat > "$DIR/deploy.yaml" << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: potion-service
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: api
          image: uu/potion-api:v1.0.0
          env:
            - name: DB_HOST
              value: localhost
EOF

TASK
🐉 **Пайплайн Казначейства** (БОСС)

Архиканцлер требует полный отчёт: отфильтровать зелья, обновить конфиг и подготовить данные для CI/CD.

📋 **Боевые задания**:

**JSON часть**:
1. Только зелья в наличии (наличие > 0): `jq '.зелья[] | select(.наличие > 0)' inventory.json`
2. Отсортируй по цене по убыванию: `jq '.зелья | sort_by(.цена) | reverse' inventory.json`
3. Сгруппируй по типу и посчитай количество: `jq '.зелья | group_by(.тип) | map({тип: .[0].тип, количество: length})' inventory.json`
4. Экспортируй в CSV: `jq -r '.зелья[] | [.название, .цена, .тип] | @csv' inventory.json > report.csv`
5. Общая стоимость инвентаря: `jq '[.зелья[] | .цена * .наличие] | add' inventory.json`

**YAML часть**:
6. Обнови реплики на 5: `yq -i '.spec.replicas = 5' deploy.yaml`
7. Обнови образ через переменную: `export VER=v2.0.0 && yq -i '.spec.template.spec.containers[0].image = "uu/potion-api:" + strenv(VER)' deploy.yaml`
8. Добавь переменную окружения: `yq -i '.spec.template.spec.containers[0].env += [{"name": "LOG_LEVEL", "value": "debug"}]' deploy.yaml`

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_011"
score=0

r1=$(jq '[.зелья[] | select(.наличие > 0)] | length' "$DIR/inventory.json" 2>/dev/null)
[ "$r1" -ge 4 ] && { echo "✓ Фильтрация работает ($r1 зелий)"; score=$((score+1)); }

r2=$(jq '[.зелья[] | .цена * .наличие] | add' "$DIR/inventory.json" 2>/dev/null)
[ "$r2" -ge 100 ] && { echo "✓ Общая стоимость: $r2"; score=$((score+1)); }

rep=$(yq '.spec.replicas' "$DIR/deploy.yaml" 2>/dev/null)
[ "$rep" = "5" ] && { echo "✓ YAML реплики обновлены"; score=$((score+1)); }

img=$(yq '.spec.template.spec.containers[0].image' "$DIR/deploy.yaml" 2>/dev/null)
echo "$img" | grep -q 'v2' && { echo "✓ Образ обновлён: $img"; score=$((score+1)); }

[ -f "$DIR/report.csv" ] && { echo "✓ CSV создан"; score=$((score+1)); }

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Пайплайн работает! (баллов: $score/5)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/5)"
exit 1

HINTS
Select: jq '.items[] | select(.field > 0)' файл
Sort desc: jq '.items | sort_by(.field) | reverse' файл
Group+count: jq '.items | group_by(.type) | map({type: .[0].type, count: length})' файл
CSV: jq -r '.items[] | [.name, .price] | @csv' файл > out.csv
Math: jq '[.items[] | .price * .qty] | add' файл — сумма произведений
YAML update: yq -i '.path = "value"' файл.yaml
Env var: export V=x; yq -i '.field = strenv(V)' файл.yaml
