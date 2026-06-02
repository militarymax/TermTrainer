META
# Track: scripting
# Title: Щиты и печати
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/configs"
cat > "$DIR/configs/tower.conf" << 'EOF'
TOWER_NAME=Unseen University
MAX_FLOORS=10
SECRET_PASSWORD=opensesame
EOF

TASK
⚗️ ПРАКТИКУМ #015: Щиты и печати

Архиканцлер вызвал тебя в Тайную Комнату:
«Ринсвинд! Кто-то подсунул нам скрипт с eval внутри.
EVAL! Ты понимаешь, что это значит? Любой демон может
впрыснуть команду через переменную! И ещё — пароли
в конфигах без защиты! Напиши БЕЗОПАСНЫЙ скрипт или
я отправлю тебя в Подвалы. К Тому Самому.»

📋 **Задания**:

1. **Напиши `safe_config.sh`** — безопасное чтение конфига:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   readonly CONF_FILE="${1:-configs/tower.conf}"
   
   # Безопасное чтение конфига (БЕЗ eval!)
   declare -A config    # Ассоциативный массив
   
   while IFS='=' read -r key value; do
       # Пропустить пустые строки и комментарии
       [[ -z "$key" || "$key" == \#* ]] && continue
       
       # Валидация ключа: только буквы и подчёркивания
       if [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
           echo "WARNING: Invalid key '$key'" >&2
           continue
       fi
       
       config["$key"]="$value"
   done < "$CONF_FILE"
   
   # Вывод (СКРЫВАЕМ секреты!)
   for key in "${!config[@]}"; do
       if [[ "$key" == *"SECRET"* || "$key" == *"PASSWORD"* ]]; then
           printf "%s=***HIDDEN***\n" "$key"
       else
           printf "%s=%s\n" "$key" "${config[$key]}"
       fi
   done
   ```

2. **Безопасная динамическая команда** (БЕЗ eval):
   ```bash
   # ОПАСНО:
   eval "ls $dir"          # Если $dir="; rm -rf /" → КАТАСТРОФА!
   
   # БЕЗОПАСНО через массивы:
   cmd=(ls -la "$dir")     # Каждый элемент — отдельный аргумент
   "${cmd[@]}"             # Выполнить безопасно!
   ```

3. **Напиши `safe_run.sh`** который:
   - Принимает команду как отдельные аргументы
   - Использует массив для построения команды
   - НЕ использует eval
   - Проверяет что команда существует перед запуском

4. **Отладка** — добавь трассировку:
   ```bash
   set -x                              # Включить трассировку
   PS4='+ ${BASH_SOURCE}:${LINENO} '   # Улучшенный формат трейса
   # ... код ...
   set +x                              # Выключить трассировку
   ```

📂 Рабочий каталог: `~/.termtrainer/scripting_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_015"
score=0

if [ -f "$DIR/safe_config.sh" ]; then
  chmod +x "$DIR/safe_config.sh"
  out=$(bash "$DIR/safe_config.sh" 2>&1)
  echo "$out" | grep -qi "HIDDEN\|tower\|floor\|password" && { echo "✓ safe_config.sh работает"; score=$((score+1)); }
fi

if [ -f "$DIR/safe_run.sh" ]; then
  chmod +x "$DIR/safe_run.sh"
  bash "$DIR/safe_run.sh" ls /tmp 2>&1 | grep -q "." && { echo "✓ safe_run.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Безопасность освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Напиши safe_config.sh (баллов: $score/2)"
exit 1

HINTS
НИКОГДА eval: eval "$var" — если $var содержит ; rm -rf / → катастрофа!
Безопасные команды: cmd=(ls -la "$dir"); "${cmd[@]}" — массив вместо eval
Валидация ключей: [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] — только допустимые символы
Скрытие секретов: не выводить PASSWORD/SECRET значения в логи
set -x: включить трассировку выполнения команд
PS4: формат строки трейса (+ файл:строка )
declare -A: ассоциативный массив для хранения конфигурации
readonly: сделать переменную неизменяемой после присвоения
