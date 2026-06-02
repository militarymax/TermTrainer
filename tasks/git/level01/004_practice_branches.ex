META
# Track: git
# Title: Параллельные вселенные
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "Архив Университета" > README.md && git add . && git commit -m "feat: initial commit"

TASK
🌿 **Параллельные вселенные**

Гит позволяет создавать параллельные вселенные — ветки. В каждой ветке можно экспериментировать, не ломая основную линию. Когда эксперимент удаётся — сливаем обратно.

📋 **Задания**:
1. Посмотри текущую ветку: `git branch`
2. Создай ветку `feature/potions`: `git checkout -b feature/potions` или `git switch -c feature/potions`
3. Создай файл `новые_зелья.txt` и закоммить в этой ветке
4. Переключись обратно на main: `git checkout main` или `git switch main`
5. Проверь, что `новые_зелья.txt` НЕ виден в main
6. Слей ветку: `git merge feature/potions`
7. Проверь, что файл теперь в main
8. Удали слитую ветку: `git branch -d feature/potions`

📂 Рабочий каталог: `~/.termtrainer/git_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_004"
score=0

cd "$DIR" 2>/dev/null || exit 1

branches=$(git branch | wc -l)
if [ "$branches" -eq 1 ] 2>/dev/null; then
  echo "✓ Только одна ветка (feature удалена)"
  score=$((score+1))
fi

if [ -f "$DIR/новые_зелья.txt" ]; then
  echo "✓ новые_зелья.txt слит в main"
  score=$((score+1))
fi

commits=$(git rev-list --count HEAD 2>/dev/null)
if [ "$commits" -ge 2 ] 2>/dev/null; then
  echo "✓ $commits коммитов"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Параллельные вселенные освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Создать ветку: git checkout -b feature/potions или git switch -c feature/potions
Переключиться: git checkout main или git switch main
Список веток: git branch
Слить: git merge feature/potions
Удалить ветку: git branch -d feature/potions
