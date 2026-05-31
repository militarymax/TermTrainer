META
# Track: scripting
# Title: Монитор Башни
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/логи" "$DIR/отчёты"
for i in $(seq 1 20); do
  types=("CAST" "CAST" "CAST" "FAIL" "WARN")
  t=${types[$((RANDOM % ${#types[@]}))]}
  spells=("fireball" "heal" "teleport" "invisibility" "shield" "curse")
  s=${spells[$((RANDOM % ${#spells[@]}))]}
  echo "[$(date +%Y-%m-%d) $((RANDOM%24)):$((RANDOM%60)):$((RANDOM%60))] $t $s power=$((RANDOM%100))" >> "$DIR/логи/магия.log"
done
echo "[2024-01-15 09:00:00] CAST fireball power=99 target=goblin" >> "$DIR/логи/магия.log"
echo "[2024-01-15 10:00:00] FAIL curse reason=invalid_target" >> "$DIR/логи/магия.log"
echo "[2024-01-15 11:00:00] WARN mana_low level=5" >> "$DIR/логи/магия.log"
cat > "$DIR/конфиг.conf" << 'EOF'
TOWER_NAME=Tower of Art
MAX_FLOORS=200
ALERT_THRESHOLD=80
LOG_DIR=логи
OUTPUT_DIR=отчёты
EOF

TASK
🐉 **Монитор Башни** (БОСС)

Башня Искусств нуждается в системе мониторинга. Архиканцлер хочет знать: сколько заклинаний успешно, сколько провалилось, какие предупреждения критичны. Напиши надёжный скрипт-монитор с функциями, trap, массивами и regex.

📋 **Боевые задания**:
1. Создай скрипт `monitor.sh` с `set -euo pipefail` который:
   - Определяет функцию `cleanup()` и устанавливает `trap cleanup EXIT`
   - Использует `mktemp` для временных файлов

2. Добавь функцию `parse_config()`:
   - Читает `конфиг.conf` через `while read`
   - Пропускает пустые строки и комментарии
   - Сохраняет ключи и значения в ассоциативный массив или обычные переменные
   - Возвращает настройки через `echo`

3. Добавь функцию `analyze_logs()`:
   - Читает лог-файл построчно
   - С помощью `[[ =~ ]]` извлекает тип (CAST/FAIL/WARN) и заклинание
   - Подсчитывает количество каждого типа
   - Хранит результаты в массивах
   - Выводит статистику через `printf`

4. Добавь функцию `generate_report()`:
   - Принимает данные анализа как аргументы
   - Формирует отчёт с заголовком, датой, статистикой
   - Записывает в `$OUTPUT_DIR/отчёт_$(date +%Y%m%d).txt`
   - Ошибки пишет в stderr через `>&2`

5. Запусти монитор и сохрани результат в `отчёты/итог.txt`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_011"
score=0

if [ -f "$DIR/monitor.sh" ]; then
  echo "✓ monitor.sh создан"
  score=$((score+1))
  
  grep -q 'set -e' "$DIR/monitor.sh" && { echo "✓ set -e"; score=$((score+1)); }
  grep -q 'trap' "$DIR/monitor.sh" && { echo "✓ trap"; score=$((score+1)); }
  grep -qE 'parse_config|analyze_logs|generate_report' "$DIR/monitor.sh" && { echo "✓ Функции определены"; score=$((score+1)); }
  grep -q '=~' "$DIR/monitor.sh" && { echo "✓ Regex используется"; score=$((score+1)); }
  grep -q 'mktemp' "$DIR/monitor.sh" && { echo "✓ mktemp"; score=$((score+1)); }
fi

if [ -f "$DIR/отчёты/итог.txt" ]; then
  echo "✓ Итоговый отчёт создан"
  score=$((score+1))
fi

[ $score -ge 5 ] && { echo "✓ ok: БОСС пройден! Монитор Башни работает! (баллов: $score/7)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/7)"
exit 1

HINTS
Функция с возвратом: get_name() { echo "Tower"; }; name=$(get_name)
trap + cleanup: cleanup() { rm -f "$tmpfile"; }; trap cleanup EXIT
Regex для лога: if [[ "$line" =~ \[([0-9-]+)\]\ (CAST|FAIL|WARN)\ (.+)$ ]]; then type="${BASH_REMATCH[2]}"; fi
Printf форматирование: printf "%-15s %5d\n" "CAST:" "$cast_count"
Запись ошибки в stderr: echo "Ошибка!" >&2
Дата в имени файла: report="отчёт_$(date +%Y%m%d).txt"
