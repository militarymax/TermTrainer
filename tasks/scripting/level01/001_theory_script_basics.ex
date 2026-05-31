META
# Track: scripting
# Title: Первое заклинание
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/свитки" "$DIR/черновики"
cat > "$DIR/свитки/привет.txt" << 'EOF'
Приветствую, новичок!
Твой путь в башне начинается здесь.
EOF
cat > "$DIR/свитки/инструкция.txt" << 'EOF'
Шаг 1: Создай скрипт
Шаг 2: Сделай его исполняемым
Шаг 3: Запусти
EOF
echo "ОШИБКА: Чернила пролились на свиток!" > "$DIR/черновики/ошибка.log"

TASK
📜 **Первое заклинание**

Ринсвинд только поступил в Незримый Университет. Ему выдали каморку в Башне и сказали: «Научись писать заклинания… то есть скрипты». Но что такое скрипт? Как его создать и запустить?

В этом задании ты освоишь основы — от создания первого скрипта до работы с переменными и вводом/выводом.

📖 **Структура скрипта**:
• **Шебанг** `#!/bin/bash` — первая строка, указывает интерпретатор
• **Права**: `chmod +x script.sh` — сделать исполняемым
• **Запуск**: `./script.sh` или `bash script.sh`

📖 **Переменные**:
• Присваивание: `var=value` (БЕЗ пробелов вокруг =)
• Чтение: `$var`, `${var}` (фигурные скобки — для объединения со текстом)
• Двойные кавычки `"текст $var"` — подстановки работают
• Одинарные кавычки `'текст $var'` — всё буквально, $var не раскрывается

📖 **Ввод/вывод**:
• `echo "текст"` — простой вывод
• `printf "шаблон\n"` — форматированный вывод (надёжнее echo)
• `read var` — чтение одной строки с клавиатуры
• `>` — перенаправление вывода в файл (перезапись)
• `>>` — добавление в конец файла
• `2>` — перенаправление stderr (ошибок)

📂 Рабочий каталог: `~/.ninja_trainer/scripting_001`

📋 **Попробуй**:
1. Создай файл `hello.sh` с шебангом и командой `echo "Hello, Unseen University!"`
2. Сделай его исполняемым: `chmod +x hello.sh`
3. Запусти: `./hello.sh`
4. Создай файл `vars.sh` с переменными и выводом через `printf`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_001"
score=0

# Создан hello.sh с шебангом
if [ -f "$DIR/hello.sh" ]; then
  head -1 "$DIR/hello.sh" | grep -q '^#!' 2>/dev/null && { echo "✓ hello.sh с шебангом"; score=$((score+1)); }
fi

# Исполняемый
[ -x "$DIR/hello.sh" ] && { echo "✓ hello.sh исполняемый"; score=$((score+1)); }

# vars.sh создан
[ -f "$DIR/vars.sh" ] && { echo "✓ vars.sh создан"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Первое заклинание освоено! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Создай скрипт: cat > ~/.ninja_trainer/scripting_001/hello.sh << 'EOF'
#!/bin/bash
echo "Hello, Unseen University!"
EOF
Сделай исполняемым: chmod +x ~/.ninja_trainer/scripting_001/hello.sh
Запусти: ~/.ninja_trainer/scripting_001/hello.sh
Переменные: name="Rincewind"; echo "Hello, $name"
Одинарные кавычки: echo 'Hello, $name' — выведет буквально $name
printf: printf "Имя: %s\n" "$name" — форматированный вывод
read: read name; echo "Привет, $name"
