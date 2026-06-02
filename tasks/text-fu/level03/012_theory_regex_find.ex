META
# Track: text-fu
# Title: Расширенное зрение
# Number: 012
# Level: 3
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/архив_1" "$DIR/архив_2" "$DIR/архив_3"
# Файлы с разными расширениями
echo "Свиток огня — древний текст" > "$DIR/архив_1/свиток_01.txt"
echo "Свиток воды — мокрый текст" > "$DIR/архив_1/свиток_02.log"
echo "ПРОКЛЯТЫЙ свиток — не читать" > "$DIR/архив_1/проклятый.txt"
echo "Зелье невидимости — рецепт" > "$DIR/архив_2/рецепт_01.txt"
echo "ОШИБКА: ингредиент не найден" > "$DIR/архив_2/ошибки.log"
echo "ВСЁ ХОРОШО" > "$DIR/архив_2/отчёт.txt"
echo "ПРОКЛЯТЫЙ амулет" > "$DIR/архив_3/амулет.txt"
echo "Свиток земли — пыльный текст" > "$DIR/архив_3/свиток_03.txt"
echo "ПРЕДУПРЕЖДЕНИЕ: мана на исходе" > "$DIR/архив_3/система.log"
# Создадим файлы без расширения
echo "секретный свиток без расширения" > "$DIR/архив_1/readme"
echo "123-456-7890" > "$DIR/телефоны.txt"
echo "+7 (999) 123-45-67" > "$DIR/телефоны2.txt"
echo "contact@university.magic" > "$DIR/email.txt"

TASK
🔍 **Расширенное зрение — regex + find -exec + grep -E**

Теперь ты маг высокого ранга. Обычного grep недостаточно — нужны регулярные выражения и пакетные операции над сотнями файлов.

**Регулярные выражения (regex) в grep:**
• `grep -E 'паттерн' файл` — расширенные регулярки (Extended regex)
• `grep -E 'слово1|слово2' файл` — ИЛИ (word1 ИЛИ word2)
• `grep -E '^начало' файл` — строки, начинающиеся с «начало»
• `grep -E 'конец$' файл` — строки, заканчивающиеся на «конец»
• `grep -E '[0-9]+' файл` — строки с числами
• `grep -E '[A-Z]{3,}' файл` — 3+ заглавных букв подряд
• `grep -v 'паттерн' файл` — ИНВЕРСИЯ: строки без паттерна
• `grep -i 'слово' файл` — игнорировать регистр
• `grep -r 'слово' каталог` — рекурсивный поиск по каталогу
• `grep -rl 'слово' каталог` — вывести только имена файлов (-l = list)

**find — поиск файлов:**
• `find каталог -name '*.txt'` — найти все .txt файлы
• `find каталог -type f` — найти все обычные файлы
• `find каталог -mtime -7` — изменённые за последние 7 дней
• `find каталог -size +1M` — файлы больше 1 МБ

**find -exec — пакетные операции:**
• `find каталог -name '*.log' -exec rm {} \;` — удалить все .log файлы
• `find каталог -name '*.txt' -exec wc -l {} \;` — подсчёт строк в каждом .txt
• `find каталог -name '*.txt' -exec grep -l 'ошибка' {} \;` — найти .txt с «ошибка»

ASSIGNMENT

📂 Рабочий каталог: `~/.termtrainer/textfu_012`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_012"
score=0

if [ ! -d "$DIR/архив_1" ]; then
  echo "✗ fail: каталог архив_1 не найден"
  exit 1
fi

# Проверка: любой результат построчного поиска
if [ -f "$DIR/результаты_поиска.txt" ]; then
  echo "✓ результаты_поиска.txt созданы"
  score=$((score + 1))
fi

echo "✓ ok: regex + find освоены (баллов: $score)"
exit 0

HINTS
Найти все .txt файлы: find ~/.termtrainer/textfu_012 -name '*.txt'
Найти .txt и .log: find ~/.termtrainer/textfu_012 -name '*.txt' -o -name '*.log'
grep с OR: grep -E 'ПРОКЛЯТЫЙ|ОШИБКА' файл.txt
grep начало строки: grep -E '^Свиток' *.txt
grep строки с числами: grep -E '[0-9]' файл.txt
grep 3+ заглавных: grep -E '[A-ZА-Я]{3,}' файл.txt
Рекурсивный grep: grep -r 'ПРОКЛЯТЫЙ' ~/.termtrainer/textfu_012
Рекурсивный grep + имена файлов: grep -rl 'ПРОКЛЯТЫЙ' ~/.termtrainer/textfu_012
find + exec (подсчёт строк): find ~/.termtrainer/textfu_012 -name '*.txt' -exec wc -l {} \;
find + grep (пакетный поиск): find ~/.termtrainer/textfu_012 -name '*.txt' -exec grep -l 'свиток' {} \;
Сохранить результаты: find ~/.termtrainer/textfu_012 -name '*.txt' -exec wc -l {} \; > ~/.termtrainer/textfu_012/результаты_поиска.txt