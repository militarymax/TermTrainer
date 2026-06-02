META
# Track: scripting
# Title: Архимаг Скриптологии
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/logs" "$DIR/configs" "$DIR/libs" "$DIR/reports"
for i in $(seq 1 20); do
  types=("CAST" "CAST" "CAST" "CAST" "FAIL" "WARN")
  t=${types[$((RANDOM % ${#types[@]}))]}
  spells=("fireball" "heal" "teleport" "shield" "curse" "summon" "dispel")
  s=${spells[$((RANDOM % ${#spells[@]}))]}
  echo "$(date +%Y-%m-%d) $((RANDOM%24)):$((RANDOM%60)):$((RANDOM%60)) $t $s power=$((RANDOM%100)) target=tower_$((RANDOM%10))" >> "$DIR/logs/magic.log"
done
cat > "$DIR/configs/tower.conf" << 'EOF'
TOWER_NAME=Unseen University
MAX_STUDENTS=200
ALERT_THRESHOLD=80
LOG_DIR=logs
OUTPUT_DIR=reports
PARALLEL_JOBS=4
SECRET_KEY=arcane_password_123
EOF
cat > "$DIR/libs/utils.sh" << 'EOF'
#!/bin/bash
# Library of Unseen University utilities

log_info() {
    printf "[INFO]  %s: %s\n" "$(date +%H:%M:%S)" "$1"
}

log_error() {
    printf "[ERROR] %s: %s\n" "$(date +%H:%M:%S)" "$1" >&2
}

log_debug() {
    [[ "${DEBUG:-0}" == "1" ]] && printf "[DEBUG] %s: %s\n" "$(date +%H:%M:%S)" "$1" >&2
    return 0
}

check_file() {
    [[ -f "$1" ]] && return 0
    log_error "File not found: $1"
    return 1
}

count_pattern() {
    local file="$1" pattern="$2"
    grep -c "$pattern" "$file" 2>/dev/null || echo 0
}
EOF

TASK
👑 UBERBOSS #016: Архимаг Скриптологии

Архиканцлер вызвал тебя на Самый Верхний Этаж Башни.
Ветер свистел в разбитых окнах. Он сказал:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Напиши систему,
которая читает конфигурацию, парсит логи параллельно,
генерирует отчёт и работает БЕЗОПАСНО.
Используй ВСЁ: функции, массивы, trap, fd, regex, модульность.
Если справишься — ты Архимаг. Если нет... ну, подвала
всегда нужны новые крысы. Предыдущие сбежали.»

📋 **БЛОК 1 — Библиотека функций**:
Подключи `libs/utils.sh` через source:
```bash
source "${SCRIPT_DIR}/libs/utils.sh"
```
Проверь что файл существует перед source!

📋 **БЛОК 2 — Безопасное чтение конфигурации**:
Прочитай `configs/tower.conf` в ассоциативный массив:
- Валидируй ключи через regex
- Скрыть SECRET_* значения в отчёте
- Используй `${var:?error}` для обязательных параметров

📋 **БЛОК 3 — Параллельный парсинг логов**:
Обработай `logs/magic.log` с ограничением параллелизма:
- Используй mkfifo + exec для пула задач
- Или простой подход с wait -n
- Собери статистику: CAST/FAIL/WARN counts

📋 **БЛОК 4 — Генерация отчёта**:
Создай `reports/full_report.txt`:
```bash
═══════════════════════════════════════
   TOWER MONITOR — FULL REPORT
═══════════════════════════════════════
Date: ...
Tower: Unseen University
Max Students: 200
Alert Threshold: 80%
Secret Key: ***HIDDEN***

--- Log Statistics ---
Total entries: XX
CAST: XX (XX%)
FAIL: XX (XX%)
WARN: XX (XX%)

⚠️ FAILURES DETECTED! / ✅ All stable.

--- Performance ---
Processing time: X.XX seconds
Parallel jobs used: 4
═══════════════════════════════════════
```

📋 **БЛОК 5 — Отладка и надёжность**:
- `set -euo pipefail` обязательно!
- `trap cleanup EXIT` для временных файлов
- Поддержка `DEBUG=1 ./script.sh` для трассировки
- Интерактивное меню через `select`:
  ```

ASSIGNMENT
   Tower Monitor Menu:
   1) Show config
   2) Parse logs
   3) Generate report
   4) Full run
   5) Exit
  ```

📂 Рабочий каталог: `~/.termtrainer/scripting_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_016"
score=0
max=6

[ -f "$DIR/libs/utils.sh" ] && { echo "✓ Библиотека utils.sh есть"; score=$((score+1)); }

if [ -f "$DIR/configs/tower.conf" ]; then
  grep -q "SECRET_KEY" "$DIR/configs/tower.conf" && { echo "✓ Конфигурация существует"; score=$((score+1)); }
fi

[ -f "$DIR/logs/magic.log" ] && [ -s "$DIR/logs/magic.log" ] && { echo "✓ Логи существуют"; score=$((score+1)); }

if [ -f "$DIR/reports/full_report.txt" ]; then
  cat "$DIR/reports/full_report.txt" | grep -qi "tower\|report\|CAST\|FAIL\|WARN\|HIDDEN" && { echo "✓ Полный отчёт создан"; score=$((score+1)); }
fi

main_script=$(find "$DIR" -maxdepth 1 -name "*.sh" -type f | head -1)
if [ -n "$main_script" ]; then
  head -1 "$main_script" | grep -q '^#!' && { echo "✓ Главный скрипт имеет шебанг"; score=$((score+1)); }
  grep -q 'set -euo\|set -e' "$main_script" && { echo "✓ set -e используется"; score=$((score+1)); }
fi

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 4 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
source libs/utils.sh: подключить библиотеку функций
Проверка перед source: [[ -f file ]] && source file || { echo error; exit 1; }

=== БЛОК 2 ===
declare -A config: ассоциативный массив для KEY=VALUE
Валидация ключей: regex ^[A-Za-z_][A-Za-z0-9_]*$
Скрытие секретов: если ключ содержит SECRET/PASSWORD → вывести ***HIDDEN***
${var:?error}: обязательный параметр — прервать если пуст

=== БЛОК 3 ===
mkfifo + exec 3<>: именованный канал для пула задач
read -u 3: взять токен, echo >&3: вернуть токен
wait: дождаться всех фоновых задач

=== БЛОК 4 ===
Отчёт: заголовок + конфигурация + статистика + статус
Проценты: echo $(( count * 100 / total ))%

=== БЛОК 5 ===
set -euo pipefail: священная троица
trap cleanup EXIT: очистка при любом выходе
DEBUG=1: условная трассировка через log_debug
select var in list; do ... break; done: интерактивное меню
