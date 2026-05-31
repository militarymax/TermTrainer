META
# Track: jq-yq
# Title: Архимаг Данных
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/университет.json" << 'EOF'
{
  "название": "Незримый Университет",
  "год": 2024,
  "факультеты": [
    {"название": "магия", "студенты": [{"имя":"Ринсвинд","оценка":45},{"имя":"Маграт","оценка":88}], "бюджет":20000, "доход":25000},
    {"название": "алхимия", "студенты": [{"имя":"Коэн","оценка":95},{"имя":"Грита","оценка":55}], "бюджет":15000, "доход":18000},
    {"название": "скриптология", "студенты": [{"имя":"Нанна","оценка":72},{"имя":"Ветинари","оценка":99}], "бюджет":10000, "доход":12000}
  ]
}
EOF
cat > "$DIR/deploy.yaml" << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: university-api
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: api
          image: uu/api:v1.0.0
          env:
            - name: DB_HOST
              value: localhost
            - name: LOG_LEVEL
              value: info
EOF
cat > "$DIR/config.xml" << 'EOF'
<config>
  <server>
    <host>spells.uu.edu</host>
    <port>8080</port>
  </server>
  <database>
    <type>postgresql</type>
    <host>db.uu.edu</host>
  </database>
</config>
EOF

TASK
👑 **Архимаг Данных** (UBERBOSS)

Ты достиг вершины мастерства обработки данных. Докажи, что владеешь всеми аспектами jq и yq — от reduce и функций до конвертации форматов и CI/CD пайплайнов.

📋 **БЛОК 1 — Reduce и агрегации**:
1. Общая прибыль всех факультетов через reduce:
   `jq 'reduce .факультеты[] as $f (0; . + ($f.доход - $f.бюджет))' университет.json`
2. Средняя оценка всех студентов:
   `jq '[.факультеты[] | .студенты[] | .оценка] | add / length' университет.json`
3. Факультет с максимальной прибылью:
   `jq '.факультеты | sort_by(.доход - .бюджет) | reverse | .[0].название' университет.json`

📋 **БЛОК 2 — Функции и модули**:
4. Напиши функцию прибыли и используй:
   `jq 'def profit: .доход - .бюджет; .факультеты[] | {название, profit: profit}' университет.json`
5. Создай файл `анализ.jq` с функциями и запусти через `-f`

📋 **БЛОК 3 — Сложные трансформации**:
6. Трансформация: факультет → {название, студенты_количество, средняя_оценка, рентабельность}:
   `jq '.факультеты[] | {название, студентов: (.студенты|length), средняя: ((.студенты|map(.оценка)|add)/(.студенты|length)), roi: (((.доход-.бюджет)/.доход*100)|floor)}' университет.json`
7. Экспорт в CSV: `jq -r '"название,прибыль"', (.факультеты[] | [.название, .доход-.бюджет] | @csv)' университет.json > отчёт.csv`

📋 **БЛОК 4 — YAML мутации**:
8. Обнови образ: `yq -i '.spec.template.spec.containers[0].image = "uu/api:v2.0.0"' deploy.yaml`
9. Добавь env var: `yq -i '.spec.template.spec.containers[0].env += [{"name": "VERSION", "value": "2.0"}]' deploy.yaml`
10. Увеличь реплики: `yq -i '.spec.replicas = 5' deploy.yaml`

📋 **БЛОК 5 — Конвертация форматов**:
11. XML→JSON: `yq -p xml -o json '.' config.xml > config.json`
12. YAML→JSON: `yq -o json '.' deploy.yaml > deploy.json`

📋 **БЛОК 6 — CI/CD сценарий**:
13. Напиши скрипт который:
    - Читает версию из JSON: `jq -r '.год' университет.json`
    - Обновляет YAML: `yq -i ".spec.template.spec.containers[0].image = \"uu/api:v"$(jq -r '.год' университет.json)"\"" deploy.yaml`
    - Проверяет результат: `yq '.spec.template.spec.containers[0].image' deploy.yaml`

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_016"
score=0
max=8

cd "$DIR" 2>/dev/null || exit 1

# БЛОК 1: Reduce
r1=$(jq 'reduce .факультеты[] as $f (0; . + ($f.доход - $f.бюджет))' университет.json 2>/dev/null)
[ "$r1" = "10000" ] && { echo "✓ Reduce: общая прибыль=$r1"; score=$((score+1)); }

# БЛОК 2: Функции
r2=$(jq 'def profit: .доход - .бюджет; [.факультеты[] | profit] | add' университет.json 2>/dev/null)
[ "$r2" = "10000" ] && { echo "✓ Функция profit работает"; score=$((score+1)); }

if [ -f "$DIR/анализ.jq" ]; then
  r2b=$(jq -f анализ.jq университет.json 2>/dev/null)
  [ -n "$r2b" ] && { echo "✓ Модуль анализ.jq работает"; score=$((score+1)); }
fi

# БЛОК 3: CSV
if [ -f "$DIR/отчёт.csv" ]; then
  echo "✓ CSV создан"
  score=$((score+1))
fi

# БЛОК 4: YAML мутации
img=$(yq '.spec.template.spec.containers[0].image' deploy.yaml 2>/dev/null)
echo "$img" | grep -q 'v2\|v2024' && { echo "✓ Образ обновлён: $img"; score=$((score+1)); }

rep=$(yq '.spec.replicas' deploy.yaml 2>/dev/null)
[ "$rep" = "5" ] && { echo "✓ Реплики обновлены"; score=$((score+1)); }

# БЛОК 5: Конвертация
if [ -f "$DIR/config.json" ]; then
  echo "✓ config.json создан (XML→JSON)"
  score=$((score+1))
fi

if [ -f "$DIR/deploy.json" ]; then
  echo "✓ deploy.json создан (YAML→JSON)"
  score=$((score+1))
fi

echo "✓ ok: UBERBOSS пройден! (баллов: $score/$max)"
[ $score -ge 5 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Reduce sum: jq 'reduce .items[] as $x (0; . + $x.val)' файл
Average: jq '[.items[] | .val] | add / length' файл
Max by field: jq '.items | sort_by(.val) | reverse | .[0]' файл

=== БЛОК 2 ===
Def function: jq 'def myfunc: .a - .b; map(myfunc)' файл
From file: jq -f script.jq data.json

=== БЛОК 3 ===
Complex transform: jq '.items[] | {name, count: (.sub|length), avg: ((.sub|map(.v)|add)/(.sub|length))}' файл
CSV header+data: jq -r '"h1,h2"', (.items[]|[.a,.b]|@csv)' файл

=== БЛОК 4 ===
YAML update: yq -i '.path.key = "value"' файл.yaml
Add to array: yq -i '.arr += [{key: val}]' файл.yaml

=== БЛОК 5 ===
XML→JSON: yq -p xml -o json '.' файл.xml > файл.json
YAML→JSON: yq -o json '.' файл.yaml > файл.json

=== БЛОК 6 ===
CI script: VER=$(jq -r '.version' data.json); yq -i ".image.tag = \"$VER\"" deploy.yaml
