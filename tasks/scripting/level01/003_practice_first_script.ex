META
# Track: scripting
# Title: Свиток с аргументами
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/список_зелий.txt" << 'EOF'
Зелье Невидимости
Зелье Левитации
Зелье Силы
Противоядие
Зелье Маны
EOF

TASK
⚗️ **Свиток с аргументами**

Ринсвинду нужно написать скрипт-приветствие для новых студентов Университета. Скрипт должен принимать имя студента как аргумент и выводить персональное приветствие. А если забыли указать имя — подсказать, как пользоваться скриптом.

📋 **Задания**:
1. Создай скрипт `greet.sh` который:
   - Проверяет, передан ли аргумент (имя студента)
   - Если аргумент не передан — выводит `Usage: ./greet.sh <name>` и завершается с кодом 1
   - Если передан — выводит `Welcome to Unseen University, $1!`
2. Создай скрипт `count.sh` который:
   - Читает файл `список_зелий.txt` построчно через `while read`
   - Считает количество зелий
   - Выводит результат: `Всего зелий: N`

💡 **Подсказки по навыкам**:
• `$1`, `$2`… — позиционные параметры
• `$#` — количество аргументов
• `$0` — имя самого скрипта
• `[ -z "$1" ]` — проверить, пустой ли первый аргумент
• `$?` — код возврата последней команды
• `exit N` — завершить скрипт с кодом N

📂 Рабочий каталог: `~/.ninja_trainer/scripting_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_003"
score=0

if [ -f "$DIR/greet.sh" ]; then
  echo "✓ greet.sh создан"
  score=$((score+1))
  grep -qE '\$1|\$\#' "$DIR/greet.sh" 2>/dev/null && { echo "✓ greet.sh использует параметры"; score=$((score+1)); }
  bash "$DIR/greet.sh" >/dev/null 2>&1; rc=$?
  if [ $rc -ne 0 ]; then
    echo "✓ greet.sh возвращает ошибку без аргумента (exit code: $rc)"
    score=$((score+1))
  fi
fi

if [ -f "$DIR/count.sh" ]; then
  echo "✓ count.sh создан"
  score=$((score+1))
  output=$(bash "$DIR/count.sh" 2>/dev/null)
  echo "$output" | grep -q '5' && { echo "✓ count.sh правильно считает ($output)"; score=$((score+1)); }
fi

[ $score -ge 4 ] && { echo "✓ ok: Свиток с аргументами освоен! (баллов: $score/5)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/5)"
exit 1

HINTS
Проверка аргумента: if [ -z "$1" ]; then echo "Usage: $0 <name>"; exit 1; fi
Приветствие: echo "Welcome to Unseen University, $1!"
Подсчёт строк: count=0; while read line; do count=$((count+1)); done < список_зелий.txt; echo "Всего зелий: $count"
Код возврата: после команды проверяй $? — 0 значит успех, не-0 значит ошибка
Комментарии: # Это комментарий — bash игнорирует всё после #
