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
DIR="$HOME/.termtrainer/scripting_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/logs" "$DIR/reports"
for i in $(seq 1 20); do
  types=("CAST" "CAST" "CAST" "CAST" "FAIL" "WARN")
  t=${types[$((RANDOM % ${#types[@]}))]}
  spells=("fireball" "heal" "teleport" "shield" "curse" "summon" "dispel")
  s=${spells[$((RANDOM % ${#spells[@]}))]}
  echo "$(date +%Y-%m-%d) $((RANDOM%24)):$((RANDOM%60)):$((RANDOM%60)) $t $s power=$((RANDOM%100)) target=tower_$((RANDOM%10))" >> "$DIR/logs/magic.log"
done

TASK
🐉 БОСС #011: Монитор Башни

Архиканцлер вызвал тебя в свой кабинет:
«Ринсвинд! В Башне происходят странные вещи — заклинания падают,
демоны вырываются, а никто не знает ПОЧЕМУ. Мне нужен скрипт,
который анализирует логи Башни, считает ошибки и генерирует отчёт.
И чтобы с функциями! И с trap! И без кактусов на этот раз!»

📋 **Боевые задания**:

ASSIGNMENT
1. **Напиши `tower_monitor.sh`** который:
   - Использует `set -euo pipefail`
   - Имеет функции: `log_info`, `log_error`, `parse_failures`, `generate_report`
   - Использует `local` для всех переменных в функциях
   - Использует `trap` для очистки временных файлов
   - Читает лог из `logs/magic.log`
   - Считает CAST, FAIL, WARN через массивы и regex
   - Генерирует отчёт в `reports/report.txt`

2. **Структура скрипта**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   LOGFILE="${1:-logs/magic.log}"
   REPORT="${2:-reports/report.txt}"
   
   log_info()  { printf "[INFO]  %s\n" "$1"; }
   log_error() { printf "[ERROR] %s\n" "$1" >&2; }
   
   cleanup() {
       rm -f "$tempfile"
       log_info "Cleanup complete"
   }
   trap cleanup EXIT
   
   parse_log() {
       local file="$1"
       local cast=0 fail=0 warn=0
       while IFS= read -r line; do
           if [[ "$line" == *"FAIL"* ]]; then ((fail++))
           elif [[ "$line" == *"WARN"* ]]; then ((warn++))
           elif [[ "$line" == *"CAST"* ]]; then ((cast++)); fi
       done < "$file"
       echo "$cast $fail $warn"    # Возврат трёх значений
   }
   
   generate_report() {
       local file="$1"
       local stats="$2"  # "cast fail warn"
       local -a counts=($stats)
       
       {
           echo "═══ Tower Monitor Report ═══"
           echo "Date: $(date)"
           echo "Log file: $file"
           echo ""
           printf "CAST:  %d\n" "${counts[0]}"
           printf "FAIL:  %d\n" "${counts[1]}"
           printf "WARN:  %d\n" "${counts[2]}"
           echo ""
           if [[ "${counts[1]}" -gt 0 ]]; then
               echo "⚠️  FAILURES DETECTED!"
           else
               echo "✅ All spells stable."
           fi
       } > "$REPORT"
   }
   
   main() {
       log_info "Starting Tower Monitor..."
       [[ ! -f "$LOGFILE" ]] && { log_error "No log file"; exit 1; }
       
       local stats
       stats=$(parse_log "$LOGFILE")
       generate_report "$LOGFILE" "$stats"
       
       log_info "Report saved to $REPORT"
       cat "$REPORT"
   }
   
   main "$@"
   ```

3. **Запусти**: `chmod +x tower_monitor.sh && ./tower_monitor.sh`

📂 Рабочий каталог: `~/.termtrainer/scripting_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_011"
score=0

if [ -f "$DIR/tower_monitor.sh" ]; then
  chmod +x "$DIR/tower_monitor.sh"
  
  head -1 "$DIR/tower_monitor.sh" | grep -q '^#!' && { echo "✓ Шебанг есть"; score=$((score+1)); }
  grep -q 'set -euo\|set -e' "$DIR/tower_monitor.sh" && { echo "✓ set -e используется"; score=$((score+1)); }
  grep -q 'local ' "$DIR/tower_monitor.sh" && { echo "✓ local переменные"; score=$((score+1)); }
  grep -q 'trap' "$DIR/tower_monitor.sh" && { echo "✓ trap используется"; score=$((score+1)); }
fi

[ -f "$DIR/reports/report.txt" ] && grep -q "CAST\|FAIL\|Tower" "$DIR/reports/report.txt" && { echo "✓ Отчёт создан"; score=$((score+1)); }

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Монитор Башни работает! (баллов: $score/5)"; exit 0; }
echo "✗ Напиши tower_monitor.sh (баллов: $score/5)"
exit 1

HINTS
set -euo pipefail: священная троица безопасности
Функции: myfunc() { ... } — разбей код на логические блоки
local: ВСЕ переменные внутри функций должны быть local!
trap cleanup EXIT: гарантированная очистка временных файлов
mktemp: создать безопасный временный файл
Возврат значений: echo "val" → result=$(func) для захвата
Массивы из строки: local -a arr=($string) — разбить строку в массив
printf: форматированный вывод вместо echo для надёжности
