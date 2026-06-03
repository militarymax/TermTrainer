META
# Track: scripting
# Title: Подстановки Канцлера
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: Подстановки Канцлера

Архиканцлер вызвал тебя в Тайную Комнату:
«Ринсвинд, есть заклинания, которым не учат на первом курсе.
Подстановки с значениями по умолчанию, ассоциативные массивы,
printf -v... Это арсенал Канцлера. Используй мудро — или не используй
вообще. Последний, кто применил ${var:?error} к демону...
Ну, давай скажем так: демону это НЕ понравилось.»

───────────────────────────────────────
🔹 ПОДСТАНОВКИ СО ЗНАЧЕНИЯМИ ПО УМОЛЧАНИЮ
───────────────────────────────────────

```bash
name=""                       # Пустая переменная

${name:-default}              # → "default" (если пуста или не задана)
${name:=default}              # → "default" И присвоить! 
${name:+instead}              # → "instead" (если ЗАДАНА и НЕ пуста)
${name:?Error: name is empty} # → ОШИБКА и exit если пуста!
```

• `:-` — значение по умолчанию (БЕЗ изменения переменной)
• `:=` — значение по умолчанию С изменением переменной
• `:+` — альтернативное значение если ЗАДАНА
• `:?` — прервать с ошибкой если пуста (идеально для обязательных параметров!)

───────────────────────────────────────
🔹 АССОЦИАТИВНЫЕ МАССИВЫ (bash 4+)
───────────────────────────────────────

```bash
declare -A towers=([main]=10 [library]=5 [dungeon]=3)

echo "${towers[main]}"        # → 10
echo "${towers[@]}"           # → 10 5 3 (все значения)
echo "${!towers[@]}"          # → main library dungeon (все ключи)

# Проверка существования ключа:
[[ -v towers[lab] ]] || echo "No lab tower!"

for key in "${!towers[@]}"; do
    echo "$key: ${towers[$key]}"
done
```

⚠️ Требуется bash 4+! На macOS старый bash 3.2 — нужен `brew install bash`

───────────────────────────────────────
🔹 printf -v И ДРУГИЕ ТРЮКИ
───────────────────────────────────────

```bash
# Записать форматированный вывод в переменную (без подстановки команд!)
printf -v header "═══ %s ═══" "Tower Report"
echo "$header"               # → ═══ Tower Report ═══

# Экранирование для повторного использования
cmd="ls -la /tmp"
escaped="${cmd@Q}"           # → 'ls -la /tmp' (экранировано для eval)
eval "$escaped"
```

───────────────────────────────────────
🔹 МОДУЛЬНОСТЬ — БИБЛИОТЕКИ ФУНКЦИЙ
───────────────────────────────────────

```bash
# utils.sh — библиотека функций
log_info() { printf "[INFO] %s\n" "$1"; }

# Проверка: запущен скрипт или загружен как библиотека?
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Скрипт запущен напрямую
    main "$@"
fi
# Если source utils.sh — функции доступны, но main не запускается!

# В другом скрипте:
source ./utils.sh             # Подключить библиотеку
log_info "Library loaded!"    # Использовать функцию
```

📂 Рабочий каталог: `~/.termtrainer/scripting_012`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/scripting_012
📋 **Попробуй**:
1. Default value: `echo "${undefined_var:-fallback}"`
2. Error on empty: `empty=""; echo "${empty:?This is required!}"`
3. Associative array: `declare -A m=([a]=1 [b]=2); echo "${m[a]}"`

VALIDATION
#!/bin/bash
score=0

def_out=$(bash -c 'echo "${x:-default}"' 2>/dev/null)
[ "$def_out" = "default" ] && { echo "✓ Подстановка по умолчанию работает"; score=$((score+1)); }

err_out=$(bash -c 'x=""; echo "${x:?ERROR}"' 2>&1)
echo "$err_out" | grep -q "ERROR\|unset" && { echo "✓ :? работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Подстановки Канцлера освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
${var:-default}: значение по умолчанию если var пуста/не задана
${var:=default}: то же + ПРИСВОИТЬ значение переменной
${var:+instead}: значение если var ЗАДАНА (инвертированная проверка)
${var:?error}: прервать скрипт с сообщением об ошибке если var пуста
declare -A: создать ассоциативный массив (ключ→значение), bash 4+
${!arr[@]}: все ключи ассоциативного массива
[[ -v arr[key] ]]: проверить существует ли ключ
printf -v var: записать форматированный вывод прямо в переменную
BASH_SOURCE[0]==$0: проверить запущен ли скрипт или загружен через source
