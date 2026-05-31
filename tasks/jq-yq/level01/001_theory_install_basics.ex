META
# Track: jq-yq
# Title: Инструменты Казначея
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/маг.json" << 'EOF'
{
  "университет": "Незримый Университет",
  "ректор": "Архиканцлер Ридкулли",
  "студенты": 200,
  "факультеты": ["магия", "алхимия", "скриптология"],
  "бюджет": {
    "доход": 50000,
    "расход": 48000,
    "валюта": "анх-морпоркские доллары"
  }
}
EOF

TASK
📜 **Инструменты Казначея**

Ринсвинд устроился помощником казначея Университета. Все отчёты хранятся в формате JSON и YAML — магических языках структурированных данных. Чтобы читать и обрабатывать их, нужны специальные инструменты: `jq` для JSON и `yq` для YAML.

📖 **Установка**:
• **macOS**: `brew install jq yq`
• **Linux (Debian/Ubuntu)**: `sudo apt install jq && sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq`
• **Проверка**: `jq --version` и `yq --version`

📖 **Разница между jq и yq**:
• `jq` — работает ТОЛЬКО с JSON
• `yq` (Go-версия mikefarah) — работает с YAML, JSON, XML, CSV, TSV
• Оба используют похожий синтаксис фильтров

📖 **Простейшие фильтры jq**:
• Identity filter `.` — выводит весь JSON как есть (с форматированием)
• Field access: `.name`, `.["name"]` — доступ к полю объекта
• Array indexing: `.[0]` — первый элемент массива
• Safe operator `?`: `.user.profile.email?` — не падать если ключа нет
• Pipe `|`: передача вывода одного фильтра другому

📖 **Примеры**:
```bash
jq '.' маг.json              # весь JSON с отступами
jq '.ректор' маг.json        # "Архиканцлер Ридкулли"
jq '.факультеты[0]' маг.json # "магия"
jq '.бюджет | .доход' маг.json # 50000
```

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_001`

📋 **Попробуй**:
1. Проверь установку: `jq --version` и `yq --version`
2. Выведи весь JSON: `cd ~/.ninja_trainer/jqyq_001 && jq '.' маг.json`
3. Извлеки ректора: `jq '.ректор' маг.json`
4. Первый факультет: `jq '.факультеты[0]' маг.json`
5. Доход через pipe: `jq '.бюджет | .доход' маг.json`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_001"
score=0

if command -v jq &>/dev/null; then
  echo "✓ jq установлен: $(jq --version)"
  score=$((score+1))
else
  echo "✗ jq не установлен. Выполни: brew install jq"
fi

if [ -f "$DIR/маг.json" ]; then
  echo "✓ маг.json на месте"
  score=$((score+1))
fi

if command -v yq &>/dev/null; then
  echo "✓ yq установлен: $(yq --version 2>&1 | head -1)"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Инструменты Казначея готовы! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно установить jq/yq (баллов: $score/3)"
exit 1

HINTS
Установка macOS: brew install jq yq
Установка Linux: sudo apt install jq; wget + chmod для yq
Весь JSON: jq '.' файл.json
Поле объекта: jq '.ключ' файл.json
Элемент массива: jq '.массив[0]' файл.json
Pipe: jq '.a | .b' файл.json — передать результат дальше
Safe operator: jq '.несуществующий?' файл.json — без ошибки
