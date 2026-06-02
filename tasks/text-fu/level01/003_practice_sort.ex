META
# Track: text-fu
# Title: Большая инвентаризация
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
# Создаём перемешанный список зелий с дубликатами
cat > "$DIR/зелья.txt" << 'EOF'
Зелье Невидимости
Эликсир Силы
Зелье Невидимости
Противоядие
Зелье Скорости
Эликсир Силы
Настойка Маны
Противоядие
Зелье Невидимости
Эликсир Силы
Зелье Скорости
Настойка Маны
Противоядие
Зелье Невидимости
Зелье Скорости
Эликсир Мудрости
Зелье Огнедышащее
Эликсир Силы
Зелье Невидимости
Настойка Маны
EOF
# Файл с логами для tail/head
for i in $(seq 1 100); do
  echo "[$(date -d "-${i}min" +%H:%M:%S 2>/dev/null || echo "00:$((RANDOM % 60)):$((RANDOM % 60))")] Запись $i: температура зелья $((RANDOM % 100))°C"
done > "$DIR/лог_варки.txt"
# Файл с числами для числовой сортировки
for i in $(seq 1 30); do
  echo $((RANDOM % 1000))
done | sort -R > "$DIR/измерения.txt"

TASK
⚗️ **Большая инвентаризация**

Теперь практика! В лаборатории алхимии хаос — сотни зелий, журналы варки, измерения. Разберись с этим, используя sort, uniq, wc, head, tail.

ASSIGNMENT
📋 **Задания**:
1. Подсчитай, сколько всего зелий в инвентаре (строк в файле)
2. Выведи **уникальные** названия зелий (без дубликатов)
3. Узнай, какое зелье встречается **чаще всего** (подсчёт + сортировка по убыванию)
4. Посмотри **первые 5** записей в журнале варки
5. Посмотри **последние 10** записей в журнале варки
6. Отсортируй измерения **по возрастанию** (числовая сортировка)
7. Сохрани результат инвентаризации в файл `отчёт.txt`

📂 Рабочий каталог: `~/.termtrainer/textfu_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_003"
score=0
errors=0

if [ ! -f "$DIR/зелья.txt" ]; then
  echo "✗ fail: зелья.txt не найден"
  exit 1
fi

# Проверка 1: отчёт.txt создан
if [ -f "$DIR/отчёт.txt" ]; then
  echo "✓ отчёт.txt создан"
  score=$((score + 1))
else
  echo "⚠ отчёт.txt не найден"
  errors=$((errors + 1))
fi

# Проверка 2: в отчёте есть что-то осмысленное
if [ -f "$DIR/отчёт.txt" ]; then
  lines=$(wc -l < "$DIR/отчёт.txt" 2>/dev/null)
  if [ "$lines" -ge 5 ] 2>/dev/null; then
    echo "✓ отчёт.txt содержит $lines строк"
    score=$((score + 1))
  fi
fi

echo "✓ ok: Инвентаризация завершена (баллов: $score)"
exit 0

HINTS
Строки: wc -l ~/.termtrainer/textfu_003/зелья.txt
Уникальные: sort ~/.termtrainer/textfu_003/зелья.txt | uniq
Частота (по убыванию): sort ~/.termtrainer/textfu_003/зелья.txt | uniq -c | sort -rn
Первые 5 логов: head -n 5 ~/.termtrainer/textfu_003/лог_варки.txt
Последние 10 логов: tail -n 10 ~/.termtrainer/textfu_003/лог_варки.txt
Числовая сортировка: sort -n ~/.termtrainer/textfu_003/измерения.txt
Сохрани в отчёт: echo "=== Инвентаризация ===" > ~/.termtrainer/textfu_003/отчёт.txt