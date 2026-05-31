META
# Track: scripting
# Title: Параллельные ритуалы
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/исходники" "$DIR/результаты"
for i in $(seq 1 8); do
  echo "Зелье_$i: ингредиенты=$RANDOM, температура=$RANDOM, статус=готово" > "$DIR/исходники/зелье_${i}.txt"
done

TASK
⚡ **Параллельные ритуалы**

В Университете много зелий — варить их по одному слишком медленно! Нужно запустить несколько процессов параллельно, но с ограничением: не более N одновременно. Именованные каналы (mkfifo) помогут синхронизировать ритуалы.

📋 **Задания**:
1. Создай скрипт `simple_parallel.sh`:
   - Обрабатывает все файлы в `исходники/` через `for` + `&`
   - Каждый фоновый процесс: читает файл, добавляет пометку `[processed]`, сохраняет в `результаты/`
   - Используй `wait` для ожидания завершения всех процессов
   - Замерь время через `time` (оберни весь скрипт)

2. Создай скрипт `limited_parallel.sh` с ограничением параллелизма:
   - Создай именованный канал через `mkfifo`
   - Открой его через `exec 3<>`
   - Запиши N токенов (по числу max_jobs) в канал
   - Для каждого файла: прочитай токен (`read -u 3`), обработай, верни токен (`echo >&3`)
   - Дождись завершения через `wait`
   - Закрой дескриптор и удали канал

3. Создай скрипт `mapfile_demo.sh`:
   - Прочитай файл целиком через `mapfile` / `readarray`
   - Выведи количество строк и первые 3 элемента массива

💡 **Профилирование**:
• `{ time ./script.sh; } 2> timing.log` — сохранить время выполнения
• Минимизируй вызовы внешних команд — используй встроенные bash

📂 Рабочий каталог: `~/.ninja_trainer/scripting_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_014"
score=0

if [ -f "$DIR/simple_parallel.sh" ]; then
  echo "✓ simple_parallel.sh создан"
  score=$((score+1))
  grep -q '&' "$DIR/simple_parallel.sh" && { echo "✓ Фоновый запуск"; score=$((score+1)); }
  grep -q 'wait' "$DIR/simple_parallel.sh" && { echo "✓ wait используется"; score=$((score+1)); }
fi

if [ -f "$DIR/limited_parallel.sh" ]; then
  echo "✓ limited_parallel.sh создан"
  score=$((score+1))
  grep -q 'mkfifo' "$DIR/limited_parallel.sh" && { echo "✓ mkfifo используется"; score=$((score+1)); }
fi

if [ -f "$DIR/mapfile_demo.sh" ]; then
  echo "✓ mapfile_demo.sh создан"
  score=$((score+1))
fi

[ $score -ge 5 ] && { echo "✓ ok: Параллельные ритуалы освоены! (баллов: $score/6)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/6)"
exit 1

HINTS
Простой параллелизм: for f in исходники/*; do process "$f" & done; wait
Ограниченный параллелизм через mkfifo:
  mkfifo pipe; exec 3<>pipe
  for ((i=0;i<4;i++)); do echo >&3; done  # 4 токена
  for f in *; do read -u 3; { process "$f"; echo >&3; } & done
  wait; exec 3>&-; rm pipe
mapfile: mapfile lines < файл.txt; echo "${#lines[@]} строк"
readarray: readarray -t arr < файл.txt
time: { time bash script.sh; } 2> timing.log
