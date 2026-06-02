META
# Track: jq-yq
# Title: Редукции и функции Канцлера
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/transactions.json" << 'EOF'
{
  "транзакции": [
    {"тип": "доход", "сумма": 5000, "категория": "зелья"},
    {"тип": "расход", "сумма": 2000, "категория": "ингредиенты"},
    {"тип": "доход", "сумма": 3000, "категория": "услуги"},
    {"тип": "расход", "сумма": 1500, "категория": "зарплаты"},
    {"тип": "доход", "сумма": 8000, "категория": "зелья"},
    {"тип": "расход", "сумма": 3000, "категория": "ингредиенты"}
  ]
}
EOF

TASK
📜 **Редукции и функции Канцлера**

Для сложных вычислений — reduce. Для переиспользования кода — функции. Для модульности — импорт.

📖 **reduce** — сворачивает массив в одно значение:
• `jq 'reduce .[] as $item (0; . + $item)' файл` — сумма всех элементов
• Синтаксис: `reduce STREAM as $var (INIT; UPDATE)`
• Пример: `jq 'reduce .транзакции[] as $t (0; if $t.тип=="доход" then .+$t.сумма else . end)' файл`

📖 **foreach** — как reduce, но выдаёт промежуточные значения:
• `foreach STREAM as $var (INIT; UPDATE; EXTRACT)`

📖 **Функции (def)**:
• `def name: body;` — определить функцию
• `def double: . * 2; [1,2,3] | map(double)` → `[2,4,6]`
• `def add_field(key; val): . + {(key): val};` — с параметрами

📖 **Модули**:
• `import "module" as mod;` — импортировать модуль
• `jq -L /path/to/modules --from-file script.jq файл` — выполнить из файла
• Вынос сложной логики в отдельный `.jq` файл

📂 Рабочий каталог: `~/.termtrainer/jqyq_012`

📋 **Попробуй**:
1. Сумма доходов через reduce: `jq 'reduce .транзакции[] as $t (0; if $t.тип=="доход" then .+$t.сумма else . end)' transactions.json`
2. Функция double: `echo '[1,2,3]' | jq 'def double: . * 2; map(double)'`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_012"
score=0

r1=$(jq 'reduce .транзакции[] as $t (0; if $t.тип=="доход" then .+$t.сумма else . end)' "$DIR/transactions.json" 2>/dev/null)
[ "$r1" = "16000" ] && { echo "✓ Reduce работает: доходы=$r1"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Редукции освоены! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Reduce sum: jq 'reduce .items[] as $x (0; . + $x.value)' файл
Reduce conditional: jq 'reduce .[] as $x (0; if $x.type=="A" then .+$x.val else . end)' файл
Def function: echo 'data' | jq 'def myfunc: . * 2; myfunc'
Function with args: def greet($name): "Hello \($name)"; greet("World")
From file: jq -f script.jq data.json — логика в отдельном файле
Foreach: foreach .[] as $x (0; .+$x; .) — промежуточные значения
