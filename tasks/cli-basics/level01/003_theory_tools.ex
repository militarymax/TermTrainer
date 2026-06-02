META
# Title: Свитки, гримуары и их природа
# Number: 003
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/artifacts/{scrolls,grimoires,misc}
echo "#!/bin/bash" > /tmp/termtrainer_lab/artifacts/misc/summon.sh
echo "echo 'Boo!'" >> /tmp/termtrainer_lab/artifacts/misc/summon.sh
chmod +x /tmp/termtrainer_lab/artifacts/misc/summon.sh
echo "Это обычный текст" > /tmp/termtrainer_lab/artifacts/scrolls/readable.txt
printf '\x89PNG\r\n\x1a\n' > /tmp/termtrainer_lab/artifacts/misc/mysterious.bin
echo "В Незримом Университете водятся драконы. Много драконов. Слишком много драконов. Однажды дракон съел весь факультет Зоологии. Но зоологи не заметили разницы." > /tmp/termtrainer_lab/artifacts/grimoires/long_tale.txt
echo "port=8080" > /tmp/termtrainer_lab/artifacts/grimoires/config.conf
ln -s /tmp/termtrainer_lab/artifacts/scrolls/readable.txt /tmp/termtrainer_lab/artifacts/portal_link.txt

TASK
📜 СВИТОК ЗНАНИЙ #003: Свитки, гримуары и их природа

Стиббонс вручил тебе третий свиток и сказал:
«Ринсвинд, ты уже умеешь ходить по коридорам и трогать
артефакты. Но ты до сих пор не умеешь ОПРЕДЕЛЯТЬ их природу!
Вчера ты попытался прочитать бинарный файл через cat.
Библиотекарь был вынужден промывать тебе глаза. Заново.
Это были очень дорогие глаза, между прочим. Дотация
из казны Архиканцлера.»

───────────────────────────────────────
🔹 ЗАКЛИНАНИЯ ОПРЕДЕЛЕНИЯ ПРИРОДЫ
───────────────────────────────────────

⚡ file <имя> — определить ТИП артефакта
   Не всё, что выглядит как свиток — свиток. Некоторые
   артефакты притворяются. file смотрит на магическую
   сигнатуру (первые байты) и говорит правду.
   Примеры:
     file readable.txt  → ASCII text
     file mysterious.bin → PNG image data (проклятый артефакт!)
     file summon.sh     → Bourne-Again shell script

⚡ which <команда> — найти, ГДЕ лежит заклинание
   В Незримом Университете тысячи заклинаний. which скажет,
   из какой башни конкретное заклинание.
   Примеры:
     which bash    → /bin/bash (вот где обитает bash)
     which python3 → /usr/bin/python3
     which ls      → /bin/ls

⚡ type <команда> — узнать ПРИРОДУ заклинания
   type умнее which. Он различает: встроенное заклинание,
   внешнее (из файла), или псевдоним (alias).
   Примеры:
     type cd    → cd is a shell builtin (встроенное! Не файл!)
     type ls    → ls is /bin/ls (внешнее заклинание)
     type ll    → ll is an alias for ls -l (обманка!)

───────────────────────────────────────
🔹 ЗАКЛИНАНИЯ ЧТЕНИЯ ДЛИННЫХ СВИТКОВ
───────────────────────────────────────

⚡ less <файл> — читать свиток с ПРОКРУТКОЙ
   СПРОСИТЕ МАГА: «Почему не cat?»
   ОТВЕТ МАГА: «А ты пробовал читать „Войну и Мир“ через cat?
               Вот именно. less позволяет листать, искать,
               проматывать. Это как волшебная книга — открывается
               на нужной странице.»
   Управление в less:
     q         — выйти (quit)
     Space     — страница вниз
     b         — страница вверх
     /слово    — искать слово (n = следующее, N = предыдущее)
     g         — в начало
     G         — в конец

⚡ tail -f <файл> — следить за свитком В РЕАЛЬНОМ ВРЕМЕНИ
   Как магическое зеркало, которое показывает, что пишут
   в журнал ПРЯМО СЕЙЧАС. Маги логирования используют
   tail -f чтобы наблюдать за порталами.
   Ctrl+C — прервать наблюдение (разбить зеркало).

───────────────────────────────────────
🔹 ЗАКЛИНАНИЯ ПОЛУЧЕНИЯ ЗНАНИЙ
───────────────────────────────────────

⚡ man <команда> — вызвать ДУХА-ОБЪЯСНИТЕЛЯ (MANual)
   Самый могущественный источник знаний. Дух знает ВСЁ
   о любой команде. Но говорит он на древнем наречии
   (техническом английском). Управление — как в less.
   Примеры:
     man ls     → всё о заклинании ls (и флаги, и примеры)
     man grep   → всё о поисковом заклинании
     man man    → руководство по руководству (мета-магия!)

⚡ <команда> --help — короткая справка
   Быстрее чем man, короче чем man. Показывает основные
   флаги и их назначение. Не всегда доступно, но когда
   доступно — спасает.
   Пример: grep --help → список флагов grep

💡 МУДРОСТЬ СТАРШИХ МАГОВ:
   • Всегда проверяй файл через file перед чтением
   • Если вывод команды большой — less, не cat
   • Если не знаешь флаги — man или --help
   • tail -f — твой лучший друг при отладке порталов

───────────────────────────────────────

🎯 ЗАДАНИЕ: Изучи природу артефактов!

1. Определи тип файла mysterious.bin через file
2. Найди где лежит команда bash (which)
3. Узнай природу команды cd (type)
4. Открой длинный свиток long_tale.txt через less (просто попробуй!)
5. Посмотри справку по команде ls (man ls или ls --help)
6. Запиши результат file mysterious.bin в /tmp/termtrainer_lab/file_result.txt

Нажми [V] когда выполнишь — Стиббонс проверит.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/file_result.txt ]; then
    echo "✗ file_result.txt не создан"
    errors=$((errors+1))
else
    if grep -q "PNG\|data\|image" /tmp/termtrainer_lab/file_result.txt; then
        echo "✓ Природа mysterious.bin раскрыта! Это не текст!"
    else
        echo "✗ Результат file неверный (ожидалось что-то про PNG/image data)"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ Стиббонс кивает: 'Ты научился определять природу вещей. Прогресс.'"
fi

exit $errors

HINTS
file /tmp/termtrainer_lab/artifacts/misc/mysterious.bin
which bash
type cd
less /tmp/termtrainer_lab/artifacts/grimoires/long_tale.txt
man ls (или ls --help)
file /tmp/termtrainer_lab/artifacts/misc/mysterious.bin > /tmp/termtrainer_lab/file_result.txt