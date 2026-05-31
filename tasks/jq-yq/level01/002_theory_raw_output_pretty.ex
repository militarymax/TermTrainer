META
# Track: jq-yq
# Title: Чистый пергамент и красивые свитки
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/potions.json" << 'EOF'
{
  "название": "Каталог зелий",
  "автор": "Казначейство УУ",
  "зелья": [
    {"имя": "невидимость", "цена": 100, "в наличии": true},
    {"имя": "сила", "цена": 150, "в наличии": false},
    {"имя": "мудрость", "цена": 200, "в наличии": true}
  ]
}
EOF
cat > "$DIR/config.yaml" << 'EOF'
университет:
  название: Незримый Университет
  ректор: Архиканцлер Ридкулли
  факультеты:
    - магия
    - алхимия
    - скриптология
EOF

TASK
📜 **Чистый пергамент и красивые свитки**

Казначей не терпит кавычек в отчётах и требует аккуратного форматирования. Научись извлекать данные без мусора и красиво форматировать.

📖 **Raw output (-r / --raw-output)**:
• `jq '.автор' файл` → `"Казначейство УУ"` (с кавычками!)
• `jq -r '.автор' файл` → `Казначейство УУ` (без кавычек)
• Всегда используй `-r` когда нужен чистый текст для скриптов

📖 **Pretty print**:
• `jq '.' файл.json` — форматировать JSON с отступами
• `yq -P '.' файл.yaml` — форматировать YAML красиво
• `yq '.' файл.yaml` — вывести YAML как есть

📖 **Конвертация форматов**:
• `yq -o json '.' файл.yaml` — YAML → JSON
• `yq -o yaml '.' файл.json` — JSON → YAML (если yq поддерживает)

📖 **Несколько входных файлов**:
• `jq '.' ф1.json ф2.json` — обработать оба файла

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_002`

📋 **Попробуй**:
1. С кавычками: `jq '.название' potions.json`
2. Без кавычек: `jq -r '.название' potions.json`
3. Pretty YAML: `yq -P '.' config.yaml`
4. Конвертация: `yq -o json '.' config.yaml`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_002"
score=0

if [ -f "$DIR/potions.json" ] && [ -f "$DIR/config.yaml" ]; then
  echo "✓ Файлы данных на месте"
  score=$((score+1))
fi

result=$(jq -r '.название' "$DIR/potions.json" 2>/dev/null)
[ "$result" = "Каталог зелий" ] && { echo "✓ -r работает корректно"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Чистый пергамент освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
С кавычками: jq '.ключ' файл → "значение"
Без кавычек: jq -r '.ключ' файл → значение
Pretty JSON: jq '.' файл.json — с отступами и переносами
Compact: jq -c '.' файл.json — всё в одну строку
Pretty YAML: yq -P '.' файл.yaml
YAML→JSON: yq -o json '.' файл.yaml
JSON→YAML: yq -o yaml '.' файл.json
