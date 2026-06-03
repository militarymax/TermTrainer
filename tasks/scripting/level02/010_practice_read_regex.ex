META
# Track: scripting
# Title: Чтение звёздных карт
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/students.txt" << 'EOF'
Rincewind:wizard:42:running_away
Carrot:watchman:27:honesty
Granny Weatherwax:witch:82:headology
Nanny Ogg:witch:79:drinking
Death:anthropomorphic:0:duty
EOF

TASK
⚗️ ПРАКТИКУМ #010: Чтение звёздных карт

Астролог развернул звёздную карту:
«Ринсвинд, данные приходят в разных форматах. Иногда нужно прочитать
ввод с клавиатуры, иногда — распарсить строку с помощью regex.
Научись читать и фильтровать — или будешь вручную переписывать
каждый свиток до конца времён.»

📋 **Задания**:

ASSIGNMENT
1. **Продвинутый read**:
   ```bash
   # Интерактивный ввод
   read -r -p "Enter spell name: " spell
   echo "Casting: $spell"
   
   # Чтение в несколько переменных (разделитель по умолчанию — пробел)
   echo "Rincewind wizard 42" | read -r name class age
   echo "$name is a $class of age $age"
   
   # -r: не экранировать обратные слеши
   # -d: другой разделитель
   ```

2. **Regex в [[ ]]**:
   ```bash
   name="Rincewind42"
   
   if [[ "$name" =~ ^[A-Za-z]+[0-9]+$ ]]; then
       echo "Alphanumeric!"
   fi
   
   # Доступ к захваченным группам:
   if [[ "$name" =~ ^([A-Za-z]+)([0-9]+)$ ]]; then
       echo "Name part: ${BASH_REMATCH[1]}"   # → Rincewind
       echo "Number part: ${BASH_REMATCH[2]}"  # → 42
   fi
   ```

3. **Напиши `student_lookup.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   file="${1:-students.txt}"
   
   while IFS=: read -r name role age specialty; do
       # Regex: только если имя начинается с заглавной буквы
       if [[ "$name" =~ ^[A-Z] ]]; then
           printf "%-20s %-15s age:%-5s %s\n" "$name" "$role" "$age" "$specialty"
       fi
   done < "$file"
   ```

4. **Напиши `validate.sh`** который проверяет ввод через regex:
   - Является ли аргумент числом? `[[ "$1" =~ ^[0-9]+$ ]]`
   - Email формат? `[[ "$1" =~ ^[^@]+@[^@]+\.[a-z]+$ ]]`

📂 Рабочий каталог: `~/.termtrainer/scripting_010`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/scripting_010

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_010"
score=0

if [ -f "$DIR/student_lookup.sh" ]; then
  chmod +x "$DIR/student_lookup.sh"
  out=$(bash "$DIR/student_lookup.sh" students.txt 2>&1)
  echo "$out" | grep -q "Rincewind\|Carrot\|Granny\|Nanny\|Death" && { echo "✓ student_lookup.sh работает"; score=$((score+1)); }
fi

regex_out=$(bash -c '[[ "hello123" =~ ^[a-z]+[0-9]+$ ]] && echo YES || echo NO' 2>/dev/null)
[ "$regex_out" = "YES" ] && { echo "✓ Regex работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Read и regex освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Напиши student_lookup.sh (баллов: $score/2)"
exit 1

HINTS
read -r: не экранировать обратные слеши (ВСЕГДА используй -r!)
read -p: подсказка перед вводом
IFS=: разделитель полей для read (по умолчанию пробел/таб/новая строка)
Regex в bash: [[ "$var" =~ pattern ]] — без кавычек вокруг pattern!
BASH_REMATCH[0]: всё совпадение, [1],[2]... — группы
Цифры regex: [[ "$var" =~ ^[0-9]+$ ]] — проверить что это число
Email regex: [[ "$var" =~ ^[^@]+@[^@]+\.[a-z]+$ ]]
while IFS=: read: парсинг CSV-подобных файлов с разделителем :
