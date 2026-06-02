META
# Track: scripting
# Title: Ритуалы и ловушки
# Number: 009
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/logs"
for i in $(seq 1 10); do
  types=("CAST" "CAST" "CAST" "FAIL" "WARN")
  t=${types[$((RANDOM % ${#types[@]}))]}
  echo "[$(date +%H:%M:%S)] $t spell_$i power=$((RANDOM%100))" >> "$DIR/logs/magic.log"
done

TASK
⚗️ ПРАКТИКУМ #009: Ритуалы и ловушки

Декан Чартер вызвал тебя в лабораторию:
«Ринсвинд! Астрологи жалуются — их заклинания ломаются,
потому что никто не убирает за собой временные файлы.
И функции! Никто не пишет функции! Всё копипастят!
Напиши ПРАВИЛЬНЫЙ скрипт с функциями, trap и local.»

📋 **Задания**:

1. **Напиши `log_parser.sh`** с функциями:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   # Функция логирования
   log_info()  { printf "[INFO]  %s\n" "$1"; }
   log_error() { printf "[ERROR] %s\n" "$1" >&2; }  # Ошибки на stderr!
   
   # Функция парсинга логов
   parse_log() {
       local file="$1"        # local — только внутри функции!
       local count=0
       
       if [[ ! -f "$file" ]]; then
           log_error "Log file not found: $file"
           return 1           # return для функций (не exit!)
       fi
       
       while IFS= read -r line; do
           if [[ "$line" == *"FAIL"* ]]; then
               log_error "Failure detected: $line"
               ((count++))
           fi
       done < "$file"
       
       echo "$count"          # Возврат значения через echo
   }
   
   # Главная функция
   main() {
       local logfile="${1:-logs/magic.log}"
       log_info "Parsing $logfile..."
       
       local failures
       failures=$(parse_log "$logfile")   # Захват вывода функции
       
       log_info "Found $failures failure(s)"
   }
   
   main "$@"
   ```

2. **Добавь trap для очистки**:
   ```bash
   tempfile=$(mktemp)
   
   cleanup() {
       rm -f "$tempfile"
       log_info "Cleanup complete"
   }
   trap cleanup EXIT
   ```

3. **Запусти**: `chmod +x log_parser.sh && ./log_parser.sh`

📂 Рабочий каталог: `~/.termtrainer/scripting_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_009"
score=0

if [ -f "$DIR/log_parser.sh" ]; then
  head -1 "$DIR/log_parser.sh" | grep -q '^#!' && { echo "✓ Шебанг есть"; score=$((score+1)); }
  
  grep -q 'set -euo\|set -e' "$DIR/log_parser.sh" && { echo "✓ set -e используется"; score=$((score+1)); }
  
  grep -q 'local ' "$DIR/log_parser.sh" && { echo "✓ local переменные есть"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Функции и trap освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Напиши log_parser.sh с функциями (баллов: $score/3)"
exit 1

HINTS
Функция: myfunc() { ... } — определение функции
local: local var="$1" — переменная видна только внутри функции
return N: вернуть код из функции (не exit — он завершит весь скрипт!)
Возврат строки: echo "value" в функции → result=$(myfunc) для захвата
stderr: echo "error" >&2 — ошибки на stderr, не на stdout!
trap cleanup EXIT: функция выполнится при любом выходе из скрипта
mktemp: создать безопасный временный файл
set -euo pipefail: священная троица в начале каждого скрипта
