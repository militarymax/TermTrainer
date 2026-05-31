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
DIR="$HOME/.ninja_trainer/scripting_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/конфиги" "$DIR/отчёты"
cat > "$DIR/конфиги/университет.conf" << 'EOF'
# Конфигурация Незримого Университета
NAME=Unseen University
LOCATION=Ankh-Morpork
STUDENTS=142
ARCHCHANCELLOR=Ridcully
BUDGET=10000
EOF
cat > "$DIR/конфиги/башня.conf" << 'EOF'
# Конфигурация Башни Искусств
NAME=Tower of Art
FLOORS=200
WIZARDS=13
STABLE=yes
EOF
cat > "$DIR/конфиги/сломанный.conf" << 'EOF'
# Повреждённый конфиг
NAME=
LOCATION=
STUDENTS=abc
EOF

TASK
🐉 **Магический конфигуратор** (БОСС)

Архиканцлер Ридкулли требует утилиту для парсинга конфигурационных файлов Университета. Скрипт должен читать ключ=значение, проверять данные и генерировать отчёт.

📋 **Боевые задания**:
1. Создай скрипт `config_parser.sh` который:
   - Принимает путь к конфиг-файлу как `$1`
   - Проверяет, что файл существует (`-f`) и передан аргумент
   - Если нет — выводит `Usage: ./config_parser.sh <config_file>` и завершается с `exit 1`
   - Читает файл построчно через `while read`
   - Пропускает пустые строки и комментарии (начинаются с `#`)
   - Для каждой строки вида `KEY=VALUE` — сохраняет в переменные
   - Выводит все найденные ключи и значения в формате: `ключ = значение`

2. Добавь в скрипт проверки:
   - Если значение пустое — вывести `⚠ ПУСТОЕ ЗНАЧЕНИЕ: ключ`
   - Если STUDENTS не число — вывести `⚠ НЕ ЧИСЛО: STUDENTS=значение`
   - В конце вывести общее количество обработанных ключей

3. Запусти скрипт для всех трёх конфигов и сохрани результаты:
   - `bash config_parser.sh конфиги/университет.conf > отчёты/университет.log`
   - `bash config_parser.sh конфиги/башня.conf > отчёты/башня.log`
   - `bash config_parser.sh конфиги/сломанный.conf > отчёты/сломанный.log 2> отчёты/ошибки.log`

📂 Рабочий каталог: `~/.ninja_trainer/scripting_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_006"
score=0

if [ -f "$DIR/config_parser.sh" ]; then
  echo "✓ config_parser.sh создан"
  score=$((score+1))
  
  # Тест с существующим файлом
  output=$(bash "$DIR/config_parser.sh" "$DIR/конфиги/университет.conf" 2>/dev/null)
  echo "$output" | grep -qi 'name' && { echo "✓ Парсер читает ключи"; score=$((score+1)); }
  
  # Тест без аргумента
  bash "$DIR/config_parser.sh" >/dev/null 2>&1; rc=$?
  if [ $rc -ne 0 ]; then
    echo "✓ Возвращает ошибку без аргумента"
    score=$((score+1))
  fi
  
  # Тест со сломанным конфигом
  output=$(bash "$DIR/config_parser.sh" "$DIR/конфиги/сломанный.conf" 2>/dev/null)
  echo "$output" | grep -qiE '(пусто|empty|warn|⚠)' && { echo "✓ Обнаруживает пустые значения"; score=$((score+1)); }
fi

# Отчёты созданы
for f in "университет.log" "башня.log"; do
  if [ -f "$DIR/отчёты/$f" ]; then
    echo "✓ $f создан"
    score=$((score+1))
  fi
done

[ $score -ge 4 ] && { echo "✓ ok: БОСС пройден! Магический конфигуратор работает! (баллов: $score/6)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/6)"
exit 1

HINTS
Пропуск комментариев: case "$line" in \#*|"") continue ;; esac
Разделение KEY=VALUE: key="${line%%=*}"; value="${line#*=}"
Проверка числа: case "$value" in ''|*[!0-9]*) echo "Не число!" ;; esac
Пустое значение: if [ -z "$value" ]; then echo "⚠ Пустое: $key"; fi
Перенаправление: ./config_parser.sh файл.conf > отчёт.log 2> ошибки.log
