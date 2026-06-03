META
# Track: git
# Title: Война свитков и тайник Астролога
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 20
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив Университета" > README.md && git add . && git commit -m "feat: initial"

TASK
⚔️ **Война свитков и тайник Астролога**

Два мага редактируют один файл — возникает конфликт! А ещё иногда нужно срочно переключиться на другую задачу, не теряя текущую работу.

📋 **Задания**:
1. Создай ветку `feature/update` и измени первую строку README.md на "# Великий Архив"
2. Закоммить в feature/update
3. Переключись на main и измени ту же строку на "# Малый Архив"
4. Закоммить в main
5. Попробуй `git merge feature/update` — возникнет конфликт!
6. Открой README.md — увидишь маркеры конфликта (`<<<<<<<`, `=======`, `>>>>>>>`)
7. Разреши конфликт: оставь "# Великий Архив Университета"

ASSIGNMENT
8. Выполни `git add README.md && git commit`

9. Теперь stash: измени любой файл, но НЕ коммить
10. Выполни `git stash push -m "work in progress"`
11. Проверь `git status` — чисто! Изменения спрятаны
12. Верни: `git stash pop`
13. Посмотри список: `git stash list`

📂 Рабочий каталог: `~/.termtrainer/git_009`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/git_009

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_009"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 3 ] 2>/dev/null && { echo "✓ $commits коммитов (конфликт разрешён)"; score=$((score+1)); }

if grep -q 'Великий' README.md 2>/dev/null; then
  echo "✓ Конфликт разрешён (Великий Архив)"
  score=$((score+1))
fi

stash_count=$(git stash list 2>/dev/null | wc -l)
if [ "$stash_count" -ge 0 ] 2>/dev/null; then
  echo "✓ Stash использовался (записей: $stash_count)"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Война свитков и тайник освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Создать конфликт: измени одну строку в двух ветках по-разному
Маркеры: <<<<<<< HEAD = твоя версия, ======= разделитель, >>>>>>> branch = их версия
Разрешение: удали маркеры, оставь нужный текст, сохрани файл
Завершить merge: git add README.md && git commit
Stash save: git stash push -m "описание"
Stash list: git stash list
Stash return: git stash pop (применить + удалить) или git stash apply (только применить)
Stash drop: git stash drop stash@{0}
