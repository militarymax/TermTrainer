META
# Track: scripting
# Title: Массивы и строки Астролога
# Number: 008
# Level: 2
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/свитки.txt" << 'EOF'
Огненный_Свиток_Альфа
Ледяной_Свиток_Бета
Воздушный_Свиток_Гамма
EOF

TASK
📜 **Массивы и строки Астролога**

Астрологи работают с таблицами звёзд — каждая на своём месте, каждая имеет координаты. Так и в bash: массивы хранят упорядоченные данные, а строковые операции позволяют извлекать из них суть.

📖 **Массивы (индексированные)**:
• Объявление: `arr=(a b c)` или `arr[0]="first"`
• Доступ: `${arr[0]}`, `${arr[@]}` (все элементы)
• Длина: `${#arr[@]}`
• Добавление: `arr+=("new")`
• Перебор: `for item in "${arr[@]}"; do ... done`

📖 **Строковые операции**:
• Длина: `${#var}`
• Вырезание: `${var:offset:length}` — подстрока
• Замена первое: `${var/old/new}`
• Замена все: `${var//old/new}`
• Удалить префикс: `${var#prefix}`
• Удалить суффикс: `${var%suffix}`
• Жадный префикс: `${var##*/}` (как dirname)
• Жадный суффикс: `${var%%.*}` (убрать расширение)

📖 **Арифметика**:
• `$(( a + b ))` — сложение
• `$(( a * b ))` — умножение
• `(( i++ ))` — инкремент
• `(( a += 5 ))` — добавить к переменной

📂 Рабочий каталог: `~/.ninja_trainer/scripting_008`

📋 **Попробуй**:
1. Создай скрипт `arrays.sh` — создай массив зелий, выведи каждое и их количество
2. Создай скрипт `strings.sh` — возьми строку "Огненный_Свиток_Альфа", замени "_" на " ", вырежи первое слово

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_008"
score=0

if [ -f "$DIR/arrays.sh" ]; then
  echo "✓ arrays.sh создан"
  score=$((score+1))
  grep -qE '\(|\)' "$DIR/arrays.sh" 2>/dev/null && { echo "✓ arrays.sh использует массив"; score=$((score+1)); }
fi

if [ -f "$DIR/strings.sh" ]; then
  echo "✓ strings.sh создан"
  score=$((score+1))
  grep -qE '\$\{.*[/#%]' "$DIR/strings.sh" 2>/dev/null && { echo "✓ strings.sh использует строковые операции"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Массивы и строки освоены! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Массив: potions=("невидимость" "сила" "мана"); echo "${potions[@]}"; echo "${#potions[@]}"
Перебор массива: for p in "${potions[@]}"; do echo "$p"; done
Длина строки: name="Ринсвинд"; echo "${#name}"
Замена: spell="огненный_свиток"; echo "${spell//_/ }"
Вырезание: echo "${spell:0:9}" — первые 9 символов
Удалить суффикс: file="свиток.txt"; echo "${file%%.*}" — выведет "свиток"
Арифметика: result=$((10 * 42)); echo $result
