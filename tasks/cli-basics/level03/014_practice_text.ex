META
# Title: Аналитик магических потоков
# Number: 014
# Level: 3
# Type: practice
# Difficulty: medium
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/ninja_training/datalab
cat > /tmp/ninja_training/datalab/access.log << 'LOG'
192.168.1.10 GET /index.html 200 1234
192.168.1.20 POST /login 401 56
192.168.1.10 GET /dashboard 200 5678
192.168.1.30 GET /api/users 200 890
192.168.1.20 POST /login 200 234
192.168.1.40 GET /admin 403 78
192.168.1.10 POST /api/data 500 12
192.168.1.30 GET /api/users 200 890
192.168.1.50 GET /index.html 200 1234
192.168.1.20 GET /dashboard 200 5678
LOG

TASK
⚗️ ЛАБОРАТОРНАЯ #014: Аналитик магических потоков

Декан поручил тебе проанализировать журнал магического портала.
Каждый запрос — это кто-то прошёл через портал.

Формат: IP МЕТОД ПУТЬ КОД РАЗМЕР

Коды ответов:
  200 = OK (портал работал)
  401 = Не авторизован (кто-то забыл пароль от портала)
  403 = Запрещено (студент пытался пройти в кабинет Декана)
  500 = Магическая авария (портал взорвался)

🎯 ЗАДАНИЕ:
1. Посчитай общее количество запросов
2. Найди все запросы с кодом ошибки (4xx или 5xx)
3. Определи самый популярный путь через портал
4. Создай отчёт:
   - /tmp/ninja_training/report_total.txt — число запросов
   - /tmp/ninja_training/report_errors.txt — строки с ошибками
   - /tmp/ninja_training/report_popular.txt — самый популярный путь

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/ninja_training/report_total.txt ]; then
    echo "✗ report_total.txt не создан"
    errors=$((errors+1))
else
    total=$(cat /tmp/ninja_training/report_total.txt | tr -d '[:space:]')
    if [ "$total" = "10" ]; then
        echo "✓ Общее количество запросов верно!"
    else
        echo "✗ Неверное количество запросов (ожидается 10)"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/ninja_training/report_errors.txt ]; then
    echo "✗ report_errors.txt не создан"
    errors=$((errors+1))
else
    err_count=$(wc -l < /tmp/ninja_training/report_errors.txt | tr -d '[:space:]')
    if [ "$err_count" = "3" ]; then
        echo "✓ Ошибки найдены верно!"
    else
        echo "✗ Неверное количество ошибок (ожидается 3)"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/ninja_training/report_popular.txt ]; then
    echo "✗ report_popular.txt не создан"
    errors=$((errors+1))
else
    if grep -q "/api/users\|/index.html\|/dashboard" /tmp/ninja_training/report_popular.txt; then
        echo "✓ Популярный путь определён!"
    else
        echo "✗ Популярный путь не определён"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ Декан изучает отчёт: 'Хм. Кто-то ломился в мой кабинет?'"
fi

exit $errors

HINTS
Общее количество: cat access.log | wc -l > report_total.txt
Ошибки: grep -E " [45][0-9]{2} " access.log > report_errors.txt
Популярный путь: awk '{print $3}' access.log | sort | uniq -c | sort -rn | head -1
