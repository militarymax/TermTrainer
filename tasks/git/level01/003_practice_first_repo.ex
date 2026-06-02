META
# Track: git
# Title: Архив свитков Ринсвинда
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"

TASK
⚗️ **Архив свитков Ринсвинда**

Ринсвинд решил навести порядок в своих записях и создать архив с историей изменений. Помоги ему инициализировать репозиторий и сделать первые коммиты.

ASSIGNMENT
📋 **Задания**:
1. Создай файл `README.md` с текстом "Архив Ринсвинда"
2. Добавь и закоммить: `git add README.md && git commit -m "feat: initial commit"`
3. Создай файл `зелья.txt` со списком зелий (по одному на строку)
4. Закоммить отдельно: `git add зелья.txt && git commit -m "feat: add potions list"`
5. Измени `README.md` — добавь строку "Версия 2"
6. Посмотри `git diff` — увидишь изменения
7. Посмотри `git diff --staged` после `git add` — увидишь подготовленные
8. Закоммить: `git commit -m "docs: update readme with version"`

📂 Рабочий каталог: `~/.termtrainer/git_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_003"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
if [ "$commits" -ge 3 ] 2>/dev/null; then
  echo "✓ $commits коммитов (нужно >= 3)"
  score=$((score+1))
fi

if [ -f "$DIR/README.md" ]; then
  echo "✓ README.md существует"
  score=$((score+1))
fi

if [ -f "$DIR/зелья.txt" ]; then
  echo "✓ зелья.txt существует"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Архив создан! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше коммитов (баллов: $score/3)"
exit 1

HINTS
Инициализация уже выполнена в SETUP
Создать файл: echo "Архив Ринсвинда" > README.md
Добавить+коммит: git add README.md && git commit -m "feat: initial commit"
Просмотр diff: git diff (до add), git diff --staged (после add)
История: git log --oneline
