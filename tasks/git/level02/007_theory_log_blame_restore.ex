META
# Track: git
# Title: Глаз Астролога
# Number: 007
# Level: 2
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
echo "Зелье невидимости" >> зелья.txt && git add . && git commit -m "feat: add potions"
echo "Свиток огня" >> свитки.txt && git add . && git commit -m "feat: add scrolls"

TASK
📜 **Глаз Астролога**

Астрологи видят всё — кто изменил строку, когда и зачем. Научись читать историю и управлять изменениями до коммита.

📖 **Продвинутый просмотр истории**:
• `git log --oneline --graph --all --decorate` — визуальная история всех веток
• `git show <commit>` — показать содержимое конкретного коммита
• `git blame <file>` — кто и когда изменил каждую строку

📖 **Управление изменениями перед коммитом**:
• `git add -p` — интерактивное добавление кусочками (hunks)
• `git reset HEAD <file>` — убрать файл из staging (не удаляет изменения)
• `git restore <file>` — откатить незакоммиченные изменения в рабочем каталоге
• `git restore --staged <file>` — то же что reset HEAD

📂 Рабочий каталог: `~/.termtrainer/git_007`

📋 **Попробуй**:
1. Посмотри красивую историю: `git log --oneline --graph --all`
2. Проверь кто писал README: `git blame README.md`
3. Измени файл, добавь через `git add -p`, выбрав один hunk
4. Убери из staging через `git reset HEAD`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_007"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 3 ] 2>/dev/null && { echo "✓ История из $commits коммитов"; score=$((score+1)); }

[ -f "$DIR/README.md" ] && { echo "✓ Файлы на месте"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Глаз Астролога открыт! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Красивая история: git log --oneline --graph --all --decorate
Blame: git blame README.md — покажет автора каждой строки
Show: git show HEAD — последний коммит; git show abc123 — конкретный
Add patch: git add -p file.txt — выбираешь какие куски добавить
Reset staging: git reset HEAD file.txt — убрать из индекса
Restore: git restore file.txt — откатить изменения в рабочем каталоге
