META
# Track: scripting
# Title: Первое заклинание
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/scrolls" "$DIR/drafts"
cat > "$DIR/scrolls/welcome.txt" << 'EOF'
Welcome, apprentice!
Your path in the Tower begins here.
EOF
cat > "$DIR/scrolls/instructions.txt" << 'EOF'
Step 1: Create a script
Step 2: Make it executable
Step 3: Run it
EOF
echo "ERROR: Ink spilled on the scroll!" > "$DIR/drafts/error.log"

TASK
📜 СВИТОК ЗНАНИЙ #001: Первое заклинание

Декан Чартер швырнул на стол пыльный гримуар и прорычал:
«Ринсвинд! Последний студент, который не умел писать заклинания,
случайно превратил себя в кактус. Мы поливали его три года.
Он до сих пор колется. Научись. ПРАВИЛЬНО.»

───────────────────────────────────────
🔹 СТРУКТУРА ЗАКЛИНАНИЯ (СКРИПТА)
───────────────────────────────────────

Каждое заклинание начинается с **шебанга** — магической формулы,
которая говорит системе, КАКОЙ именно интерпретатор использовать:

```bash
#!/bin/bash          # ← Шебанг: всегда первая строка!
echo "Hello!"        # ← Тело заклинания
```

• `#!/bin/bash` — указывает: запускай через bash
• Без шебанка — система может запустить через sh (а там нет [[ ]], массивов...)

───────────────────────────────────────
🔹 ПРАВА И ЗАПУСК
───────────────────────────────────────

Заклинание бесполезно, если его нельзя прочитать вслух:

• `chmod +x script.sh` — дать право на исполнение
• `./script.sh` — запустить из текущего каталога
• `bash script.sh` — запустить явно через bash (права не нужны)

───────────────────────────────────────
🔹 ПЕРЕМЕННЫЕ — МАГИЧЕСКИЕ РЕАГЕНТЫ
───────────────────────────────────────

Переменная — это флакон с реагентом. Даёшь имя — получаешь содержимое:

```bash
name=Rincewind       # Присваивание: БЕЗ пробелов вокруг =
echo "$name"         # → Rincewind (подстановка работает)
echo '${name}'       # → ${name} (одинарные кавычки — всё буквально!)
echo "${name}s"      # → Rincewinds (фигурные скобки для объединения)
```

⚠️ Правило кавычек:
• `"двойные"` — подстановки $var работают
• `'одинарные'` — ВСЁ буквально, $var НЕ раскрывается

───────────────────────────────────────
🔹 ВВОД И ВЫВОД
───────────────────────────────────────

• `echo "текст"` — простой вывод (но printf надёжнее)
• `printf "Имя: %s\n" "$name"` — форматированный вывод
• `read var` — прочитать строку с клавиатуры
• `>` — перенаправить stdout в файл (перезапись)
• `>>` — добавить в конец файла
• `2>` — перенаправить stderr (ошибки)

📂 Рабочий каталог: `~/.termtrainer/scripting_001`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/scripting_001
📋 **Попробуй**:
1. Создай `hello.sh` с шебангом и `echo "Hello, Unseen University!"`
2. Сделай исполняемым: `chmod +x hello.sh`
3. Запусти: `./hello.sh`
4. Создай `vars.sh` с переменными и выводом через `printf`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_001"
score=0

if [ -f "$DIR/hello.sh" ]; then
  head -1 "$DIR/hello.sh" | grep -q '^#!' 2>/dev/null && { echo "✓ hello.sh с шебангом"; score=$((score+1)); }
fi

[ -x "$DIR/hello.sh" ] && { echo "✓ hello.sh исполняемый"; score=$((score+1)); }

[ -f "$DIR/vars.sh" ] && { echo "✓ vars.sh создан"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Первое заклинание освоено! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Создай скрипт: cat > hello.sh << 'EOF'\n#!/bin/bash\necho "Hello!"\nEOF
Шебанг: #!/bin/bash — всегда первая строка скрипта
Исполняемость: chmod +x script.sh — без этого не запустится через ./
Запуск: ./script.sh или bash script.sh
Переменные: name="Rincewind"; echo "Hello, $name" — без пробелов вокруг =
Двойные кавычки: "$var" — подстановка работает
Одинарные кавычки: '$var' — выводится буквально
printf: printf "Name: %s\n" "$name" — форматированный, надёжнее echo
read: read name — чтение ввода с клавиатуры
