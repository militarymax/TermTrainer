META
# Track: jq-yq
# Title: Оптимизация конвейеров
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/servers.json" << 'EOF'
{
  "окружение": "production",
  "серверы": [
    {"имя": "spell-api-1", "статус": "ok", "cpu": 45, "память": 60, "регион": "eu"},
    {"имя": "spell-api-2", "статус": "ok", "cpu": 72, "память": 85, "регион": "eu"},
    {"имя": "spell-worker-1", "статус": "error", "cpu": 95, "память": 90, "регион": "us"},
    {"имя": "spell-db-1", "статус": "ok", "cpu": 30, "память": 45, "регион": "eu"},
    {"имя": "spell-cache-1", "статус": "warning", "cpu": 88, "память": 78, "регион": "us"},
    {"имя": "spell-queue-1", "статус": "ok", "cpu": 55, "память": 40, "регион": "asia"}
  ]
}
EOF

TASK
⚡ **Оптимизация конвейеров**

Казначей обрабатывает тысячи записей. Неоптимальные запросы — потерянное время. Научись писать быстрые конвейеры.

📋 **Задания**:
1. **Select раньше** — фильтруй как можно раньше:
   Плохо: `jq '.серверы | map(select(.статус == "ok")) | map(.имя)' servers.json`
   Хорошо: `jq '[.серверы[] | select(.статус == "ok") | .имя]' servers.json`

2. **Компактный вывод**: `jq -c '.' servers.json` — всё в одну строку

3. **Серверы с высокой нагрузкой** (CPU>70 ИЛИ память>80):
   `jq '[.серверы[] | select(.cpu > 70 or .память > 80)]' servers.json`

4. **Статистика по регионам**:
   `jq '.серверы | group_by(.регион) | map({регион: .[0].регион, количество: length, средний_cpu: (map(.cpu) | add / length)})' servers.json`

5. **Пакетная обработка нескольких файлов**:
   Создай второй JSON и попробуй: `jq -s '.' servers.json второй.json`
   
6. **Объединить с yq eval-all**:
   `yq eval-all 'select(fileIndex == 0)' файл1.yaml файл2.yaml`

💡 **Правила оптимизации**:
• `select` как можно раньше в конвейере
• Используй `[... | select(...)]` вместо `map(select(...))` — один проход
• `-c` для компактного вывода без пробелов
• `--stream` для огромных файлов (не загружает всё в память)

📂 Рабочий каталог: `~/.termtrainer/jqyq_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_014"
score=0

r1=$(jq '[.серверы[] | select(.cpu > 70)] | length' "$DIR/servers.json" 2>/dev/null)
[ "$r1" -ge 2 ] && { echo "✓ Фильтрация CPU>$r1"; score=$((score+1)); }

r2=$(jq -c '.' "$DIR/servers.json" 2>/dev/null | wc -l)
[ "$r2" -le 5 ] && { echo "✓ Компактный вывод ($r2 строк)"; score=$((score+1)); }

r3=$(jq '.серверы | group_by(.регион) | length' "$DIR/servers.json" 2>/dev/null)
[ "$r3" -ge 2 ] && { echo "✓ Группировка по $r3 регионам"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Оптимизация освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Ранний select: jq '[.items[] | select(.field > 50) | .name]' — фильтр до обработки
Compact: jq -c '.' файл — минифицированный JSON
Group + aggregate: jq '.items | group_by(.region) | map({region: .[0].region, avg: (map(.val)|add/length)})' файл
Slurp: jq -s '.' file1 file2 — объединить несколько JSON
Stream: jq --stream '.' большой_файл.json — поточная обработка
eval-all: yq eval-all 'select(fileIndex==0) * select(fileIndex==1)' a.yaml b.yaml
