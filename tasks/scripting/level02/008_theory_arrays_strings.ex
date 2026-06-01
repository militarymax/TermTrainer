META
# Track: scripting
# Title: Массивы и строки Астролога
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #008: Массивы и строки Астролога

Астролог разложил перед тобой колоду карт:
«Каждая карта — элемент массива. Каждая строка — заклинание,
которое можно нарезать, склеить или трансформировать.
Мастерство в этом — разница между подмастерьем и магом.»

───────────────────────────────────────
🔹 МАССИВЫ — КОЛДА КАРТ
───────────────────────────────────────

```bash
potions=(healing mana fire)     # Объявление массива
echo "${potions[0]}"            # → healing (индекс с 0!)
echo "${potions[@]}"            # → healing mana fire (все элементы)
echo "${#potions[@]}"           # → 3 (количество элементов)

potions+=(invisibility)         # Добавить элемент
echo "${#potions[@]}"           # → 4

for p in "${potions[@]}"; do   # Безопасный перебор
    echo "Potion: $p"
done
```

⚠️ ВСЕГДА `"${arr[@]}"` с кавычками! Без кавычек элементы с пробелами разобьются.

───────────────────────────────────────
🔹 СТРОКОВЫЕ ОПЕРАЦИИ — ТРАНСФОРМАЦИИ
───────────────────────────────────────

Без внешних команд (grep/sed/awk), только встроенные возможности bash:

```bash
spell="Fireball of Destruction"

${#spell}              # → 24 (длина строки)
${spell:0:8}           # → Fireball (вырезание: offset:length)
${spell:9:2}           # → of
${spell/Fire/Ice}      # → Iceball of Destruction (замена первого)
${spell//o/O}          # → Fireball Of DestructiOn (замена ВСЕХ)
${spell#Fire}          # → ball of Destruction (удалить префикс)
${spell%Destruction}   # → Fireball of  (удалить суффикс)
```

───────────────────────────────────────
🔹 АРИФМЕТИКА — ЧИСЛОВАЯ МАГИЯ
───────────────────────────────────────

```bash
power=10
(( power += 5 ))        # power = 15
(( power *= 2 ))        # power = 30
echo "$(( power / 3 ))" # → 10 (целочисленное деление!)
(( i++ ))               # инкремент
```

• `$(( ... ))` — целочисленная арифметика (дробей НЕТ!)
• `(( ... ))` — арифметическое выражение (можно без $)
• Для чисел с точкой нужен `bc` или `awk`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_008`

📋 **Попробуй**:
1. Создай массив: `spells=(fireball heal teleport)` и выведи все элементы
2. Длина строки: `spell="abracadabra"; echo "${#spell}"`
3. Замена: `echo "${spell/abra/ALAKAZAM}"`

VALIDATION
#!/bin/bash
score=0

arr_out=$(bash -c 'spells=(fire heal); echo "${spells[@]}"' 2>/dev/null)
[ "$arr_out" = "fire heal" ] && { echo "✓ Массивы работают"; score=$((score+1)); }

len_out=$(bash -c 's="hello"; echo "${#s}"' 2>/dev/null)
[ "$len_out" = "5" ] && { echo "✓ Длина строки работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Массивы и строки освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Array declare: arr=(a b c) — создание массива
Array access: ${arr[0]} — первый элемент (индекс с 0!)
All elements: ${arr[@]} — все элементы; ${#arr[@]} — количество
Append: arr+=(new_elem) — добавить элемент
Loop array: for item in "${arr[@]}"; do ... done — безопасный перебор
String length: ${#var} — длина строки
Substring: ${var:offset:length} — вырезать часть строки
Replace first: ${var/old/new} — заменить первое вхождение
Replace all: ${var//old/new} — заменить все вхождения
Arithmetic: $(( a + b )), (( i++ )), (( x += 5 ))
