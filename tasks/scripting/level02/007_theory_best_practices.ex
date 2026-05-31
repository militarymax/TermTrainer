META
# Track: scripting
# Title: Кодекс Астролога
# Number: 007
# Level: 2
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
echo "готово" > "$DIR/статус.txt"

TASK
📜 **Кодекс Астролога**

Астрологи Университета знают: звёзды не прощают ошибок. Одна неэкранированная переменная — и всё заклинание рушится. Здесь ты научишься писать скрипты, которые не ломаются.

📖 **Лучшие практики**:
• `set -e` — выход при ошибке любой команды
• `set -u` — ошибка при использовании неопределённой переменной
• `set -o pipefail` — ошибка в любой части конвейера вызывает ошибку конвейера
• Священная троица: `set -euo pipefail` — ставь в начало каждого скрипта!

📖 **Кавычки — закон**:
• ВСЕГДА оборачивай переменные в двойные кавычки: `"$var"`
• Без кавычек — пробелы и спецсимволы разорвут аргументы
• `"$@"` вместо `$@` или `$*`

📖 **[[ ]] вместо [ ]**:
• `[[ ]]` — встроенный bash, безопаснее и мощнее
• Внутри `[[ ]]` нет проблем с пустыми переменными
• Поддерживает `&&`, `||`, `<`, `>` без экранирования
• Поддерживает `=~` для regex

📖 **Функции**:
• Определение: `myfunc() { ... }`
• Локальные переменные: `local var=value`
• `return N` — только код возврата (0-255)
• Возврат строки через `echo` + захват: `result=$(myfunc)`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_007`

📋 **Попробуй**:
1. Создай скрипт `safe.sh` с `set -euo pipefail`
2. Напиши функцию `greet()`, которая принимает имя через `$1` и выводит приветствие
3. Используй `local` для всех переменных внутри функции

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_007"
score=0

if [ -f "$DIR/safe.sh" ]; then
  echo "✓ safe.sh создан"
  score=$((score+1))
  grep -q 'set -euo pipefail\|set -e' "$DIR/safe.sh" 2>/dev/null && { echo "✓ set -e используется"; score=$((score+1)); }
  grep -qE '^[a-zA-Z_]+\(\)' "$DIR/safe.sh" 2>/dev/null && { echo "✓ Функция определена"; score=$((score+1)); }
  grep -q 'local' "$DIR/safe.sh" 2>/dev/null && { echo "✓ local используется"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Кодекс Астролога усвоен! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Священная троица: добавь set -euo pipefail после шебанга
Функция: greet() { local name="$1"; echo "Hello, $name"; }
Вызов функции: greet "Rincewind"
Возврат значения через echo: get_name() { echo "Rincewind"; }; name=$(get_name)
[[ ]] безопаснее: if [[ -z "$var" ]]; then echo "пусто"; fi
