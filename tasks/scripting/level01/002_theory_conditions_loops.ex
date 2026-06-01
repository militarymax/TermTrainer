META
# Track: scripting
# Title: Ветвления судьбы
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/vaults" "$DIR/potions"
echo "dragon_fire" > "$DIR/vaults/ingredient.txt"
echo "42" > "$DIR/vaults/power_level.txt"
echo "expired" > "$DIR/potions/healing_potion.txt"
echo "fresh" > "$DIR/potions/mana_potion.txt"

TASK
📜 СВИТОК ЗНАНИЙ #002: Ветвления судьбы

Библиотекарь положил перед тобой два свитка и жестом показал:
один — безопасный, другой — проклятый. Выбирать нужно по условию.
«Ууук!» — сказал он. Это означало: «Научись проверять условия,
иначе останешься без рук. Или без головы. Зависит от свитка.»

───────────────────────────────────────
🔹 УСЛОВНЫЕ ОПЕРАТОРЫ — РАЗВЕТВЛЕНИЯ ЗАКЛИНАНИЯ
───────────────────────────────────────

Заклинание может идти разными путями в зависимости от условий:

```bash
if [ -z "$1" ]; then          # Если аргумент пуст...
    echo "Usage: $0 <name>"   # ...выведи подсказку
    exit 1                    # ...и заверши с кодом ошибки
fi
echo "Hello, $1"              # Иначе — приветствие
```

📖 **test и [ ]** — проверки:
• `-z "$var"` — строка пуста?
• `-n "$var"` — строка не пуста?
• `"$a" = "$b"` — строки равны?
• `-f "file"` — файл существует?
• `-d "dir"` — каталог существует?
• `-x "file"` — файл исполняемый?
• `$num1 -eq $num2` — числа равны?
• `$num1 -gt $num2` — первое больше?

📖 **Короткие условия**:
• `cmd1 && cmd2` — cmd2 выполнится ТОЛЬКО если cmd1 успешна
• `cmd1 || cmd2` — cmd2 выполнится ТОЛЬКО если cmd1 НЕ успешна
```bash
[ -f config.sh ] && source config.sh     # Есть файл? Подключи!
[ -d backup ] || mkdir backup            # Нет каталога? Создай!
```

───────────────────────────────────────
🔹 ЦИКЛЫ — ПОВТОРЕНИЯ ЗАКЛИНАНИЯ
───────────────────────────────────────

📖 **for** — перебор слов из списка:
```bash
for potion in healing mana fire; do
    echo "Brewing: $potion"
done
```

📖 **while read** — обработка файла построчно:
```bash
while read -r line; do
    echo "Scroll says: $line"
done < scrolls/list.txt
```

📖 **break / continue**:
• `break` — прервать цикл немедленно
• `continue` — перейти к следующей итерации

───────────────────────────────────────
🔹 ПАРАМЕТРЫ СКРИПТА — АРГУМЕНТЫ ЗАКЛИНАНИЯ
───────────────────────────────────────

Когда заклинание произносится с аргументами:
```bash
./summon.sh dragon fire       # $1=dragon  $2=fire
```
• `$1`, `$2`... — позиционные параметры (аргументы)
• `$#` — количество аргументов
• `$@` — все аргументы как отдельные слова (ВСЕГДА в кавычках: `"$@"`)
• `$*` — все аргументы как одно слово (разница при `"$*"` vs `"$@"`)
• `$?` — код возврата последней команды (0 = успех)
• `exit N` — завершить скрипт с кодом N

📂 Рабочий каталог: `~/.ninja_trainer/scripting_002`

📋 **Попробуй**:
1. Напиши скрипт `greet.sh`: если `$1` задан → `echo "Hello, $1"`, иначе → ошибка
2. Цикл: `for i in 1 2 3; do echo "Potion #$i"; done`
3. Проверь код возврата: `true; echo $?` → 0, `false; echo $?` → 1

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_002"
score=0

[ -f "$DIR/greet.sh" ] && { echo "✓ greet.sh создан"; score=$((score+1)); }

if [ -f "$DIR/greet.sh" ]; then
  bash "$DIR/greet.sh" Rincewind 2>/dev/null | grep -q "Hello" && { echo "✓ greet.sh работает с аргументом"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Ветвления освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай greet.sh (баллов: $score/2)"
exit 1

HINTS
If: if [ condition ]; then ... elif [ condition ]; then ... else ... fi
Test string empty: [ -z "$var" ] — переменная пуста?
Test file exists: [ -f "file" ] — файл существует?
Short AND: cmd1 && cmd2 — вторая команда только если первая успешна
Short OR: cmd1 || cmd2 — вторая только если первая не успешна
For loop: for var in list; do ... done — перебор элементов
While read: while read -r line; do ... done < file — построчное чтение
Arguments: $1 $2... — параметры, $# — количество, $@ — все аргументы
Exit code: $? — код последней команды, exit N — завершить с кодом
