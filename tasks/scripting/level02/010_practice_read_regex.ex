META
# Track: scripting
# Title: Чтение звёздных карт
# Number: 010
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/звёздный_каталог.txt" << 'EOF'
Альдебаран|Красный гигант|0.85|16
Сириус|Белый карлик|1.42|8
Вега|Белый голубой|0.03|25
Бетельгейзе|Красный сверхгигант|0.50|700
Процион|Жёлто-белый|1.14|11
EOF
cat > "$DIR/заклинания.log" << 'EOF'
[2024-01-15] CAST fire_ball power=42 target=goblin
[2024-01-15] CAST heal power=10 self=true
[2024-01-15] FAIL curse reason=invalid_target
[2024-01-16] CAST invisibility power=99 target=self
[2024-01-16] CAST teleport power=75 target=tower
[2024-01-16] FAIL summon reason=insufficient_mana
EOF

TASK
⭐ **Чтение звёздных карт**

Астрологи читают звёздные карты — строки данных, разделённые спецсимволами. Нужно уметь извлекать данные из любого формата и распознавать паттерны.

📋 **Задания**:
1. Создай скрипт `star_reader.sh` который:
   - Читает `звёздный_каталог.txt` через `while IFS='|' read -r name type dist temp`
   - Выводит каждую звезду в формате: `★ $name ($type) — расстояние: $dist, температура: $temp`
   - Использует `[[ ]]` для проверки: если температура > 100 — добавить `⚠ СВЕРХГИГАНТ`

2. Создай скрипт `spell_analyzer.sh` который:
   - Читает `заклинания.log` построчно
   - С помощью `=~` в `[[ ]]` проверяет формат строки
   - Для строк с `CAST`: извлекает заклинание, power и target через BASH_REMATCH
   - Подсчитывает успешные CAST и провальные FAIL
   - Выводит итоговую статистику

💡 **Продвинутый read**:
• `-r` — не экранировать обратные слеши (всегда используй!)
• `IFS=',' read -r a b c` — разделитель запятая
• `read -d ''` — читать до конца (а не до перевода строки)

💡 **Regex в bash**:
• `[[ "$str" =~ pattern ]]` — матчинг
• `${BASH_REMATCH[0]}` — всё совпадение
• `${BASH_REMATCH[1]}` — первая группа захвата

📂 Рабочий каталог: `~/.ninja_trainer/scripting_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_010"
score=0

if [ -f "$DIR/star_reader.sh" ]; then
  echo "✓ star_reader.sh создан"
  score=$((score+1))
  output=$(bash "$DIR/star_reader.sh" 2>/dev/null)
  echo "$output" | grep -qi 'альдебаран\|сириус' && { echo "✓ Звёзды прочитаны"; score=$((score+1)); }
fi

if [ -f "$DIR/spell_analyzer.sh" ]; then
  echo "✓ spell_analyzer.sh создан"
  score=$((score+1))
  output=$(bash "$DIR/spell_analyzer.sh" 2>/dev/null)
  echo "$output" | grep -qiE '(cast|fail|успешн|провал)' && { echo "✓ Статистика заклинаний"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Звёздные карты прочитаны! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Чтение с разделителем: while IFS='|' read -r name type dist temp; do echo "$name"; done < звёздный_каталог.txt
Regex в bash: if [[ "$line" =~ ^\[([0-9-]+)\]\ (CAST|FAIL)\ (.+)$ ]]; then echo "${BASH_REMATCH[1]}"; fi
BASH_REMATCH: [0]=всё совпадение, [1]=первая группа (), [2]=вторая...
Проверка числа в [[ ]]: if [[ $temp -gt 100 ]]; then echo "Сверхгигант!"; fi
read -r: всегда используй -r чтобы обратные слеши не экранировались
