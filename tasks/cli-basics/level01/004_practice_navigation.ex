META
# Title: Заблудиться в подземельях
# Number: 004
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/maze/{corridor1,corridor2,corridor3/{room_a,room_b},dead_end}
echo "ключ" > /tmp/termtrainer_lab/maze/corridor2/key.txt
echo "карта" > /tmp/termtrainer_lab/maze/corridor3/room_b/map.txt
echo "выход" > /tmp/termtrainer_lab/maze/corridor3/room_a/exit.txt

TASK
⚗️ ЛАБОРАТОРНАЯ #004: Заблудиться в подземельях

Библиотекарь выглянул из-за стеллажа и многозначительно
произнёс: «Уук! Уук-уук!» (что в переводе означало:
«Свитки читать научился? Молодец. А теперь иди в подземелья
и докажи, что умеешь ориентироваться на практике.»)

Ринсвинд, ты опять заблудился. На этот раз — в подвалах
Незримого Университета. Стены двигаются. Пол проваливается.
Где-то впереди свет. Или это огонь? В любом случае — иди.

Библиотекарь оставил тебе подсказки в разных комнатах.
Найди их все.

План подземелий (по памяти Ринсвинда, то есть неточно):
  maze/
  ├── corridor1/
  ├── corridor2/
  │   └── key.txt      ← Ключ от двери! Найди и сохрани!
  ├── corridor3/
  │   ├── room_a/
  │   │   └── exit.txt  ← Выход! Но сначала найди остальное...
  │   └── room_b/
  │       └── map.txt   ← Карта подземелий!
  └── dead_end/
      (тупик. тут ничего. как и в жизни.)

ASSIGNMENT
🎯 ЗАДАНИЕ:

📂 Перейди в рабочий каталог: cd /tmp/termtrainer_lab/maze/{corridor1,corridor2,corridor3/{room_a,room_b},dead_end}
1. Перейди в /tmp/termtrainer_lab/maze
2. Найди key.txt и запиши его содержимое в /tmp/termtrainer_lab/result_key.txt
3. Найди map.txt и запиши его содержимое в /tmp/termtrainer_lab/result_map.txt
4. Найди exit.txt и запиши его содержимое в /tmp/termtrainer_lab/result_exit.txt

Подсказка: используй cat для чтения и > для записи.
И НЕ заблудись по дороге. Опять.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/result_key.txt ]; then
    echo "✗ result_key.txt не найден"
    errors=$((errors+1))
else
    content=$(cat /tmp/termtrainer_lab/result_key.txt)
    if [ "$content" = "ключ" ]; then
        echo "✓ Ключ найден! Дверь открыта!"
    else
        echo "✗ Содержимое result_key.txt неверное"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/termtrainer_lab/result_map.txt ]; then
    echo "✗ result_map.txt не найден"
    errors=$((errors+1))
else
    content=$(cat /tmp/termtrainer_lab/result_map.txt)
    if [ "$content" = "карта" ]; then
        echo "✓ Карта найдена! Теперь не заблудишься."
    else
        echo "✗ Содержимое result_map.txt неверное"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/termtrainer_lab/result_exit.txt ]; then
    echo "✗ result_exit.txt не найден"
    errors=$((errors+1))
else
    content=$(cat /tmp/termtrainer_lab/result_exit.txt)
    if [ "$content" = "выход" ]; then
        echo "✓ Выход найден! Свобода!"
    else
        echo "✗ Содержимое result_exit.txt неверное"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ Ты выбрался из подземелий! Библиотекарь говорит: «Уук!» (одобрительно)"
fi

exit $errors

HINTS
Перейди в maze: cd /tmp/termtrainer_lab/maze, затем ls для осмотра
Запись содержимого: cat corridor2/key.txt > /tmp/termtrainer_lab/result_key.txt
Вложенные комнаты: corridor3/room_b/map.txt
