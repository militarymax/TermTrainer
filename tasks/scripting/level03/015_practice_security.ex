META
# Track: scripting
# Title: Щиты и печати
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/секреты" "$DIR/публичное"
echo "пароль=абракадабра" > "$DIR/секреты/ключи.txt"
echo "инструкция по безопасности" > "$DIR/публичное/README.txt"
for i in $(seq 1 5); do
  echo "файл $i с данными" > "$DIR/публичное/документ_${i}.txt"
done
touch "$DIR/публичное/файл с пробелами.txt"
touch "$DIR/публичное/файл-с-дефисами.txt"

TASK
🛡️ **Щиты и печати**

Тёмные силы пытаются проникнуть в скрипты Университета через инъекции, globbing и небезопасные конструкции. Научись защищать свои заклинания!

📋 **Задания**:
1. Создай скрипт `safe_find.sh`:
   - Использует `find -print0` + `while read -d ''` для безопасной обработки имён файлов с пробелами
   - Перебирает все файлы в `публичное/`
   - Выводит имя каждого файла (без разбиения на слова)

2. Создай скрипт `no_eval.sh`:
   - Демонстрирует безопасную альтернативу `eval`: динамические команды через массивы
   - `cmd=(ls -l "$dir"); "${cmd[@]}"` — безопасно!
   - Сравни с опасным: `eval "ls -l $dir"` — инъекция если $dir содержит "; rm -rf /"
   - Выведи результат выполнения команды через массив

3. Создай скрипт `debug_demo.sh`:
   - Определяет функцию, которая вызывает другую функцию
   - Использует `caller` для вывода стека вызовов
   - Выводит `${BASH_SOURCE[0]}`, `${FUNCNAME[@]}`, `${BASH_LINENO[@]}`
   - Создаёт trap ERR с информацией о строке ошибки

4. Создай скрипт `interactive.sh`:
   - Использует `select` для создания меню из списка действий
   - Пункты: "Проверить файлы", "Показать секреты", "Выход"
   - Обрабатывает выбор через `case`

💡 **Безопасность**:
• Никогда не используй `eval` без крайней необходимости
• `env -i` — запустить в чистом окружении
• `set -f` — отключить globbing (разворачивание * и ?)
• Всегда кавычь переменные: `"$var"`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_015"
score=0

if [ -f "$DIR/safe_find.sh" ]; then
  echo "✓ safe_find.sh создан"
  score=$((score+1))
  grep -qE 'print0|read.*-d' "$DIR/safe_find.sh" && { echo "✓ Безопасный find+read"; score=$((score+1)); }
fi

if [ -f "$DIR/no_eval.sh" ]; then
  echo "✓ no_eval.sh создан"
  score=$((score+1))
  grep -qE '\$\{cmd\[@\]\}|\(' "$DIR/no_eval.sh" && { echo "✓ Массив команд"; score=$((score+1)); }
fi

if [ -f "$DIR/debug_demo.sh" ]; then
  echo "✓ debug_demo.sh создан"
  score=$((score+1))
  grep -qE 'caller|FUNCNAME|BASH_SOURCE|BASH_LINENO' "$DIR/debug_demo.sh" && { echo "✓ Интроспекция"; score=$((score+1)); }
fi

if [ -f "$DIR/interactive.sh" ]; then
  echo "✓ interactive.sh создан"
  score=$((score+1))
  grep -q 'select' "$DIR/interactive.sh" && { echo "✓ select используется"; score=$((score+1)); }
fi

[ $score -ge 6 ] && { echo "✓ ok: Щиты и печати установлены! (баллов: $score/8)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/8)"
exit 1

HINTS
Безопасный find: find ~/.ninja_trainer/scripting_015/публичное/ -type f -print0 | while IFS= read -r -d '' file; do echo "$file"; done
Массив вместо eval: cmd=(ls -l "$dir"); "${cmd[@]}"
caller в функции: show_caller() { echo "Called from line $(caller)"; }
BASH_SOURCE: echo "File: ${BASH_SOURCE[0]}, Line: ${BASH_LINENO[0]}, Func: ${FUNCNAME[0]}"
select меню: select opt in "Проверить" "Секреты" "Выход"; do case "$opt" in ... esac; done
trap ERR: trap 'echo "Error at line $LINENO"' ERR
set -f: отключить globbing; set +f — включить обратно
