META
# Track: scripting
# Title: Дескрипторы Силы
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/данные"
for i in $(seq 1 10); do
  echo "запись_$i данные=$RANDOM" >> "$DIR/данные/поток_$((i % 3)).log"
done

TASK
📜 **Дескрипторы Силы**

В глубинах Башни текут потоки магической энергии — файловые дескрипторы. Мастер может открыть канал, направить поток и закрыть его. А ещё — запускать процессы параллельно.

📖 **Файловые дескрипторы и exec**:
• `exec 3<> file` — открыть файл на дескриптор 3 (чтение+запись)
• `echo "text" >&3` — записать в дескриптор 3
• `read -u 3 line` — прочитать из дескриптора 3
• `exec 3>&-` — закрыть дескриптор 3
• Стандартные: 0=stdin, 1=stdout, 2=stderr

📖 **Сопрограммы coproc**:
• `coproc NAME { command; }` — запустить команду с двусторонним каналом
• `${NAME[0]}` — чтение, `${NAME[1]}` — запись
• Позволяет взаимодействовать с фоновым процессом

📖 **Параллелизм в bash**:
• `команда &` — запустить в фоне
• `wait` — дождаться всех фоновых процессов
• `wait $pid` — дождаться конкретного процесса
• `$!` — PID последнего фонового процесса

📖 **shopt — расширения bash**:
• `shopt -s globstar` — рекурсивный `**/*.sh`
• `shopt -s extglob` — расширенные паттерны: `@(a|b)`, `!(a)`
• `shopt -s nullglob` — пустое совпадение не оставляет слово

📂 Рабочий каталог: `~/.ninja_trainer/scripting_013`

📋 **Попробуй**:
1. Создай скрипт `fd_demo.sh`: открой файл через `exec 3>`, запиши строку, закрой
2. Создай скрипт `parallel.sh`: запусти 3 команды в фоне через `&`, дождись через `wait`
3. Попробуй `shopt -s globstar` и найди все `.log` файлы рекурсивно

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/scripting_013"
score=0

if [ -f "$DIR/fd_demo.sh" ]; then
  echo "✓ fd_demo.sh создан"
  score=$((score+1))
  grep -q 'exec' "$DIR/fd_demo.sh" && { echo "✓ exec используется"; score=$((score+1)); }
fi

if [ -f "$DIR/parallel.sh" ]; then
  echo "✓ parallel.sh создан"
  score=$((score+1))
  grep -q '&' "$DIR/parallel.sh" && { echo "✓ Фоновый запуск (&)"; score=$((score+1)); }
  grep -q 'wait' "$DIR/parallel.sh" && { echo "✓ wait используется"; score=$((score+1)); }
fi

[ $score -ge 4 ] && { echo "✓ ok: Дескрипторы Силы освоены! (баллов: $score/5)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/5)"
exit 1

HINTS
Открыть дескриптор: exec 3> ~/.ninja_trainer/scripting_013/вывод.txt
Записать: echo "Магический текст" >&3
Закрыть: exec 3>&-
Фоновый процесс: sleep 1 && echo "done" &
Дождаться: wait — ждёт все фоновые процессы
PID последнего: bg_pid=$!; wait $bg_pid
Globstar: shopt -s globstar; ls ~/.ninja_trainer/scripting_013/**/*.log
