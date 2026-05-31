META
# Title: Ключи и замки Незримого Университета
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15

SETUP
#!/bin/bash
mkdir -p /tmp/ninja_training/keystore/{public,private,shared,links}
echo "Расписание лекций (публичное)" > /tmp/ninja_training/keystore/public/schedule.txt
echo "Пароль от кабинета Архиканцлера: 'сосиска'" > /tmp/ninja_training/keystore/private/passwords.txt
echo "Общий котёл знаний" > /tmp/ninja_training/keystore/shared/team.txt
echo "#!/bin/bash\necho 'Магия активирована!'" > /tmp/ninja_training/keystore/public/cast.sh
chmod 644 /tmp/ninja_training/keystore/public/schedule.txt
chmod 600 /tmp/ninja_training/keystore/private/passwords.txt
chmod 664 /tmp/ninja_training/keystore/shared/team.txt

TASK
📜 СВИТОК ЗНАНИЙ #007: Ключи и замки Незримого Университета

Библиотекарь встретил тебя у массивной дубовой двери
с табличкой «ХРАНИЛИЩЕ ПРАВ ДОСТУПА».

«Уук, — сказал он, протягивая связку ключей. — Уук-уук.»
(Перевод: «Ринсвинд, Декан сказал, что ты уже умеешь
ориентироваться в архивах. Теперь научись ЗАКРЫВАТЬ
двери. А то любой первокурсник может прочитать пароль
Архиканцлера. А это, между прочим, „сосиска“.»)

───────────────────────────────────────
🔹 МАГИЧЕСКИЕ ПЕЧАТИ (chmod)
───────────────────────────────────────

В Незримом Университете у каждой двери — три замка:
один для владельца, один для группы, один для всех остальных.

Формат прав: rwx | rwx | rwx (владелец | группа | остальные)

   r = read (4)    — читать свиток / заглянуть в комнату
   w = write (2)   — писать в свиток / менять обстановку
   x = execute (1) — запустить заклинание / войти в комнату

⚡ chmod <число> <файл> — наложить магическую печать

   chmod 755 file  — rwxr-xr-x (владелец: всё, остальные: смотреть)
   chmod 644 file  — rw-r--r-- (владелец: писать, все: читать)
   chmod 600 file  — rw------- (ТОЛЬКО владелец! Личный дневник!)
   chmod 400 file  — r-------- (владелец только читает. Даже писать нельзя.)

   Как запомнить числа?
     4+2+1=7 (rwx), 4+0+1=5 (r-x), 4+0+0=4 (r--)
     Просто сложи: r=4, w=2, x=1. Для каждого уровня отдельно.

⚡ chmod +x <скрипт> — дать правО выполнения (оживить заклинание)
   chmod -x <скрипт> — отобрать право выполнения (усыпить)

───────────────────────────────────────
🔹 ПЕРЕДАЧА ПРАВ (chown)
───────────────────────────────────────

⚡ chown <новый_владелец> <файл> — передать артефакт другому магу
   В Незримом Университете артефакты принадлежат конкретным
   магам. Иногда нужно передать свиток коллеге.
   ⚠️ Требует прав sudo (административной магии).

───────────────────────────────────────
🔹 МАГИЧЕСКИЕ ПОРТАЛЫ (ln -s)
───────────────────────────────────────

⚡ ln -s <оригинал> <ссылка> — создать магический портал
   Символическая ссылка — это как портал в другую комнату.
   Ты стоишь в одном месте, а свиток лежит в другом.
   Но через портал ты его видишь и можешь читать.
   Пример:
     ln -s /tmp/ninja_training/keystore/public/schedule.txt ~/schedule_link
     → файл schedule.txt теперь «виден» из домашней башни
   ls -la покажет: schedule_link -> /tmp/ninja_training/.../schedule.txt

───────────────────────────────────────
🔹 ЗЕРКАЛО ЛИЧНОСТИ (whoami, id, sudo)
───────────────────────────────────────

⚡ whoami — «Кто я?» (под каким магом ты действуешь)
   Ринсвинд иногда забывает, под чьим именем он вошёл.
   Особенно после экспериментов с превращениями.

⚡ id — полная информация о маге (uid, gid, группы)
   Как магическое удостоверение личности.

⚡ sudo <команда> — выполнить заклинание с ПРАВАМИ АРХИКАНЦЛЕРА
   Некоторые заклинания требуют высшей магии (root).
   sudo временно повышает твои полномочия.
   Но Архиканцлер может и отказать. Пароль всё-таки спрашивают.

───────────────────────────────────────
🔹 ПИТАНИЕ ЗАКЛИНАНИЙ ИЗ ФАЙЛОВ (<)
───────────────────────────────────────

⚡ команда < файл — вдохнуть содержимое свитка в заклинание
   Как скормить ингредиенты магическому котлу.
   Пример:
     wc -l < /tmp/ninja_training/keystore/public/schedule.txt
     → посчитать строки, подав файл на вход wc

   Разница:
     wc -l file.txt     → команда ОТКРЫВАЕТ файл сама
     wc -l < file.txt   → шелл ЧИТАЕТ файл и ПОДАЁТ на вход
   Для wc результат одинаковый. Но некоторые заклинания
   принимают данные только через <.

💡 МУДРОСТЬ СТАРШИХ МАГОВ:
   • ls -la показывает права (магическую ауру) всех файлов
   • 644 — стандарт для обычных свитков (все читают, владелец пишет)
   • 755 — стандарт для скриптов (владелец делает всё, остальные запускают)
   • 600 — для секретов (пароли, личные записи)
   • Никогда не делай chmod 777! Это как оставить дверь Архиканцлера
     открытой. С табличкой «Заходи, бери что хочешь.»

───────────────────────────────────────

🎯 ЗАДАНИЕ: Освой магию прав доступа!

1. Посмотри права файлов в keystore/ через ls -la
2. Создай скрипт /tmp/ninja_training/keystore/hello.sh с "#!/bin/bash\necho hello"
3. Сделай его исполняемым (chmod +x)
4. Выполни его и запиши результат в /tmp/ninja_training/hello_result.txt
5. Закрой доступ к private/passwords.txt (chmod 600)
6. Создай символическую ссылку /tmp/ninja_training/schedule_link на public/schedule.txt
7. Узнай кто ты — запиши результат whoami в /tmp/ninja_training/whoami.txt

Нажми [V] — Библиотекарь проверит замки.

VALIDATION
#!/bin/bash
errors=0

if [ -f /tmp/ninja_training/hello_result.txt ]; then
    content=$(cat /tmp/ninja_training/hello_result.txt | tr -d '[:space:]')
    if [ "$content" = "hello" ]; then
        echo "✓ Скрипт ожил и поприветствовал мир!"
    else
        echo "✗ Результат выполнения неверный (ожидалось 'hello')"
        errors=$((errors+1))
    fi
else
    echo "✗ hello_result.txt не создан"
    errors=$((errors+1))
fi

if [ -x /tmp/ninja_training/keystore/hello.sh ]; then
    echo "✓ hello.sh — исполняемый! Заклинание живо!"
else
    echo "✗ hello.sh не имеет права выполнения (chmod +x)"
    errors=$((errors+1))
fi

priv_perm=$(stat -f "%Lp" /tmp/ninja_training/keystore/private/passwords.txt 2>/dev/null || stat -c "%a" /tmp/ninja_training/keystore/private/passwords.txt)
if [ "$priv_perm" = "600" ]; then
    echo "✓ Пароль Архиканцлера надёжно защищён (600)!"
else
    echo "✗ private/passwords.txt не 600 (сейчас: $priv_perm) — может прочитать кто угодно!"
    errors=$((errors+1))
fi

if [ -L /tmp/ninja_training/schedule_link ]; then
    target=$(readlink /tmp/ninja_training/schedule_link)
    if echo "$target" | grep -q "schedule.txt"; then
        echo "✓ Магический портал создан! schedule_link → schedule.txt"
    else
        echo "✗ Ссылка создана, но указывает не на schedule.txt"
        errors=$((errors+1))
    fi
else
    echo "✗ Символическая ссылка schedule_link не создана (ln -s)"
    errors=$((errors+1))
fi

if [ -f /tmp/ninja_training/whoami.txt ]; then
    echo "✓ Ты знаешь кто ты! (whoami.txt создан)"
else
    echo "✗ whoami.txt не создан"
    errors=$((errors+1))
fi

if [ $errors -eq 0 ]; then
    echo "✓ Библиотекарь проверяет замки... 'Уук.' (Всё надёжно.)"
fi

exit $errors

HINTS
Создание скрипта: printf '#!/bin/bash\necho hello' > keystore/hello.sh
Право выполнения: chmod +x keystore/hello.sh
Запуск: cd /tmp/ninja_training/keystore && ./hello.sh > /tmp/ninja_training/hello_result.txt
Закрыть доступ: chmod 600 keystore/private/passwords.txt
Ссылка: ln -s /tmp/ninja_training/keystore/public/schedule.txt /tmp/ninja_training/schedule_link
whoami > /tmp/ninja_training/whoami.txt