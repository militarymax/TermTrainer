META
# Title: Наведение порядка в лаборатории
# Number: 005
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 10

SETUP
#!/bin/bash
mkdir -p /tmp/termtrainer_lab/filelab/{src,backup,temp}
echo "function main() { return 0; }" > /tmp/termtrainer_lab/filelab/src/main.c
echo "# TODO: написать заклинание Левитации" > /tmp/termtrainer_lab/filelab/src/test.c
echo "config=debug" > /tmp/termtrainer_lab/filelab/config.ini
echo "остатки прошлого эксперимента" > /tmp/termtrainer_lab/filelab/temp/cache.tmp

TASK
⚗️ ЛАБОРАТОРНАЯ #005: Наведение порядка в лаборатории

Декан зашёл в твою лабораторию и застал ТАКОЕ...

«Ринсвинд! Почему на полу валяются временные файлы?!
Почему нет резервной копии конфигурации?! Где Makefile?!
В Незримом Университете принято наводить порядок после
экспериментов! Иначе — знаешь, что бывает с неаккуратными
магами? Они становятся привидениями. Вечными привидениями.
Которые вечно убирают вечно грязные лаборатории.»

Структура лаборатории:
  filelab/
  ├── src/
  │   ├── main.c    ← основное заклинание
  │   └── test.c    ← черновик (оставь как есть)
  ├── backup/       ← для резервных копий!
  ├── temp/
  │   └── cache.tmp ← мусор! Перемести в backup/, потом удали temp/
  └── config.ini    ← важная конфигурация!

ASSIGNMENT
🎯 ЗАДАНИЕ:

📂 Перейди в рабочий каталог: cd /tmp/termtrainer_lab/filelab/{src,backup,temp}
1. Перейди в /tmp/termtrainer_lab/filelab
2. Создай файл src/Makefile с содержимым "all: build"
3. Скопируй config.ini в backup/ (резервная копия!)
4. Перемести temp/cache.tmp в backup/
5. Удали пустую директорию temp/

Нажми [V] — Декан лично проверит порядок.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/termtrainer_lab/filelab/src/Makefile ]; then
    echo "✗ Файл src/Makefile не создан"
    errors=$((errors+1))
else
    content=$(cat /tmp/termtrainer_lab/filelab/src/Makefile)
    if [ "$content" = "all: build" ]; then
        echo "✓ Makefile создан правильно!"
    else
        echo "✗ Содержимое Makefile неверное"
        errors=$((errors+1))
    fi
fi

if [ ! -f /tmp/termtrainer_lab/filelab/backup/config.ini ]; then
    echo "✗ config.ini не скопирован в backup/"
    errors=$((errors+1))
else
    echo "✓ Конфигурация в резервной копии!"
fi

if [ ! -f /tmp/termtrainer_lab/filelab/backup/cache.tmp ]; then
    echo "✗ cache.tmp не перемещён в backup/"
    errors=$((errors+1))
else
    echo "✓ Остатки эксперимента перемещены!"
fi

if [ -d /tmp/termtrainer_lab/filelab/temp ]; then
    echo "✗ Директория temp/ всё ещё здесь! Удали её."
    errors=$((errors+1))
else
    echo "✓ Временная директория удалена!"
fi

if [ $errors -eq 0 ]; then
    echo "✓ Декан осматривает лабораторию... 'Хм. Приемлемо.'"
fi

exit $errors

HINTS
Создание файла: echo "all: build" > src/Makefile
Копирование: cp config.ini backup/
Перемещение: mv temp/cache.tmp backup/
Удаление пустой папки: rmdir temp/ или rm -r temp/
