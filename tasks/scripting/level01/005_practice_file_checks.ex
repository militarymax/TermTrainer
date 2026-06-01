META
# Track: scripting
# Title: Страж архивов
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/vaults" "$DIR/forbidden"
echo "Scroll of Fireball" > "$DIR/vaults/fireball.txt"
echo "Potion of Invisibility" > "$DIR/vaults/invisibility.txt"
chmod +x "$DIR/vaults/fireball.txt"
cat > "$DIR/vaults/cursed.txt" << 'EOF'
CURSED SCROLL - DO NOT READ ALOUD
Side effects: spontaneous combustion, levitation, taste of copper
EOF

TASK
⚗️ ПРАКТИКУМ #005: Страж архивов

Библиотекарь поручил тебе охранять Архивы. Каждый свиток нужно проверить:
существует ли, можно ли читать, исполняемый ли, не проклят ли?
«Ууук!» — добавил он и протянул список проверок.

📋 **Задания**:

1. **Напиши `guard.sh`** — страж архивов:
   ```bash
   #!/bin/bash
   # Guard script — checks files in the vaults
   dir="${1:-vaults}"
   
   if [ ! -d "$dir" ]; then
       echo "ERROR: Directory '$dir' does not exist!" >&2
       exit 1
   fi
   
   for file in "$dir"/*; do
       name=$(basename "$file")
       if [ -f "$file" ]; then
           size=$(wc -c < "$file")
           exe=""
           [ -x "$file" ] && exe=" [EXECUTABLE]"
           echo "✓ $name (${size}B)$exe"
       elif [ -d "$file" ]; then
           echo "📁 $name/ (directory)"
       fi
   done
   ```

2. **Напиши `safe_read.sh`** — безопасное чтение свитка:
   ```bash
   #!/bin/bash
   file="$1"
   
   if [ -z "$file" ]; then
       echo "Usage: $0 <scroll_name>" >&2
       exit 1
   fi
   
   if [ ! -f "$file" ]; then
       echo "ERROR: Scroll '$file' not found!" >&2
       exit 2
   fi
   
   if [ ! -r "$file" ]; then
       echo "ERROR: Scroll '$file' is unreadable (no permission)!" >&2
       exit 3
   fi
   
   echo "=== Reading scroll: $file ==="
   cat "$file"
   echo "=== End of scroll ==="
   ```

3. **Протестируй**:
   ```bash
   chmod +x guard.sh safe_read.sh
   ./guard.sh vaults
   ./safe_read.sh vaults/fireball.txt
   ./safe_read.sh nonexistent.txt    # → ERROR
   echo $?                            # → 2
   ```

📂 Рабочий каталог: `~/.ninja_trainer/scripting_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_005"
score=0

[ -f "$DIR/guard.sh" ] && bash "$DIR/guard.sh" vaults 2>&1 | grep -q "fireball\|invisibility\|cursed" && { echo "✓ guard.sh работает"; score=$((score+1)); }
[ -f "$DIR/safe_read.sh" ] && bash "$DIR/safe_read.sh" vaults/fireball.txt 2>&1 | grep -q "Fireball\|Reading" && { echo "✓ safe_read.sh работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Проверки файлов освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай guard.sh или safe_read.sh (баллов: $score/2)"
exit 1

HINTS
File exists: [ -f "$file" ] — обычный файл существует?
Directory exists: [ -d "$dir" ] — каталог существует?
Readable: [ -r "$file" ] — можно прочитать?
Executable: [ -x "$file" ] — исполняемый?
Empty string: [ -z "$var" ] — переменная пуста?
basename: basename "/path/to/file" → file — только имя файла
wc -c: wc -c < file — размер файла в байтах
stderr: echo "error" >&2 — вывод ошибок на stderr
