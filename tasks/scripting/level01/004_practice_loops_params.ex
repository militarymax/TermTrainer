META
# Track: scripting
# Title: Колесо перерождений
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/башня/этаж1" "$DIR/башня/этаж2" "$DIR/башня/этаж3"
echo "Огненный свиток" > "$DIR/башня/этаж1/свиток_01.txt"
echo "Ледяной свиток" > "$DIR/башня/этаж1/свиток_02.txt"
echo "Свиток невидимости" > "$DIR/башня/этаж2/свиток_03.txt"
echo "Проклятый свиток" > "$DIR/башня/этаж3/запретный.txt"
cat > "$DIR/реестр_студентов.txt" << 'EOF'
Ринсвинд 2 78
Коэн 3 95
Маграт 1 88
Нанна 2 91
Грита 1 65
EOF

TASK
🔄 **Колесо перерождений**

В Башне Университета бесконечные лестницы — этажи, комнаты, свитки… Нужно уметь перебирать их все, не пропустив ни одного. А ещё — правильно передавать параметры скрипту.

📋 **Задания**:
1. Создай скрипт `scan.sh` который:
   - Принимает каталог как аргумент `$1`
   - Проверяет, что аргумент передан и это каталог (`-d`)
   - Перебирает все файлы в каталоге через `for f in "$1"/*`
   - Для каждого файла выводит его имя
   - Если файл исполняемый (`-x`) — добавить пометку `[executable]`

2. Создай скрипт `students.sh` который:
   - Читает `реестр_студентов.txt` построчно через `while read name course grade`
   - Выводит каждого студента в формате: `$name — курс $course, оценка $grade`
   - Считает средний балл и выводит в конце

💡 **Разница $@ и $***:
• `"$@"` — каждый аргумент как отдельное слово (сохраняет границы)
• `"$*"` — все аргументы как одно слово (объединяет)
• Всегда используй `"$@"` для перебора аргументов!

📂 Рабочий каталог: `~/.ninja_trainer/scripting_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_004"
score=0

if [ -f "$DIR/scan.sh" ]; then
  echo "✓ scan.sh создан"
  score=$((score+1))
  grep -qE '(for|while)' "$DIR/scan.sh" 2>/dev/null && { echo "✓ scan.sh содержит цикл"; score=$((score+1)); }
fi

if [ -f "$DIR/students.sh" ]; then
  echo "✓ students.sh создан"
  score=$((score+1))
  output=$(bash "$DIR/students.sh" 2>/dev/null)
  echo "$output" | grep -qi 'ринсвинд' && { echo "✓ students.sh выводит студентов"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Колесо перерождений пройдено! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Перебор файлов: for f in ~/.ninja_trainer/scripting_004/башня/этаж1/*; do echo "$(basename "$f")"; done
Проверка каталога: if [ -d "$1" ]; then ... fi
Чтение нескольких переменных: while read name course grade; do echo "$name — курс $course, оценка $grade"; done < реестр_студентов.txt
$@ vs $*: for arg in "$@"; do echo "$arg"; done — каждый аргумент отдельно
break: выйти из цикла досрочно; continue: пропустить итерацию
