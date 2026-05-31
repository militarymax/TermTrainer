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
DIR="$HOME/.ninja_trainer/scripting_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/логи" "$DIR/конфиги" "$DIR/библиотеки" "$DIR/отчёты"
for i in $(seq 1 15); do
  types=("CAST" "CAST" "CAST" "CAST" "FAIL" "WARN")
  t=${types[$((RANDOM % ${#types[@]}))]}
  spells=("fireball" "heal" "teleport" "invisibility" "shield" "curse" "summon" "dispel")
  s=${spells[$((RANDOM % ${#spells[@]}))]}
  echo "[$(date +%Y-%m-%d) $((RANDOM%24)):$((RANDOM%60)):$((RANDOM%60))] $t $s power=$((RANDOM%100)) target=unit_$((RANDOM%50))" >> "$DIR/логи/магия.log"
done
cat > "$DIR/конфиги/университет.conf" << 'EOF'
UNIVERSITY_NAME=Unseen University
MAX_STUDENTS=200
ALERT_THRESHOLD=80
LOG_DIR=логи
OUTPUT_DIR=отчёты
PARALLEL_JOBS=4
EOF
cat > "$DIR/библиотеки/utils.sh" << 'EOF'
# Библиотека утилит Незримого Университета
log_info() {
    printf "[INFO] %s: %s\n" "$(date +%H:%M:%S)" "$1"
}

log_error() {
    printf "[ERROR] %s: %s\n" "$(date +%H:%M:%S)" "$1" >&2
}

check_file() {
    [[ -f "$1" ]] && return 0 || return 1
}
EOF

TASK
👑 **Архимаг Скриптологии** (UBERBOSS)

Ты достиг вершины Башни. Архиканцлер поручает тебе создать полноценную систему: модульную библиотеку, параллельный обработчик логов, интерактивное меню и отладку. Это финальный экзамен — покажи мастерство!

📋 **Боевые задания**:

**БЛОК 1 — Модульная библиотека**:
1. Создай `библиотеки/lib_magic.sh` с функциями:
   - `parse_config()` — читает конфиг-файл в ассоциативный массив (`declare -A`)
   - `analyze_line()` — принимает строку лога, через `[[ =~ ]]` извлекает тип и заклинание
   - `format_report()` — формирует отчёт через `printf`
   - Добавь проверку: если скрипт запущен напрямую (`${BASH_SOURCE[0]} == ${0}`) — запустить тесты, иначе — только определить функции (используй `return` вместо `exit`)

2. Подключи библиотеку в основном скрипте через проверку:
   ```bash
   if [[ -f "библиотеки/lib_magic.sh" ]]; then source библиотекеки/lib_magic.sh; fi
   ```

**БЛОК 2 — Параллельный обработчик**:
3. Создай скрипт `processor.sh` который:
   - Читает конфиг через `parse_config()` из библиотеки
   - Использует `${var:?error}` для обязательных параметров
   - Обрабатывает лог-файл параллельно через mkfifo + exec 3<> + read -u 3
   - Количество параллельных задач берёт из конфига (PARALLEL_JOBS)
   - Результаты записывает в ассоциативный массив (счётчики CAST/FAIL/WARN)
   - Использует `mapfile` для чтения файла в массив

**БЛОК 3 — Отладка и безопасность**:
4. Добавь в processor.sh:
   - `trap cleanup EXIT` — удаление временных файлов и каналов
   - `trap 'echo "Error at line $LINENO in ${BASH_SOURCE[0]}"' ERR`
   - Безопасную обработку имён файлов (кавычки везде!)
   - Вывод стека вызовов через `caller` при ошибке

**БЛОК 4 — Интерактивное меню**:
5. Добавь `select` меню:
   - "Анализ логов" — запустить параллельный обработчик
   - "Показать статистику" — вывести результаты
   - "Отладка" — включить `set -x`, повторить анализ, выключить `set +x`
   - "Выход" — завершить с кодом 0

**БЛОК 5 — Финальный отчёт**:
6. Сохрани полный отчёт в `UBERBOSS_ОТЧЁТ.txt`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_016"
score=0
max=10

# БЛОК 1: Библиотека
if [ -f "$DIR/библиотеки/lib_magic.sh" ]; then
  echo "✓ lib_magic.sh создан"
  score=$((score+1))
  grep -q 'declare -A' "$DIR/библиотеки/lib_magic.sh" && { echo "✓ Ассоциативный массив"; score=$((score+1)); }
  grep -qE 'BASH_SOURCE|return' "$DIR/библиотеки/lib_magic.sh" && { echo "✓ Модульность (BASH_SOURCE/return)"; score=$((score+1)); }
fi

# БЛОК 2: Параллельный обработчик
if [ -f "$DIR/processor.sh" ]; then
  echo "✓ processor.sh создан"
  score=$((score+1))
  grep -qE 'mkfifo|exec.*3' "$DIR/processor.sh" && { echo "✓ mkfifo/exec 3"; score=$((score+1)); }
  grep -q ':?' "$DIR/processor.sh" && { echo "✓ \${var:?} используется"; score=$((score+1)); }
fi

# БЛОК 3: Отладка
if [ -f "$DIR/processor.sh" ]; then
  grep -q 'trap.*EXIT\|trap.*ERR' "$DIR/processor.sh" && { echo "✓ trap EXIT/ERR"; score=$((score+1)); }
fi

# БЛОК 4: select
if [ -f "$DIR/processor.sh" ]; then
  grep -q 'select' "$DIR/processor.sh" && { echo "✓ select меню"; score=$((score+1)); }
fi

# БЛОК 5: Отчёт
if [ -f "$DIR/UBERBOSS_ОТЧЁТ.txt" ]; then
  lines=$(wc -l < "$DIR/UBERBOSS_ОТЧЁТ.txt" 2>/dev/null)
  [ "$lines" -ge 5 ] 2>/dev/null && { echo "✓ UBERBOSS_ОТЧЁТ.txt ($lines строк)"; score=$((score+1)); }
fi

echo "✓ ok: UBERBOSS пройден! (баллов: $score/$max)"
[ $score -ge 7 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Модульность: if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then run_tests; fi
source: if [[ -f lib.sh ]]; then source lib.sh; fi
declare -A: declare -A config; while IFS='=' read -r key val; do config["$key"]="$val"; done < файл.conf

=== БЛОК 2 ===
mkfifo пул: mkfifo pipe; exec 3<>pipe; for ((i=0;i<jobs;i++)); do echo >&3; done
Параллельная обработка: for line in "${lines[@]}"; do read -u 3; { process; echo >&3; } & done; wait
mapfile: mapfile -t lines < логи/магия.log

=== БЛОК 3 ===
trap ERR: trap 'echo "Error at $LINENO (${FUNCNAME[0]})"' ERR
cleanup: cleanup() { rm -f "$tmpdir"/*; exec 3>&-; rm -f "$pipe"; }; trap cleanup EXIT

=== БЛОК 4 ===
select: select opt in "Анализ" "Статистика" "Отладка" "Выход"; do case $opt in ... esac; done

=== БЛОК 5 ===
Финальный отчёт: { echo "=== ОТЧЁТ АРХИМАГА ==="; date; cat статистика.txt; } > UBERBOSS_ОТЧЁТ.txt
