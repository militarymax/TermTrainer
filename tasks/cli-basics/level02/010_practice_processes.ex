META
# Title: Истребитель Сущностей
# Number: 010
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15

SETUP
#!/bin/bash
mkdir -p /tmp/ninja_training/taskmgr
# Призываем несколько демонов для тренировки
(while true; do echo "worker1"; sleep 10; done) &
echo $! > /tmp/ninja_training/taskmgr/worker1.pid
(while true; do echo "worker2"; sleep 10; done) &
echo $! > /tmp/ninja_training/taskmgr/worker2.pid
(while true; do echo "zombie"; sleep 10; done) &
echo $! > /tmp/ninja_training/taskmgr/zombie.pid

TASK
🎯 ПРАКТИКА #010: Истребитель Сущностей

Библиотекарь ворвался в комнату, размахивая бананом:
«Уук! УУУК!» (Перевод: «Ринсвинд опять напортачил
с заклинанием, и теперь по университету бродят
три демонические сущности! Одна из них пыталась
украсть мой банан! Иди и разберись!»)

Ну что ж. Ты уже знаешь, что такое процессы.
Пора применить это на практике.

Ты — единственный, кто умеет пользоваться kill.
Ну, кроме Смерти, но он занят.

ЗАДАНИЕ:
1. Прочитай PID процессов из taskmgr/*.pid
2. Останови worker1 и worker2 сигналом SIGTERM (вежливо)
3. Принудительно заверши zombie сигналом SIGKILL (без вариантов)
4. Создай отчёт /tmp/ninja_training/process_report.txt:
   - Строка "worker1: stopped"
   - Строка "worker2: stopped"
   - Строка "zombie: killed"

VALIDATION
#!/bin/bash
errors=0

w1=$(cat /tmp/ninja_training/taskmgr/worker1.pid 2>/dev/null | tr -d '[:space:]')
w2=$(cat /tmp/ninja_training/taskmgr/worker2.pid 2>/dev/null | tr -d '[:space:]')
zz=$(cat /tmp/ninja_training/taskmgr/zombie.pid 2>/dev/null | tr -d '[:space:]')

all_stopped=true
for pid in "$w1" "$w2" "$zz"; do
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        all_stopped=false
    fi
done

if $all_stopped; then
    echo "✓ Все демоны изгнаны! Университет спасён!"
else
    echo "✗ Не все процессы остановлены"
    errors=$((errors+1))
fi

if [ -f /tmp/ninja_training/process_report.txt ]; then
    if grep -q "worker1.*stopped" /tmp/ninja_training/process_report.txt && \
       grep -q "worker2.*stopped" /tmp/ninja_training/process_report.txt && \
       grep -q "zombie.*killed" /tmp/ninja_training/process_report.txt; then
        echo "✓ Отчёт о зачистке корректен!"
    else
        echo "✗ Отчёт не содержит нужных строк"
        errors=$((errors+1))
    fi
else
    echo "✗ process_report.txt не создан"
    errors=$((errors+1))
fi

if [ $errors -eq 0 ]; then
    echo "✓ Университет очищен от демонов! Библиотекарь счастлив!"
    echo "  'Уук!' (Теперь ты готов к поиску и данным. Иди к Декану.)"
fi

exit $errors

HINTS
PID процессов: cat taskmgr/worker1.pid
Мягкая остановка: kill $(cat worker1.pid)
Принудительная: kill -9 $(cat zombie.pid)
Отчёт: echo "worker1: stopped" >> process_report.txt
