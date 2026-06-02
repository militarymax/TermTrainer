META
# Track: jq-yq
# Title: Условные заклинания
# Number: 010
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/spells.json" << 'EOF'
{
  "заклинания": [
    {"имя": "огненный_шар", "сила": 90, "тип": "атака", "мана": 50},
    {"имя": "лечение", "сила": 40, "тип": "поддержка", "мана": 30},
    {"имя": "щит_веры", "сила": 70, "тип": "защита", "мана": 40},
    {"имя": "телепорт", "сила": 95, "тип": "утилита", "мана": 80},
    {"имя": "малый_огонь", "сила": 20, "тип": "атака", "мана": 10}
  ]
}
EOF

TASK
🔀 **Условные заклинания**

Разным заклинаниям — разные оценки. Научись применять условия и работать с потоками данных.

📋 **Задания**:
1. Классифицируй заклинания по силе:
   `jq '.заклинания[] | {имя, ранг: (if .сила > 80 then "S" elif .сила > 50 then "A" else "B" end)}' spells.json`

2. Только атакующие с силой >50:
   `jq '.заклинания[] | select(.тип == "атака" and .сила > 50)' spells.json`

3. Добавь поле "эффективность" (сила / мана):
   `jq '.заклинания[] | . + {эффективность: (.сила / .мана)}' spells.json`

4. Используй --slurp для объединения двух файлов:
   Создай второй JSON и попробуй: `jq -s '.' ф1.json ф2.json`

5. Рекурсивный поиск всех значений "сила":
   `jq '.. | .сила? // empty' spells.json`

📖 **Условия**:
• `if A then B elif C then D else E end`
• Операторы: `==`, `!=`, `>`, `<`, `>=`, `<=`, `and`, `or`, `not`

📖 **Рекурсивный спуск**:
• `..` — обойти все уровни вложенности
• `.. | .ключ?` — найти все значения ключа на любой глубине

📂 Рабочий каталог: `~/.termtrainer/jqyq_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_010"
score=0

r1=$(jq '[.заклинания[] | select(.сила > 80)] | length' "$DIR/spells.json" 2>/dev/null)
[ "$r1" -ge 2 ] && { echo "✓ Select + условие работает"; score=$((score+1)); }

r2=$(jq '.заклинания[] | if .сила > 80 then "S" else "other" end' "$DIR/spells.json" 2>/dev/null | grep -c 'S')
[ "$r2" -ge 2 ] && { echo "✓ If/then работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Условные заклинания освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
If/then: jq '.items[] | if .x > 80 then "high" elif .x > 50 then "mid" else "low" end' файл
And/or: jq '.[] | select(.type == "attack" and .power > 50)' файл
Добавить поле: jq '.[] | . + {new_field: (.a / .b)}' файл
Slurp: jq -s '.' file1.json file2.json — объединить в массив
Recursive descent: jq '.. | .field? // empty' файл — найти на любой глубине
