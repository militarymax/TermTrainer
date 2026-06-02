META
# Track: scripting
# Title: Параллельные ритуалы
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/logs"
for i in $(seq 1 8); do
  echo "Log entry $i: power=$((RANDOM%100)) status=$([ $((RANDOM%5)) -eq 0 ] && echo FAIL || echo OK)" > "$DIR/logs/spell_$i.log"
done

TASK
⚗️ ПРАКТИКУМ #014: Параллельные ритуалы

Архиканцлер вызвал тебя в лабораторию:
«Ринсвинд! У нас ВОСЕМЬ свитков с логами, и каждый нужно обработать.
Если ты будешь делать это последовательно — к утру не управишься.
Нужен ПАРАЛЛЕЛЬНЫЙ обработчик! Но не больше 4 одновременно —
иначе магические потоки перегрузятся и Башня снова взорвётся.
Да, я помню прошлый раз. И предпоследний.»

📋 **Задания**:

ASSIGNMENT
1. **Напиши `parallel_process.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   MAX_JOBS="${1:-4}"
   DIR="logs"
   
   process_log() {
       local file="$1"
       local name=$(basename "$file")
       local fails=0
       while IFS= read -r line; do
           [[ "$line" == *"FAIL"* ]] && ((fails++))
       done < "$file"
       echo "$name: $fails failure(s)"
   }
   
   # Простой параллелизм с ограничением
   running=0
   for logfile in "$DIR"/*.log; do
       process_log "$logfile" &
       ((running++))
       if [[ $running -ge $MAX_JOBS ]]; then
           wait -n 2>/dev/null || wait  # Дождаться любой задачи
           ((running--))
       fi
   done
   wait  # Дождаться всех
   echo "All logs processed!"
   ```

2. **Напиши `fd_parallel.sh`** — параллелизм через файловые дескрипторы:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   MAX_JOBS=4
   PIPE="$HOME/.termtrainer/scripting_014/pipe_$$"
   
   mkfifo "$PIPE"
   exec 3<>"$PIPE"
   rm "$PIPE"          # Файл удалён, но дескриптор открыт!
   
   for ((i=0; i<MAX_JOBS; i++)); do echo >&3; done   # Начальные токены
   
   for logfile in logs/*.log; do
       read -u 3        # Взять токен (ждёт если нет свободных!)
       {
           name=$(basename "$logfile")
           fails=$(grep -c "FAIL" "$logfile" 2>/dev/null || echo 0)
           echo "$name: $fails failure(s)"
           echo >&3     # Вернуть токен
       } &
   done
   wait
   exec 3>&-
   echo "All logs processed with FD pool!"
   ```

3. **Запусти оба** и сравни результаты

📂 Рабочий каталог: `~/.termtrainer/scripting_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/scripting_014"
score=0

if [ -f "$DIR/parallel_process.sh" ]; then
  chmod +x "$DIR/parallel_process.sh"
  out=$(bash "$DIR/parallel_process.sh" 2>&1)
  echo "$out" | grep -q "spell_\|processed\|failure" && { echo "✓ parallel_process.sh работает"; score=$((score+1)); }
fi

if [ -f "$DIR/fd_parallel.sh" ]; then
  chmod +x "$DIR/fd_parallel.sh"
  out=$(bash "$DIR/fd_parallel.sh" 2>&1)
  echo "$out" | grep -q "spell_\|processed\|failure\|FD pool" && { echo "✓ fd_parallel.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Параллелизм освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Напиши parallel_process.sh или fd_parallel.sh (баллов: $score/2)"
exit 1

HINTS
cmd &: запустить в фоне
wait: дождаться всех фоновых задач
wait -n: дождаться ЛЮБОЙ одной задачи (bash 4.3+)
Счётчик running: увеличивать при запуске, уменьшать при завершении
mkfifo + exec 3<>: создать именованный канал для пула задач
read -u 3: взять токен из канала (блокирует если пусто!)
echo >&3: вернуть токен в канал после завершения задачи
$!: PID последней фоновой команды
