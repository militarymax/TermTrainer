META
# Title: Магическое Зрение
# Number: 011
# Level: 3
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/searchlab/{src,docs,config}
echo "function hello() { return 'Hello'; }" > /tmp/termtrainer_lab/searchlab/src/app.js
echo "function world() { return 'World'; }" > /tmp/termtrainer_lab/searchlab/src/utils.js
echo "# Application Config" > /tmp/termtrainer_lab/searchlab/config/app.conf
echo "debug=true" >> /tmp/termtrainer_lab/searchlab/config/app.conf
echo "port=8080" >> /tmp/termtrainer_lab/searchlab/config/app.conf
echo "API Documentation" > /tmp/termtrainer_lab/searchlab/docs/api.md
echo "TODO: fix bug in hello()" > /tmp/termtrainer_lab/searchlab/docs/todo.txt

TASK
📜 СВИТОК ЗНАНИЙ #011: Магическое Зрение

Декан встретил тебя у дверей библиотеки:
«Ринсвинд! Ты научился закрывать двери и изгонять демонов.
Отлично. Теперь — научись ИСКАТЬ. В Незримом Университете
тысячи свитков, и если ты не умеешь искать — ты бесполезен.
Хуже того — ты будешь задавать вопросы Библиотекарю.
А он кусается.»

Библиотекарь (который, напомню, орангутан) швырнул в тебя
пачкой свитков и сказал: «Уук!»

Переводчик Библиотекаря пояснил:
«Он говорит, что в библиотеке тысячи свитков, и без
заклинаний поиска ты будешь читать их до Второго Пришествия
Слона. Которое, кстати, уже было. На прошлой неделе.»

───────────────────────────────────────
🔹 ЗАКЛИНАНИЯ ПОИСКА
───────────────────────────────────────

⚡ find <путь> -name "<шаблон>" — найти артефакт по имени
   Это как спросить у Библиотекаря: «Где все свитки про драконов?»
   Только Библиотекарь не кусается.

   Примеры:
     find . -name "*.js"       → найти все свитки с заклинаниями JS
     find /tmp -name "app.*"   → найти все файлы с именем app
     find . -type f            → найти только файлы (не комнаты)
     find . -type d            → найти только директории (комнаты)
     find . -name "??.*"        → два символа + расширение

⚡ grep "<текст>" <файл> — найти строку в свитке
   Как лупа для мага. Ищет текст внутри файлов.

   Флаги:
     grep -r "текст" <путь>    → искать во ВСЕХ свитках рекурсивно!
                                  Без -r — только в одном файле.
     grep -i "текст"           → игнорировать регистр (BUG = bug = Bug)
     grep -n "текст"           → показать номер строки
                                  «Строка 42, абзац 7, слово 3» — точно!
     grep -l "текст" <путь>    → показать только ИМЕНА файлов
                                  Не содержимое, а где лежит.

💡 ВАЖНО: find ищет по ИМЕНИ файла.
         grep ищет по СОДЕРЖИМОМУ файла.
         Перепутаешь — будешь искать не там.

───────────────────────────────────────

🎯 ЗАДАНИЕ: Найди спрятанное!

1. Найди все .js файлы в searchlab/
2. Найди все .conf файлы
3. Найди в каком файле есть слово "bug"
4. Найди строку с "port=" в config/
5. Запиши результат поиска "bug" в /tmp/termtrainer_lab/found_bug.txt

Нажми [V] когда выполнишь.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/found_bug.txt ]; then
    echo "✗ Файл found_bug.txt не создан"
    errors=$((errors+1))
else
    if grep -q "bug" /tmp/termtrainer_lab/found_bug.txt; then
        echo "✓ Баг найден и записан!"
    else
        echo "✗ В found_bug.txt нет слова bug"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ Библиотекарь кивает: «Уук.» (одобрительно)"
fi

exit $errors

HINTS
find /tmp/termtrainer_lab/searchlab -name "*.js"
grep -r "bug" /tmp/termtrainer_lab/searchlab > /tmp/termtrainer_lab/found_bug.txt
grep "port=" /tmp/termtrainer_lab/searchlab/config/app.conf
