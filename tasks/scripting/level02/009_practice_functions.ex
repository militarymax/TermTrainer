META
# Track: scripting
# Title: Ритуалы и ловушки
# Number: 009
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/данные"
cat > "$DIR/данные/студенты.csv" << 'EOF'
Ринсвинд,2,78
Коэн,3,95
Маграт,1,88
Нанна,2,91
Грита,1,65
Ветинари,4,99
EOF

TASK
🔮 **Ритуалы и ловушки**

Каждый ритуал в Университете требует подготовки и очистки. Создал временный файл — удали. Перехватил сигнал — обработай. Это основы надёжного скриптинга.

📋 **Задания**:
1. Создай скрипт `ritual.sh` с `set -euo pipefail` который:
   - Определяет функцию `cleanup()`, которая удаляет временные файлы
   - Устанавливает `trap cleanup EXIT` — гарантия очистки при любом выходе
   - Создаёт временный файл через `mktemp`
   - Записывает туда данные
   - Определяет функцию `parse_students()`:
     - Читает `данные/студенты.csv`
     - Использует `local` для всех переменных
     - Возвращает количество студентов через `echo`
   - Вызывает функцию и выводит результат

2. Добавь отладку:
   - Временно добавь `set -x` для трассировки
   - Установи `PS4='+ ${BASH_SOURCE}:${LINENO} '` для улучшенного трейса

3. Подключи внешний файл:
   - Создай `lib.sh` с функцией `hello()`, которая выводит "Hello from lib!"
   - В `ritual.sh` добавь проверку перед source: `if [[ -f lib.sh ]]; then source lib.sh; fi`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_009"
score=0

if [ -f "$DIR/ritual.sh" ]; then
  echo "✓ ritual.sh создан"
  score=$((score+1))
  grep -q 'set -e' "$DIR/ritual.sh" && { echo "✓ set -e используется"; score=$((score+1)); }
  grep -q 'trap' "$DIR/ritual.sh" && { echo "✓ trap установлен"; score=$((score+1)); }
  grep -q 'mktemp' "$DIR/ritual.sh" && { echo "✓ mktemp используется"; score=$((score+1)); }
  grep -qE '^[a-zA-Z_]+\(\)' "$DIR/ritual.sh" && { echo "✓ Функция определена"; score=$((score+1)); }
fi

if [ -f "$DIR/lib.sh" ]; then
  echo "✓ lib.sh создан"
  score=$((score+1))
fi

[ $score -ge 5 ] && { echo "✓ ok: Ритуалы и ловушки освоены! (баллов: $score/6)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/6)"
exit 1

HINTS
Функция cleanup: cleanup() { rm -f "$tmpfile"; }
trap: trap cleanup EXIT — вызовет cleanup при выходе из скрипта
mktemp: tmpfile=$(mktemp) — безопасное временное имя файла
local: parse_data() { local count=0; local line=""; ... }
source: if [[ -f "lib.sh" ]]; then source lib.sh; fi
Отладка: set -x включает трассировку, set +x выключает
PS4: export PS4='+ ${BASH_SOURCE}:${LINENO} '
