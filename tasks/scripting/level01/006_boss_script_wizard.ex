META
# Track: scripting
# Title: Магический конфигуратор
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/configs"
cat > "$DIR/configs/university.conf" << 'EOF'
UNIVERSITY_NAME=Unseen University
MAX_STUDENTS=200
DEAN=Ridcully
TOWER_FLOORS=10
EOF
cat > "$DIR/configs/potions.conf" << 'EOF'
HEALING_POWER=50
MANA_RESTORE=30
FIRE_DAMAGE=100
INVISIBILITY_DURATION=60
EOF

TASK
🐉 БОСС #006: Магический конфигуратор

Архиканцлер вызвал тебя в свой кабинет и положил на стол два конфигурационных свитка:
«Ринсвинд! Мне нужен скрипт, который читает эти свитки, проверяет все значения
и выводит красивый отчёт. Если хоть одно значение отсутствует — я хочу знать об этом!
И не забудь про шебанг, кавычки и коды возврата.
В прошлый раз ты забыл кавычки вокруг переменной с пробелом.
Мы до сих пор восстанавливаем Башню после того "небольшого взрыва".»

📋 **Боевые задания**:

ASSIGNMENT
1. **Напиши `configure.sh`** который:
   - Принимает путь к каталогу как `$1` (по умолчанию `configs`)
   - Проверяет что каталог существует (`[ -d ]`)
   - Перебирает все `.conf` файлы в каталоге
   - Для каждого файла читает строки через `while read`
   - Пропускает пустые строки и комментарии (`#`)
   - Выводит форматированный отчёт

2. **Скрипт должен использовать**:
   - Шебанг `#!/bin/bash`
   - Проверку аргументов с `exit 1` при ошибке
   - Кавычки вокруг ВСЕХ переменных
   - `while IFS== read -r key value` для парсинга KEY=VALUE
   - Код возврата 0 при успехе

3. **Пример вывода**:
   ```
   ═══ University Configuration ═══
   UNIVERSITY_NAME = Unseen University
   MAX_STUDENTS = 200
   DEAN = Ridcully
   TOWER_FLOORS = 10
   
   ═══ Potions Configuration ═══
   HEALING_POWER = 50
   MANA_RESTORE = 30
   FIRE_DAMAGE = 100
   INVISIBILITY_DURATION = 60
   
   Total: 8 settings loaded from 2 files.
   ```

📂 Рабочий каталог: `~/.termtrainer/scripting_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_006"
score=0

if [ -f "$DIR/configure.sh" ]; then
  head -1 "$DIR/configure.sh" | grep -q '^#!' && { echo "✓ Шебанг есть"; score=$((score+1)); }
  
  chmod +x "$DIR/configure.sh"
  out=$(bash "$DIR/configure.sh" configs 2>&1)
  
  echo "$out" | grep -qi "university\|students\|dean\|healing\|fire" && { echo "✓ Конфигурация читается"; score=$((score+1)); }
  
  echo "$out" | grep -qi "total\|loaded\|files\|settings" && { echo "✓ Отчёт формируется"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Конфигуратор работает! (баллов: $score/3)"; exit 0; }
echo "✗ Напиши configure.sh (баллов: $score/3)"
exit 1

HINTS
Шебанг: #!/bin/bash — первая строка!
Проверка каталога: if [ ! -d "$1" ]; then echo "Error"; exit 1; fi
Перебор файлов: for file in "$dir"/*.conf; do ... done
Чтение построчно: while IFS== read -r key value; do ... done < "$file"
Пропуск пустых: [ -z "$line" ] && continue
Пропуск комментариев: [[ "$line" == \#* ]] && continue
Кавычки: ВСЕГДА "$var" — особенно если значение содержит пробелы!
Exit code: exit 0 при успехе, exit 1+ при ошибке
