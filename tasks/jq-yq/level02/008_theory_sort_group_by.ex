META
# Track: jq-yq
# Title: Сортировка и группировка свитков
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/potions.json" << 'EOF'
{
  "склад": [
    {"имя": "невидимость", "цена": 100, "тип": "подкрепление"},
    {"имя": "огненный_шар", "цена": 300, "тип": "атака"},
    {"имя": "лечение", "цена": 50, "тип": "подкрепление"},
    {"имя": "щит", "цена": 200, "тип": "защита"},
    {"имя": "молния", "цена": 250, "тип": "атака"},
    {"имя": "телепорт", "цена": 500, "тип": "утилита"}
  ]
}
EOF

TASK
📜 **Сортировка и группировка свитков**

Казначей хочет видеть зелья отсортированными по цене, сгруппированными по типу и уникальными. А ещё — экспортировать в CSV.

📖 **Сортировка**:
• `sort` — отсортировать массив (числа по возрастанию, строки по алфавиту)
• `sort_by(.поле)` — сортировать по полю: `jq '.склад | sort_by(.цена)' файл`
• Обратный порядок: `jq '.склад | sort_by(.цена) | reverse' файл`

📖 **Уникализация**:
• `unique` — оставить уникальные элементы массива
• `unique_by(.поле)` — уникальные по полю

📖 **Группировка**:
• `group_by(.поле)` — разбить массив на группы: `jq '.склад | group_by(.тип)' файл`

📖 **Форматирование строк**:
• `@csv` — вывести как CSV строку
• `@html`, `@uri`, `@sh`, `@base64` — другие форматы
• Пример CSV: `jq -r '.склад[] | [.имя, .цена, .тип] | @csv' файл`

📖 **Переменные**:
• `--arg name value` — передать переменную: `jq --arg n "магия" '.[] | select(.тип == $n)' файл`

📂 Рабочий каталог: `~/.termtrainer/jqyq_008`

📋 **Попробуй**:
1. По цене: `jq '.склад | sort_by(.цена)' potions.json`
2. Дорогие сначала: `jq '.склад | sort_by(.цена) | reverse' potions.json`
3. Группировка по типу: `jq '.склад | group_by(.тип) | map({тип: .[0].тип, количество: length})' potions.json`
4. Экспорт CSV: `jq -r '.склад[] | [.имя, .цена, .тип] | @csv' potions.json`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_008"
score=0

r1=$(jq '.склад | sort_by(.цена) | .[0].имя' "$DIR/potions.json" 2>/dev/null)
[ "$r1" = '"лечение"' ] && { echo "✓ sort_by работает"; score=$((score+1)); }

r2=$(jq '[.склад[] | .тип] | unique | length' "$DIR/potions.json" 2>/dev/null)
[ "$r2" -ge 3 ] && { echo "✓ unique работает ($r2 типа)"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Сортировка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Sort by: jq '.array | sort_by(.field)' файл
Reverse: jq '.array | sort_by(.field) | reverse' файл
Unique: jq '[.items[] | .type] | unique' файл
Group by: jq '.items | group_by(.type)' файл — разбить на группы
CSV export: jq -r '.items[] | [.name, .price] | @csv' файл
Arg: jq --arg name "value" '.[] | select(.field == $name)' файл
