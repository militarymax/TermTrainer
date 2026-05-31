META
# Track: jq-yq
# Title: Модули и отладка
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/report.json" << 'EOF'
{
  "отделы": [
    {"название": "зельеварение", "доход": 25000, "расход": 18000, "сотрудники": 12},
    {"название": "скриптология", "доход": 15000, "расход": 12000, "сотрудники": 8},
    {"название": "гитология", "доход": 8000, "расход": 9000, "сотрудники": 5},
    {"название": "алхимия", "доход": 30000, "расход": 22000, "сотрудники": 15}
  ]
}
EOF

TASK
🔧 **Модули и отладка**

Сложные запросы нужно структурировать — выносить в функции и файлы. А когда что-то не работает — отлаживать.

📋 **Задания**:

1. **Напиши функцию**:
   `jq 'def прибыль: .доход - .расход; .отделы[] | {название, прибыль: прибыль}' report.json`

2. **Функция с параметрами**:
   `jq 'def рентабельность($prefix): "\($prefix) \((.доход - .расход) / .доход * 100 | floor)%"; .отделы[] | {название, рентабельность: рентабельность("ROI:")}' report.json`

3. **Вынеси логику в файл**:
   Создай `analysis.jq`:
   ```
   def прибыль: .доход - .расход;
   def рентабельность: ((.доход - .расход) / .доход * 100 | floor);
   .отделы[] | {название, прибыль: прибыль, roi: рентабельность}
   ```
   Запусти: `jq -f analysis.jq report.json`

4. **Отладка через debug**:
   `jq '.отделы[] | debug | select(.доход > 10000)' report.json`
   debug выводит промежуточные значения в stderr!

5. **Обработка null значений**:
   `jq '.отделы[] | .неизвестное_поле // "N/A"' report.json`
   Оператор `//` — значение по умолчанию если null/false

6. **Портирование jq → yq**:
   Попробуй тот же фильтр в yq (синтаксис может отличаться):
   `yq '.отделы[] | select(.доход > 10000)' report.json`

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_015"
score=0

r1=$(jq '[.отделы[] | .доход - .расход] | add' "$DIR/report.json" 2>/dev/null)
[ "$r1" = "17000" ] && { echo "✓ Математика работает: прибыль=$r1"; score=$((score+1)); }

if [ -f "$DIR/analysis.jq" ]; then
  r2=$(jq -f "$DIR/analysis.jq" "$DIR/report.json" 2>/dev/null | head -5)
  [ -n "$r2" ] && { echo "✓ Модуль работает"; score=$((score+1)); }
fi

r3=$(jq '.отделы[] | .несуществует // "default"' "$DIR/report.json" 2>/dev/null | head -1)
[ "$r3" = '"default"' ] && { echo "✓ Default operator работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Модули и отладка освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Def function: jq 'def myfunc: .field * 2; map(myfunc)' файл
Function with args: jq 'def fmt($unit): "\(.val) \($unit)"; .items[] | fmt("kg")' файл
From file: jq -f script.jq data.json — логика в отдельном файле
Debug: jq '.items[] | debug | .name' файл — выводит промежуточные значения в stderr
Default operator: jq '.field // "fallback"' файл — если null или false
Alternative: jq '.a // .b // "none"' файл — цепочка fallback-ов
