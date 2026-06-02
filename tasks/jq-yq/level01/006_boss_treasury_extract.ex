META
# Track: jq-yq
# Title: Отчёт Казначея
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/budget.json" << 'EOF'
{
  "год": 2024,
  "университет": "Незримый Университет",
  "факультеты": [
    {"название": "магия", "студенты": 80, "бюджет": 20000, "доход": 25000},
    {"название": "алхимия", "студенты": 60, "бюджет": 15000, "доход": 18000},
    {"название": "скриптология", "студенты": 40, "бюджет": 10000, "доход": 12000},
    {"название": "гитология", "студенты": 20, "бюджет": 5000, "доход": 8000}
  ],
  "общий_бюджет": {
    "расходы": 50000,
    "доходы": 63000,
    "профицит": true
  }
}
EOF
cat > "$DIR/config.yaml" << 'EOF'
сервер:
  хост: spells.uu.edu
  порт: 8080
  версия: v2.1.0
база_данных:
  тип: postgresql
  хост: db.uu.edu
  порт: 5432
логирование:
  уровень: info
  файл: /var/log/spells.log
EOF

TASK
🐉 **Отчёт Казначея** (БОСС)

Архиканцлер требует полный финансовый отчёт из JSON и конфигурацию сервера из YAML. Покажи что ты умеешь извлекать любые данные!

ASSIGNMENT
📋 **Боевые задания**:
1. Извлеки год без кавычек: `jq -r '.год' budget.json`
2. Все названия факультетов: `jq -r '.факультеты[] | .название' budget.json`
3. Количество факультетов: `jq '.факультеты | length' budget.json`
4. Бюджет магии: `jq '.факультеты[0].бюджет' budget.json`
5. Построй отчёт — только названия и студенты: `jq '.факультеты[] | {название, студенты}' budget.json`
6. Есть ли профицит: `jq -r '.общий_бюджет.профицит' budget.json`
7. Извлеки версию сервера из YAML: `yq '.сервер.версия' config.yaml`
8. Порт БД из YAML: `yq '.база_данных.порт' config.yaml`
9. Конвертируй YAML в JSON и сохрани: `yq -o json '.' config.yaml > config.json`

📂 Рабочий каталог: `~/.termtrainer/jqyq_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_006"
score=0

r1=$(jq -r '.год' "$DIR/budget.json" 2>/dev/null)
[ "$r1" = "2024" ] && { echo "✓ Год извлечён"; score=$((score+1)); }

r2=$(jq -r '.факультеты[] | .название' "$DIR/budget.json" 2>/dev/null | wc -l)
[ "$r2" -ge 4 ] && { echo "✓ Все $r2 факультета"; score=$((score+1)); }

r3=$(jq '.факультеты | length' "$DIR/budget.json" 2>/dev/null)
[ "$r3" = "4" ] && { echo "✓ Length корректен"; score=$((score+1)); }

r4=$(yq '.сервер.версия' "$DIR/config.yaml" 2>/dev/null)
[ "$r4" = "v2.1.0" ] && { echo "✓ Версия из YAML"; score=$((score+1)); }

[ -f "$DIR/config.json" ] && { echo "✓ JSON создан"; score=$((score+1)); }

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Казначей доволен! (баллов: $score/5)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/5)"
exit 1

HINTS
Без кавычек: jq -r '.ключ' файл
Все элементы массива: jq '.массив[] | .поле' файл
Длина: jq '.массив | length' файл
Новый объект: jq '.items[] | {name, count}' файл
YAML поле: yq '.путь.к.полю' файл.yaml
YAML→JSON: yq -o json '.' файл.yaml > файл.json
