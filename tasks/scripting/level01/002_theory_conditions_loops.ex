META
# Track: scripting
# Title: Ветвления судьбы
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/лаборатория" "$DIR/архив"
echo "Зелье невидимости" > "$DIR/лаборатория/зелье_01.txt"
echo "Проклятый свиток" > "$DIR/лаборатория/проклятие.txt"
chmod +x "$DIR/лаборатория/зелье_01.txt"
cat > "$DIR/архив/реестр.txt" << 'EOF'
огненный
ледяной
воздушный
земляной
EOF

TASK
📜 **Ветвления судьбы**

В Башне Незримого Университета коридоры разветвляются на каждом шагу. Направо пойдёшь — к зельям попадёшь, налево — проклятие найдёшь. Так и в скриптах: нужно уметь проверять условия и выбирать путь.

📖 **Условные операторы**:
• `if [ условие ]; then ... fi` — базовое ветвление
• `if [ условие ]; then ... else ... fi` — с альтернативой
• `elif` — множественные проверки

📖 **test и [ ]**:
• Строки: `[ "$a" = "$b" ]`, `[ -z "$var" ]` (пустая)
• Числа: `[ $a -eq $b ]`, `[ $a -gt $b ]`, `[ $a -lt $b ]`
• Файлы: `[ -f файл ]` (существует), `[ -d каталог ]`, `[ -x файл ]` (исполняемый)
• Отрицание: `[ ! условие ]`

📖 **Короткие условия**:
• `команда && echo "ok"` — выполнить если успех
• `команда || echo "fail"` — выполнить если ошибка

📖 **Циклы**:
• `for var in список; do ... done` — перебор слов
• `while [ условие ]; do ... done` — пока истинно
• `while read line; do ... done < файл` — построчное чтение
• `break` — выйти из цикла
• `continue` — перейти к следующей итерации

📂 Рабочий каталог: `~/.ninja_trainer/scripting_002`

📋 **Попробуй**:
1. Напиши скрипт `check.sh`, который проверяет, существует ли файл `лаборатория/зелье_01.txt`
2. Добавь проверку: если файл исполняемый — вывести "Зелье готово!", иначе — "Нужно варить дальше"
3. Напиши скрипт `loop.sh`, который перебирает все файлы в `лаборатория/`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_002"
score=0

if [ -f "$DIR/check.sh" ]; then
  echo "✓ check.sh создан"
  score=$((score+1))
  grep -q 'if' "$DIR/check.sh" 2>/dev/null && { echo "✓ check.sh содержит if"; score=$((score+1)); }
fi

if [ -f "$DIR/loop.sh" ]; then
  echo "✓ loop.sh создан"
  score=$((score+1))
  grep -qE '(for|while)' "$DIR/loop.sh" 2>/dev/null && { echo "✓ loop.sh содержит цикл"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Ветвления судьбы освоены! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Проверка файла: if [ -f "$DIR/лаборатория/зелье_01.txt" ]; then echo "Есть!"; fi
Исполняемый ли: if [ -x "$DIR/лаборатория/зелье_01.txt" ]; then echo "Готово!"; fi
Цикл for: for f in ~/.ninja_trainer/scripting_002/лаборатория/*; do echo "$f"; done
Построчное чтение: while read line; do echo "$line"; done < ~/.ninja_trainer/scripting_002/архив/реестр.txt
Короткое условие: [ -d "$DIR" ] && echo "Каталог есть"
