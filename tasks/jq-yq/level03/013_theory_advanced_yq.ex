META
# Track: jq-yq
# Title: Продвинутая алхимия yq
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/конфиг.yaml" << 'EOF'
# Конфигурация сервиса зелий
сервер:
  хост: spells.uu.edu
  порт: 8080
база_данных:
  тип: postgresql
  хост: db.uu.edu
  порт: 5432
логирование:
  уровень: info
  файл: /var/log/spells.log
EOF
cat > "$DIR/data.xml" << 'EOF'
<spells>
  <spell type="attack">
    <name>fireball</name>
    <power>90</power>
  </spell>
  <spell type="support">
    <name>heal</name>
    <power>50</power>
  </spell>
</spells>
EOF
cat > "$DIR/data.csv" << 'EOF'
name,price,type
невидимость,100,подкрепление
огненный_шар,300,атака
лечение,50,подкрепление
EOF

TASK
📜 **Продвинутая алхимия yq**

yq — не только YAML. Это швейцарский нож для форматов данных. XML, CSV, TSV, Properties — всё подвластно.

📖 **Конвертация форматов**:
• `yq -p xml -o json '.' файл.xml` — XML → JSON
• `yq -p xml -o yaml '.' файл.xml` — XML → YAML
• `yq -p csv -o json '.' файл.csv` — CSV → JSON
• `yq -p tsv -o yaml '.' файл.tsv` — TSV → YAML
• `-p` = input format, `-o` = output format

📖 **Сложные мутации YAML**:
• Множественные обновления: `yq '.a = "b" | .c.d = "e"' файл`
• ireduce (аналог reduce): `yq '[.items[] | select(.active)] | . as $items | {} | reduce $items[] as $i (.; . + {($i.name): $i.value})'`

📖 **Сохранение комментариев**:
• yq сохраняет комментарии YAML по возможности!
• При `yq -i` обновлении — комментарии не теряются

📖 **Отладка jq**:
• `debug` — вывести промежуточное значение в stderr
• Пример: `jq '.items[] | debug | .name' файл`
• Полезно для понимания потока данных

📂 Рабочий каталог: `~/.ninja_trainer/jqyq_013`

📋 **Попробуй**:
1. XML→JSON: `yq -p xml -o json '.' data.xml`
2. CSV→JSON: `yq -p csv -o json '.' data.csv`
3. Обновить два поля: `yq '.сервер.порт = 9090 | .база_данных.порт = 3306' конфиг.yaml`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/jqyq_013"
score=0

r1=$(yq -p csv -o json '.' "$DIR/data.csv" 2>/dev/null)
[ -n "$r1" ] && echo "$r1" | grep -q 'невидимость' && { echo "✓ CSV→JSON работает"; score=$((score+1)); }

r2=$(yq -p xml -o json '.' "$DIR/data.xml" 2>/dev/null)
[ -n "$r2" ] && echo "$r2" | grep -q 'fireball' && { echo "✓ XML→JSON работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Алхимия yq освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
XML→JSON: yq -p xml -o json '.' файл.xml
CSV→JSON: yq -p csv -o json '.' файл.csv
YAML→XML: yq -p yaml -o xml '.' файл.yaml
Множественные обновления: yq '.a = "b" | .c.d = "e"' файл.yaml
Debug в jq: jq '.items[] | debug | .name' файл — выводит промежуточные значения в stderr
ireduce: аналог reduce для сложных агрегаций в yq
