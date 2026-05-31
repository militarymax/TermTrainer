META
# Title: Вызов Архиканцлера
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 30

SETUP
#!/bin/bash
mkdir -p /tmp/ninja_training/incident/{var/log,var/data,var/run,etc,home/admin,backup}

# Магический журнал инцидента
cat > /tmp/ninja_training/incident/var/log/application.log << 'LOG'
2024-01-15 06:00:00 INFO Магическая система v2.3.1 запущена
2024-01-15 06:05:00 INFO Подключение к Источнику Магии prod-db-01
2024-01-15 07:00:00 WARN Время отклика увеличено до 2500мс
2024-01-15 07:30:00 ERROR Нехватка памяти: выделение октарина провалено
2024-01-15 07:31:00 ERROR Магическая система разрушена
2024-01-15 07:35:00 INFO Система перезапущена (аварийный режим)
2024-01-15 08:00:00 ERROR Источник магии исчерпан
2024-01-15 08:05:00 ERROR Таймаут запроса к Источнику (30с)
2024-01-15 08:10:00 WARN Попытка переподключения 1/3
2024-01-15 08:11:00 INFO Подключение к Источнику восстановлено
2024-01-15 09:00:00 ERROR Ошибка ввода-вывода на /dev/sdb1
2024-01-15 09:30:00 ERROR Файл не найден: /var/data/critical.dat
2024-01-15 10:00:00 INFO Окно планового обслуживания
2024-01-15 10:30:00 ERROR Доступ запрещён: /etc/shadow
2024-01-15 11:00:00 INFO Проверка магического поля инициирована
2024-01-15 11:05:00 CRITICAL Все магические сервисы недоступны
LOG

# Данные клиентов магического банка
echo "customer_id,name,balance,status" > /tmp/ninja_training/incident/var/data/customers.csv
echo "1001,Alpha Corp,50000,active" >> /tmp/ninja_training/incident/var/data/customers.csv
echo "1002,Beta Inc,30000,suspended" >> /tmp/ninja_training/incident/var/data/customers.csv
echo "1003,Gamma LLC,75000,active" >> /tmp/ninja_training/incident/var/data/customers.csv
echo "1004,Delta SA,12000,inactive" >> /tmp/ninja_training/incident/var/data/customers.csv
echo "1005,Epsilon AG,45000,active" >> /tmp/ninja_training/incident/var/data/customers.csv

# Конфиг с неправильными правами
echo "DB_HOST=prod-db-01" > /tmp/ninja_training/incident/etc/database.conf
echo "DB_PORT=5432" >> /tmp/ninja_training/incident/etc/database.conf
echo "DB_USER=admin" >> /tmp/ninja_training/incident/etc/database.conf
echo "DB_PASS=supersecret123" >> /tmp/ninja_training/incident/etc/database.conf
chmod 666 /tmp/ninja_training/incident/etc/database.conf

# Два демона, пожирающих ресурсы
(for i in $(seq 1 1000); do echo "memory leak $i" >> /dev/null; sleep 1; done) &
echo $! > /tmp/ninja_training/incident/var/run/memory_hog.pid
(for i in $(seq 1 1000); do echo "cpu waste $i" >> /dev/null; sleep 0.5; done) &
echo $! > /tmp/ninja_training/incident/var/run/cpu_waster.pid

# Бэкап критических данных
echo "backup_data_critical" > /tmp/ninja_training/incident/backup/critical.dat.bak

TASK
👑 УБЕР-БОСС #016: Вызов Архиканцлера

Прошла неделя после твоего триумфа над Конвейером Данных.
Ты уже начал привыкать к спокойной жизни... как вдруг —

🚨 КАТАСТРОФА В НЕЗРИМОМ УНИВЕРСИТЕТЕ! 🚨

Архиканцлер Mustrum Ridcully ворвался в твою комнату:
«ЭТО ФИНАЛЬНАЯ ПРОВЕРКА! Магический реактор на грани
взрыва, демоны пожирают память, а конфиг базы данных
доступен всем, включая младших духов кухни! Если ты
справишься — получишь звание Мастера Терминала Незримого
Университета! Если нет... ну, Ринсвинд уже в бегах,
составишь ему компанию.»

Ринсвинд действительно сбежал (снова). Библиотекарь
забаррикадировался в библиотеке. Только ты можешь
спасти Университет.

═══════════════════════════════════

📋 ЗАДАЧА 1: РАССЛЕДОВАНИЕ МАГИЧЕСКОГО ЖУРНАЛА
Найди в var/log/application.log:
- Сколько всего ошибок (ERROR)?
- Какая самая частая ошибка?
Запиши в etc/incident_report.txt:
  Строка "total_errors: N"
  Строка "top_error: НАЗВАНИЕ_ОШИБКИ"

📋 ЗАДАЧА 2: СПАСЕНИЕ МАГИЧЕСКОГО БАНКА
- Найди активных клиентов в customers.csv
- Посчитай их общий баланс
- Создай бэкап данных: backup/customers_backup.tar.gz
Запиши в etc/data_rescue.txt:
  Строка "active_customers: N"
  Строка "total_balance: XXXXX"

📋 ЗАДАЧА 3: ИЗГНАНИЕ ДЕМОНОВ
- Заверши оба процесса из var/run/*.pid
Запиши в etc/process_cleanup.txt:
  Строка "memory_hog: terminated"
  Строка "cpu_waster: terminated"

📋 ЗАДАЧА 4: БЕЗОПАСНОСТЬ
- Заблокируй доступ к etc/database.conf (права 600)
Запиши в etc/security_fix.txt:
  Строка "database_conf: secured"

📋 ЗАДАЧА 5: ФИНАЛЬНЫЙ ОТЧЁТ АРХИКАНЦЛЕРУ
Собери все отчёты в один файл etc/final_report.txt:
  "=== INCIDENT RESPONSE REPORT ==="
  + содержимое всех 4 отчётов выше
  + строка "status: RESOLVED"

VALIDATION
#!/bin/bash
errors=0

# Task 1: Logs
if [ -f /tmp/ninja_training/incident/etc/incident_report.txt ]; then
    if grep -q "total_errors:" /tmp/ninja_training/incident/etc/incident_report.txt && \
       grep -q "top_error:" /tmp/ninja_training/incident/etc/incident_report.txt; then
        echo "✓ Задача 1: Магический журнал расследован!"
    else
        echo "✗ Задача 1: Отчёт неполный"
        errors=$((errors+1))
    fi
else
    echo "✗ Задача 1: incident_report.txt не создан"
    errors=$((errors+1))
fi

# Task 2: Data rescue
if [ -f /tmp/ninja_training/incident/etc/data_rescue.txt ]; then
    if grep -q "active_customers:" /tmp/ninja_training/incident/etc/data_rescue.txt && \
       grep -q "total_balance:" /tmp/ninja_training/incident/etc/data_rescue.txt; then
        echo "✓ Задача 2: Магический банк спасён!"
    else
        echo "✗ Задача 2: Отчёт неполный"
        errors=$((errors+1))
    fi
else
    echo "✗ Задача 2: data_rescue.txt не создан"
    errors=$((errors+1))
fi

# Task 3: Processes
if [ -f /tmp/ninja_training/incident/etc/process_cleanup.txt ]; then
    if grep -q "memory_hog.*terminated" /tmp/ninja_training/incident/etc/process_cleanup.txt && \
       grep -q "cpu_waster.*terminated" /tmp/ninja_training/incident/etc/process_cleanup.txt; then
        echo "✓ Задача 3: Демоны изгнаны!"
    else
        echo "✗ Задача 3: Отчёт неполный"
        errors=$((errors+1))
    fi
else
    echo "✗ Задача 3: process_cleanup.txt не создан"
    errors=$((errors+1))
fi

# Task 4: Security
db_perm=$(stat -f "%Lp" /tmp/ninja_training/incident/etc/database.conf 2>/dev/null || stat -c "%a" /tmp/ninja_training/incident/etc/database.conf)
if [ "$db_perm" = "600" ]; then
    echo "✓ Задача 4: Конфиг защищён магией!"
else
    echo "✗ Задача 4: Права database.conf не 600 (сейчас: $db_perm)"
    errors=$((errors+1))
fi

# Task 5: Final report
if [ -f /tmp/ninja_training/incident/etc/final_report.txt ]; then
    if grep -q "INCIDENT RESPONSE REPORT" /tmp/ninja_training/incident/etc/final_report.txt && \
       grep -q "RESOLVED" /tmp/ninja_training/incident/etc/final_report.txt; then
        echo "✓ Задача 5: Финальный отчёт готов для Архиканцлера!"
    else
        echo "✗ Задача 5: Финальный отчёт неполный"
        errors=$((errors+1))
    fi
else
    echo "✗ Задача 5: final_report.txt не создан"
    errors=$((errors+1))
fi

if [ $errors -eq 0 ]; then
    echo "✓ 👑 УБЕР-БОСС ПОВЕРЖЕН! Архиканцлер доволен!"
    echo "  Ты — Мастер Терминала Незримого Университета!"
fi

exit $errors

HINTS
Логи: grep "ERROR" application.log | wc -l и grep "ERROR" application.log | awk '{print $4}' | sort | uniq -c | sort -rn
Клиенты: grep "active" customers.csv; баланс: awk -F',' '/active/{sum+=$3} END{print sum}'
Процессы: kill $(cat var/run/memory_hog.pid) и kill $(cat var/run/cpu_waster.pid)
Безопасность: chmod 600 etc/database.conf
Финальный отчёт: cat etc/incident_report.txt etc/data_rescue.txt etc/process_cleanup.txt etc/security_fix.txt > etc/final_report.txt
