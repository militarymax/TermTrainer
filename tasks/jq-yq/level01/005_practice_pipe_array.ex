META
# Track: jq-yq
# Title: Трубопроводы данных
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/api_response.json" << 'EOF'
{
  "status": "ok",
  "count": 4,
  "results": [
    {"id": 1, "name": "fireball", "power": 90, "type": "attack"},
    {"id": 2, "name": "heal", "power": 50, "type": "support"},
    {"id": 3, "name": "shield", "power": 70, "type": "defense"},
    {"id": 4, "name": "teleport", "power": 95, "type": "utility"}
  ]
}
EOF

TASK
🔗 **Трубопроводы данных**

Казначей получает данные из магического API. Нужно уметь комбинировать фильтры через pipe и извлекать данные из вложенных структур.

📋 **Задания**:
1. Статус API: `jq -r '.status' api_response.json`
2. Все заклинания: `jq '.results[]' api_response.json`
3. Только имена через pipe: `jq -r '.results[] | .name' api_response.json`
4. Имя первого заклинания: `jq -r '.results[0].name' api_response.json`
5. Типы всех заклинаний: `jq -r '.results[] | .type' api_response.json`
6. Новый объект — только имена и сила: `jq '.results[] | {name, power}' api_response.json`
7. Количество результатов: `jq '.results | length' api_response.json`

💡 **Ключевые паттерны**:
• `.массив[]` — развернуть массив в поток элементов
• `.a | .b` — передать результат следующему фильтру
• `{key1, key2}` — построить новый объект (сокращение от `{key1: .key1, key2: .key2}`)
• `length` — длина массива или строки

📂 Рабочий каталог: `~/.termtrainer/jqyq_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/jqyq_005"
score=0

result1=$(jq -r '.status' "$DIR/api_response.json" 2>/dev/null)
[ "$result1" = "ok" ] && { echo "✓ Статус API"; score=$((score+1)); }

result2=$(jq -r '.results[] | .name' "$DIR/api_response.json" 2>/dev/null | head -1)
[ "$result2" = "fireball" ] && { echo "✓ Pipe + массив"; score=$((score+1)); }

result3=$(jq '.results | length' "$DIR/api_response.json" 2>/dev/null)
[ "$result3" = "4" ] && { echo "✓ Length работает"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Трубопроводы освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Развернуть массив: jq '.массив[]' файл — каждый элемент отдельно
Pipe: jq '.a | .b' файл — передать результат дальше
Имена из массива: jq -r '.items[] | .name' файл
Новый объект: jq '.items[] | {name, power}' файл
Длина массива: jq '.array | length' файл
Безопасный доступ: jq '.user?.email?' файл — ? подавляет ошибки
