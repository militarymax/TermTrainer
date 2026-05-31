META
# Track: scripting
# Title: Подстановки Канцлера
# Number: 012
# Level: 3
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Подстановки Канцлера**

Канцлер Университета не терпит неопределённости. Переменная без значения? Ошибка! Нет значения по умолчанию? Недопустимо! Здесь ты освоишь продвинутые подстановки и ассоциативные массивы.

📖 **Подстановки значений**:
• `${var:-default}` — использовать default, если var пустая или не задана
• `${var:=default}` — то же, но ещё и присвоить default переменной
• `${var:+instead}` — использовать instead, если var задана (инверсия)
• `${var:?error message}` — прервать скрипт с ошибкой, если var пустая

📖 **Экранирование**:
• `${var@Q}` — экранировать значение для повторного использования
• `printf -v var "format" args` — сохранить форматированный вывод в переменную

📖 **Ассоциативные массивы (bash 4+)**:
• Объявление: `declare -A map=([key1]=val1 [key2]=val2)`
• Доступ: `"${map[$key]}"`
• Все ключи: `"${!map[@]}"`
• Проверка ключа: `[[ -v map[$key] ]]`
• Длина: `${#map[@]}`

📖 **Примеры**:
```bash
name="${1:?Usage: $0 <name>}"   # Обязательный аргумент
port="${PORT:-8080}"             # Значение по умолчанию
declare -A colors=([fire]=red [ice]=blue [earth]=brown)
echo "${colors[fire]}"          # red
```

📂 Рабочий каталог: `~/.ninja_trainer/scripting_012`

📋 **Попробуй**:
1. Создай скрипт `defaults.sh` с использованием `${var:-default}` и `${var:?error}`
2. Создай скрипт `assoc.sh` с `declare -A` — словарь заклинаний и их цветов

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_012"
score=0

if [ -f "$DIR/defaults.sh" ]; then
  echo "✓ defaults.sh создан"
  score=$((score+1))
  grep -qE '\$\{.*:-|:\?' "$DIR/defaults.sh" 2>/dev/null && { echo "✓ Подстановки используются"; score=$((score+1)); }
fi

if [ -f "$DIR/assoc.sh" ]; then
  echo "✓ assoc.sh создан"
  score=$((score+1))
  grep -q 'declare -A' "$DIR/assoc.sh" 2>/dev/null && { echo "✓ declare -A используется"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Подстановки Канцлера усвоены! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Значение по умолчанию: port="${PORT:-8080}"; echo "Port: $port"
Обязательный аргумент: name="${1:?Не указано имя}"; echo "Hello, $name"
Ассоциативный массив: declare -A spells=([fire]="Огненный шар" [ice]="Ледяная стрела")
Доступ: echo "${spells[fire]}"
Перебор: for key in "${!spells[@]}"; do echo "$key = ${spells[$key]}"; done
printf -v: printf -v msg "Привет, %s!" "Ринсвинд"; echo "$msg"
