META
# Title: Подземелья Незримого Университета
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 15

SETUP
#!/bin/bash
mkdir -p /tmp/ninja_training/dungeon/{entrance,hallway/{left,right},chamber/{treasure,trap},exit}
echo "факел" > /tmp/ninja_training/dungeon/entrance/torch.txt
echo "меч" > /tmp/ninja_training/dungeon/hallway/left/sword.txt
echo "зелье" > /tmp/ninja_training/dungeon/hallway/right/potion.txt
echo "золото" > /tmp/ninja_training/dungeon/chamber/treasure/gold.txt
echo "яд" > /tmp/ninja_training/dungeon/chamber/trap/poison.txt
echo "свобода" > /tmp/ninja_training/dungeon/exit/freedom.txt

TASK
🐉 ЭКЗАМЕН #006: Подземелья Незримого Университета

Ты провалил экзамен по «Безопасной Навигации в Магических
Пространствах». Наказание — пройти через реальные подземелья.

Декан объяснил:
«Ринсвинд, подземелья — это метафора файловой системы.
Каждая комната — директория. Каждый предмет — файл.
Ты должен собрать артефакты, избежать ловушек и найти выход.
Если не справишься — останешься там навсегда.
Или до обеда. Что наступит раньше.»

План подземелья (составлен Смертью, который любит порядок):
  dungeon/
  ├── entrance/torch.txt     ← Факел! Без него темно.
  ├── hallway/
  │   ├── left/sword.txt     ← Меч! На всякий случай.
  │   └── right/potion.txt   ← Зелье! Мало ли что.
  ├── chamber/
  │   ├── treasure/gold.txt  ← СОКРОВИЩЕ!
  │   └── trap/poison.txt    ← ЯД! НЕ ТРОГАТЬ! Уничтожь немедленно!
  └── exit/freedom.txt       ← Выход на свободу!

🎯 ЗАДАНИЕ:
1. Создай инвентарь: /tmp/ninja_training/inventory.txt
2. Запиши туда содержимое torch.txt, sword.txt, potion.txt и gold.txt
   (каждый артефакт с новой строки — используй >> !)
3. Уничтожь файл poison.txt из ловушки!
4. Создай /tmp/ninja_training/freedom.txt с содержимым exit/freedom.txt

⚠️ Помни: > перезапишет файл, >> добавит строку!
Перепутаешь — потеряешь всё. Как тот студент из Алхимии.

VALIDATION
#!/bin/bash
errors=0

if [ ! -f /tmp/ninja_training/inventory.txt ]; then
    echo "✗ Инвентарь не создан"
    errors=$((errors+1))
else
    if grep -q "факел" /tmp/ninja_training/inventory.txt; then
        echo "✓ Факел в инвентаре!"
    else
        echo "✗ Факела нет (как ты собираешься видеть?)"
        errors=$((errors+1))
    fi
    
    if grep -q "меч" /tmp/ninja_training/inventory.txt; then
        echo "✓ Меч в инвентаре!"
    else
        echo "✗ Меча нет (а вдруг монстры?)"
        errors=$((errors+1))
    fi
    
    if grep -q "зелье" /tmp/ninja_training/inventory.txt; then
        echo "✓ Зелье в инвентаре!"
    else
        echo "✗ Зелья нет (мало ли что...)"
        errors=$((errors+1))
    fi
    
    if grep -q "золото" /tmp/ninja_training/inventory.txt; then
        echo "✓ Золото в инвентаре!"
    else
        echo "✗ Золота нет (Декан заберёт себе)"
        errors=$((errors+1))
    fi
fi

if [ -f /tmp/ninja_training/dungeon/chamber/trap/poison.txt ]; then
    echo "✗ Яд не уничтожен! Ты что, его выпил?!"
    errors=$((errors+1))
else
    echo "✓ Ловушка обезврежена!"
fi

if [ ! -f /tmp/ninja_training/freedom.txt ]; then
    echo "✗ freedom.txt не создан"
    errors=$((errors+1))
else
    content=$(cat /tmp/ninja_training/freedom.txt)
    if [ "$content" = "свобода" ]; then
        echo "✓ Свобода обретена!"
    else
        echo "✗ Содержимое freedom.txt неверное"
        errors=$((errors+1))
    fi
fi

if [ $errors -eq 0 ]; then
    echo "✓ 🐉 Экзамен сдан! Декан кивает: 'Не ожидал. Впечатляет.'"
    echo "  'Теперь иди к Библиотекарю. Он хочет научить тебя закрывать двери.'"
fi

exit $errors

HINTS
Собирай предметы через cat и >> : cat entrance/torch.txt >> /tmp/ninja_training/inventory.txt
Важно: >> для добавления (не > , иначе перезапишешь!)
Уничтожь яд: rm chamber/trap/poison.txt
Выход: cat exit/freedom.txt > /tmp/ninja_training/freedom.txt
