META
# Title: Хранитель сейфов Университета
# Number: 008
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/vault/{public,internal,confidential,portal}
echo "Расписание лекций для всех" > /tmp/termtrainer_lab/vault/public/announcement.txt
echo "Список преподавателей (конфиденциально)" > /tmp/termtrainer_lab/vault/internal/memo.txt
echo "Пароль от кабинета Архиканцлера: 'сосиска'" > /tmp/termtrainer_lab/vault/confidential/passwords.txt
echo "# Неисполняемый скрипт" > /tmp/termtrainer_lab/vault/portal/deploy.sh
echo "Original data" > /tmp/termtrainer_lab/vault/portal/data.txt

TASK
⚗️ ЛАБОРАТОРНАЯ #008: Хранитель сейфов Университета

Библиотекарь довольно ухнул, увидев, что ты освоил теорию
ключей и замков. «Уук!» (Перевод: «Теперь докажи, что ты
не просто читал свиток, а умеешь ПРИМЕНЯТЬ магию прав
на практике!»)

Вот тебе хранилище с четырьмя сейфами. У каждого —
свой уровень секретности. Настрой права правильно.

Структура хранилища:
  vault/
  ├── public/announcement.txt      ← публичное: все читают (644)
  ├── internal/memo.txt            ← внутреннее: владелец rw, группа r (640)
  ├── confidential/passwords.txt   ← ТАЙНА: только владелец (600)
  └── portal/
      ├── deploy.sh                ← должен стать исполняемым (+x)
      └── data.txt                 ← создай портал на него в /tmp/termtrainer_lab/data_portal

ASSIGNMENT
🎯 ЗАДАНИЕ:

📂 Перейди в рабочий каталог: cd /tmp/termtrainer_lab/vault/{public,internal,confidential,portal}
1. Установи права public/announcement.txt → 644 (все читают, владелец пишет)
2. Установи права internal/memo.txt → 640 (владелец rw, группа r)
3. Закрой confidential/passwords.txt → 600 (только владелец!)
4. Сделай portal/deploy.sh исполняемым (chmod +x)
5. Создай символическую ссылку /tmp/termtrainer_lab/data_portal → vault/portal/data.txt
6. Запиши отчёт о правах: ls -la vault/ > /tmp/termtrainer_lab/security_report.txt

Нажми [V] — Библиотекарь проверит каждый замок.

VALIDATION
#!/bin/bash
errors=0

pub_perm=$(stat -f "%Lp" /tmp/termtrainer_lab/vault/public/announcement.txt 2>/dev/null || stat -c "%a" /tmp/termtrainer_lab/vault/public/announcement.txt)
if [ "$pub_perm" = "644" ]; then
    echo "✓ public: права 644 — все читают расписание!"
else
    echo "✗ public: ожидалось 644, получено $pub_perm"
    errors=$((errors+1))
fi

int_perm=$(stat -f "%Lp" /tmp/termtrainer_lab/vault/internal/memo.txt 2>/dev/null || stat -c "%a" /tmp/termtrainer_lab/vault/internal/memo.txt)
if [ "$int_perm" = "640" ]; then
    echo "✓ internal: права 640 — список преподавателей под защитой!"
else
    echo "✗ internal: ожидалось 640, получено $int_perm"
    errors=$((errors+1))
fi

conf_perm=$(stat -f "%Lp" /tmp/termtrainer_lab/vault/confidential/passwords.txt 2>/dev/null || stat -c "%a" /tmp/termtrainer_lab/vault/confidential/passwords.txt)
if [ "$conf_perm" = "600" ]; then
    echo "✓ confidential: права 600 — пароль Архиканцлера в безопасности!"
else
    echo "✗ confidential: ожидалось 600, получено $conf_perm"
    errors=$((errors+1))
fi

if [ -x /tmp/termtrainer_lab/vault/portal/deploy.sh ]; then
    echo "✓ portal/deploy.sh — исполняемый! Заклинание готово к запуску!"
else
    echo "✗ portal/deploy.sh не исполняемый (используй chmod +x)"
    errors=$((errors+1))
fi

if [ -L /tmp/termtrainer_lab/data_portal ]; then
    target=$(readlink /tmp/termtrainer_lab/data_portal)
    if echo "$target" | grep -q "data.txt"; then
        echo "✓ Портал открыт! data_portal → data.txt"
    else
        echo "✗ data_portal указывает не на data.txt"
        errors=$((errors+1))
    fi
else
    echo "✗ Символическая ссылка data_portal не создана"
    errors=$((errors+1))
fi

if [ -f /tmp/termtrainer_lab/security_report.txt ]; then
    echo "✓ Отчёт о безопасности создан!"
else
    echo "✗ security_report.txt не создан"
    errors=$((errors+1))
fi

if [ $errors -eq 0 ]; then
    echo "✓ Все сейфы надёжно заперты! Библиотекарь одобрительно ухает!"
fi

exit $errors

HINTS
chmod 644 vault/public/announcement.txt
chmod 640 vault/internal/memo.txt
chmod 600 vault/confidential/passwords.txt
chmod +x vault/portal/deploy.sh
ln -s /tmp/termtrainer_lab/vault/portal/data.txt /tmp/termtrainer_lab/data_portal
ls -la vault/ > /tmp/termtrainer_lab/security_report.txt