META
# Title: Расследование в Анк-Морпорке
# Number: 013
# Level: 3
# Type: practice
# Difficulty: medium
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/crimescene/{evidence,witnesses,suspects}
echo "Отпечатки пальцев на окне" > /tmp/termtrainer_lab/crimescene/evidence/fingerprints.txt
echo "Кровь типа A+" > /tmp/termtrainer_lab/crimescene/evidence/blood.txt
echo "Волосы рыжего цвета" > /tmp/termtrainer_lab/crimescene/evidence/hair.txt
echo "Я видел человека в чёрном около 22:00" > /tmp/termtrainer_lab/crimescene/witnesses/witness1.txt
echo "Слышала шум со стороны склада" > /tmp/termtrainer_lab/crimescene/witnesses/witness2.txt
echo "Иванов Сергей 35 лет рыжий кровь A+" > /tmp/termtrainer_lab/crimescene/suspects/suspect1.txt
echo "Петров Алексей 28 лет брюнет кровь B+" > /tmp/termtrainer_lab/crimescene/suspects/suspect2.txt
echo "Сидоров Дмитрий 42 лет шатен кровь O+" > /tmp/termtrainer_lab/crimescene/suspects/suspect3.txt

TASK
⚗️ ЛАБОРАТОРНАЯ #013: Расследование в Анк-Морпорке

Стиббонс только что научил тебя обрабатывать данные.
Теперь — реальное дело!

Командор Ваймс из Городской Стражи вызвал тебя:
«Ринсвинд! Кто-то украл пудинг Декана из Незримого
Университета! Это преступление века! Ну, этого часа.
Ладно, сегодняшнего преступления.»

На месте преступления собраны улики. Найди виновного!

Структура дела:
  crimescene/
  ├── evidence/      ← улики
  ├── witnesses/     ← показания свидетелей
  └── suspects/      ← подозреваемые

ASSIGNMENT
🎯 ЗАДАНИЕ:

📂 Перейди в рабочий каталог: cd /tmp/termtrainer_lab/crimescene/{evidence,witnesses,suspects}
1. Прочитай все улики в evidence/
2. Прочитай показания свидетелей в witnesses/
3. Сопоставь улики с данными подозреваемых (grep!)
4. Создай файл /tmp/termtrainer_lab/guilty.txt с фамилией виновного

Подсказка: ищи совпадения по цвету волос и группе крови.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/guilty.txt ]; then
    echo "✗ guilty.txt не создан"
    errors=$((errors+1))
else
    content=$(cat /tmp/termtrainer_lab/guilty.txt)
    if echo "$content" | grep -qi "иванов"; then
        echo "✓ Преступник найден! Это Иванов!"
    else
        echo "✗ Неверный подозреваемый. Ищи того, кто подходит под улики."
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ Командор Ваймс: 'Неплохо для мага. Пудинг возвращён.'"
fi

exit $errors

HINTS
Улики: рыжие волосы и кровь A+. Проверь suspects/.
grep "рыж" /tmp/termtrainer_lab/crimescene/suspects/*.txt
grep "A+" /tmp/termtrainer_lab/crimescene/suspects/*.txt
