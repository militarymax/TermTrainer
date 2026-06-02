META
# Title: Магический Конвейер Данных
# Number: 015
# Level: 3
# Type: boss
# Difficulty: hard
# TimeLimitMin: 20

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/pipeline/{raw,processed,output}
cat > /tmp/termtrainer_lab/pipeline/raw/employees.csv << 'CSV'
id,name,department,salary,city
1,Алиса,Engineering,150000,Москва
2,Борис,Marketing,120000,СПб
3,Виктор,Engineering,180000,Москва
4,Галина,HR,90000,Казань
5,Дмитрий,Engineering,160000,Москва
6,Елена,Marketing,110000,СПб
7,Женя,HR,95000,Казань
8,Зина,Engineering,170000,Москва
9,Игорь,Marketing,130000,СПб
10,Катя,HR,100000,Казань
CSV

cat > /tmp/termtrainer_lab/pipeline/raw/sales.csv << 'CSV'
product,amount,city,date
WidgetA,5000,Москва,2024-01-15
WidgetB,3000,СПб,2024-01-15
WidgetC,7000,Казань,2024-01-16
WidgetA,4500,Москва,2024-01-16
WidgetB,3200,СПб,2024-01-17
WidgetC,6500,Казань,2024-01-17
WidgetA,5500,Москва,2024-01-18
CSV

TASK
🐉 ЭКЗАМЕН #015: Магический Конвейер Данных

Архиканцлер вызвал тебя лично (видимо, Декан доложил о твоих
успехах в поиске и анализе данных):
«Ринсвинд! Казначей утверждает, что бюджет Университета
утекает сквозь порталы. Я хочу полный финансовый отчёт.
Инженеры, продажи, сводка — всё! Если не справишься —
будешь лично считать монеты в казне. Вечность.»

Тебе даны два свитка с данными:
  raw/employees.csv — сотрудники Университета
  raw/sales.csv     — продажи магических артефактов

ASSIGNMENT
🎯 ЗАДАНИЕ:
1. Создай processed/engineering.csv — сотрудники Engineering отдела
2. Создай processed/moscow_sales.csv — продажи в Москве
3. Посчитай среднюю зарплату в Engineering → output/avg_salary.txt
4. Посчитай сумму продаж по городам → output/sales_by_city.txt
5. Создай итоговый отчёт output/summary.txt:
   - Строка "Инженеров: N" (количество инженеров)
   - Строка "Средняя ЗП: XXXXX"
   - Строка "Продажи Москва: XXXXX"

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/pipeline/processed/engineering.csv ]; then
    echo "✗ engineering.csv не создан"
    errors=$((errors+1))
else
    eng_count=$(tail -n +2 /tmp/termtrainer_lab/pipeline/processed/engineering.csv | wc -l | tr -d ' ')
    if [ "$eng_count" = "4" ]; then
        echo "✓ Инженеры отфильтрованы!"
    else
        echo "✗ Неверное количество инженеров (ожидается 4)"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/termtrainer_lab/pipeline/output/avg_salary.txt ]; then
    echo "✗ avg_salary.txt не создан"
    errors=$((errors+1))
else
    echo "✓ Средняя зарплата посчитана!"
fi

if [ ! -f /tmp/termtrainer_lab/pipeline/output/summary.txt ]; then
    echo "✗ summary.txt не создан"
    errors=$((errors+1))
else
    if grep -q "Инженеров:" /tmp/termtrainer_lab/pipeline/output/summary.txt && \
       grep -q "Средняя ЗП:" /tmp/termtrainer_lab/pipeline/output/summary.txt && \
       grep -q "Продажи Москва:" /tmp/termtrainer_lab/pipeline/output/summary.txt; then
        echo "✓ Итоговый отчёт корректен!"
    else
        echo "✗ summary.txt не содержит нужных строк"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ 🐉 Экзамен сдан! Архиканцлер доволен. Казначей плачет."
fi

exit $errors

HINTS
Фильтрация: grep "Engineering" raw/employees.csv > processed/engineering.csv
Средняя ЗП: используй awk для суммирования зарплат и деления на количество
Продажи Москвы: grep "Москва" raw/sales.csv | awk -F',' '{sum+=$2} END{print sum}'
