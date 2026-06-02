META
# Track: scripting
# Title: Свиток с аргументами
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #003: Свиток с аргументами

Архиканцлер вызвал тебя в кабинет:
«Ринсвинд, мне нужен скрипт. Нет, НЕ тот, что ты написал вчера.
Тот был без шебанга, без проверки аргументов и вообще удалил
мои личные записи. Напиши ПРАВИЛЬНЫЙ скрипт или пойдёшь чистить
подвалы. Там завелся... ну, лучше не спрашивай.»

📋 **Задания**:

ASSIGNMENT
1. **Создай `hello.sh`** с шебангом, который:
   - Проверяет что передан аргумент `$1`
   - Если нет → выводит `Usage: ./hello.sh <name>` и завершается с кодом 1
   - Если да → выводит `Hello, $1! Welcome to Unseen University!`

2. **Создай `power.sh`** который:
   - Принимает два числа: `$1` и `$2`
   - Выводит их сумму через `$(( ))`: `Power level: $(( $1 + $2 ))`
   - Если аргументов меньше двух → ошибка

3. **Создай `check.sh`** который:
   - Принимает имя файла как `$1`
   - Проверяет `-f "$1"` — существует ли файл?
   - Выводит результат: `"File exists"` или `"File not found"`

4. **Протестируй все три скрипта**:
   ```bash
   chmod +x hello.sh power.sh check.sh
   ./hello.sh Rincewind        # → Hello, Rincewind!
   ./hello.sh                  # → Usage: ...
   echo $?                     # → 1 (код ошибки)
   ./power.sh 10 20            # → Power level: 30
   ./check.sh /etc/hostname    # → File exists
   ```

📂 Рабочий каталог: `~/.termtrainer/scripting_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_003"
score=0

if [ -f "$DIR/hello.sh" ] && head -1 "$DIR/hello.sh" | grep -q '^#!'; then
  out=$(bash "$DIR/hello.sh" Rincewind 2>&1)
  echo "$out" | grep -qi "rincewind" && { echo "✓ hello.sh работает"; score=$((score+1)); }
fi

if [ -f "$DIR/power.sh" ]; then
  out=$(bash "$DIR/power.sh" 10 20 2>&1)
  echo "$out" | grep -q "30" && { echo "✓ power.sh считает"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Скрипты с аргументами освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай hello.sh и power.sh (баллов: $score/2)"
exit 1

HINTS
Шебанг: первая строка #!/bin/bash
Проверка аргумента: if [ -z "$1" ]; then echo "Usage"; exit 1; fi
Арифметика: echo $(( $1 + $2 )) — сложение чисел
Проверка файла: if [ -f "$1" ]; then ... fi
Код возврата: exit 0 = успех, exit 1+ = ошибка
Проверь код: echo $? после запуска скрипта
chmod +x: сделай скрипты исполняемыми перед запуском через ./
