META
# Track: scripting
# Title: Колесо перерождений
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/potions"
for p in healing mana fire invisibility strength; do
  echo "$p:$((RANDOM%100))" >> "$DIR/potions/inventory.txt"
done
cat > "$DIR/potions/recipe.txt" << 'EOF'
dragon_scale:3
phoenix_feather:1
moonstone:5
unicorn_hair:7
EOF

TASK
⚗️ ПРАКТИКУМ #004: Колесо перерождений

Мастер Зелий Декан Чартер швырнул на стол список ингредиентов:
«Ринсвинд! Каждый зельевар должен уметь перебирать ингредиенты,
обрабатывать списки и повторять действия. Научись — или будешь
чистить котлы. Вечно. Без перерывов на обед.»

📋 **Задания**:

ASSIGNMENT
1. **Цикл for — перебор зелий**:
   Напиши `brew.sh`:
   ```bash
   #!/bin/bash
   for potion in healing mana fire; do
       echo "Brewing $potion potion..."
   done
   echo "All potions brewed!"
   ```

2. **Цикл while read — обработка файла**:
   Напиши `inventory.sh` который читает `potions/inventory.txt` построчно:
   ```bash
   #!/bin/bash
   while IFS=: read -r name power; do
       echo "Potion: $name (power: $power)"
   done < potions/inventory.txt
   ```

3. **Арифметический цикл** — варим N зелий:
   Напиши `batch.sh`:
   ```bash
   #!/bin/bash
   count="${1:-5}"
   for ((i=1; i<=count; i++)); do
       echo "Brewing potion #$i of $count..."
   done
   echo "Batch complete: $count potions brewed."
   ```

4. **$@ — все аргументы**:
   Напиши `summon.sh`:
   ```bash
   #!/bin/bash
   echo "Summoning creatures:"
   for creature in "$@"; do
       echo "  → $creature summoned!"
   done
   echo "Total: $# creatures summoned."
   ```
   Запусти: `./summon.sh dragon imp goblin`

📂 Рабочий каталог: `~/.termtrainer/scripting_004`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/scripting_004

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_004"
score=0

[ -f "$DIR/brew.sh" ] && bash "$DIR/brew.sh" 2>&1 | grep -q "healing" && { echo "✓ brew.sh работает"; score=$((score+1)); }
[ -f "$DIR/inventory.sh" ] && bash "$DIR/inventory.sh" 2>&1 | grep -q "Potion" && { echo "✓ inventory.sh работает"; score=$((score+1)); }
[ -f "$DIR/batch.sh" ] && bash "$DIR/batch.sh" 3 2>&1 | grep -q "potion #3" && { echo "✓ batch.sh работает"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Циклы освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Создай brew.sh, inventory.sh, batch.sh (баллов: $score/3)"
exit 1

HINTS
For loop: for var in list; do ... done — перебор слов
While read: while IFS=: read -r col1 col2; do ... done < file — построчно с разделителем
C-style for: for ((i=1; i<=N; i++)); do ... done — арифметический цикл
$@: for arg in "$@"; do ... done — перебор всех аргументов безопасно
$#: количество переданных аргументов
Default value: ${1:-5} — если $1 не задан, использовать 5
IFS=: разделитель полей для read (по умолчанию пробел/таб/новая строка)
-r flag: read -r — не экранировать обратные слеши
