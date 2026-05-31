META
# Track: git
# Title: Хранилище Архиканцлера
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_006"
rm -rf "$DIR" /tmp/git_006_bare.git 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
git init --bare /tmp/git_006_bare.git >/dev/null 2>&1

TASK
🐉 **Хранилище Архиканцлера** (БОСС)

Архиканцлер Ридкулли требует полный архив Университета с историей, ветками и удалённым хранилищем. Покажи, что ты освоил весь базовый flow!

📋 **Боевые задания**:
1. Создай `README.md` с описанием проекта и закоммить
2. Создай `.gitignore` (игнорируй `*.log`, `*.tmp`, `.env`)
3. Создай ветку `feature/spells`, добавь файл `заклинания.txt` и закоммить
4. Вернись в main и слей `feature/spells`
5. Создай ещё одну ветку `fix/typo`, исправь опечатку в README, закоммить, слей в main
6. Добавь remote: `git remote add origin /tmp/git_006_bare.git`
7. Запушь: `git push origin main`
8. Проверь историю через `git log --oneline`

📂 Рабочий каталог: `~/.ninja_trainer/git_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_006"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 3 ] 2>/dev/null && { echo "✓ $commits коммитов"; score=$((score+1)); }

[ -f ".gitignore" ] && { echo "✓ .gitignore есть"; score=$((score+1)); }
grep -q '.log' .gitignore 2>/dev/null && { echo "✓ .gitignore содержит *.log"; score=$((score+1)); }

branches=$(git branch | wc -l)
[ "$branches" -eq 1 ] 2>/dev/null && { echo "✓ Все ветки слиты"; score=$((score+1)); }

remotes=$(git remote 2>/dev/null)
[ -n "$remotes" ] && { echo "✓ Remote настроен"; score=$((score+1)); }

[ $score -ge 4 ] && { echo "✓ ok: БОСС пройден! Архив Архиканцлера готов! (баллов: $score/5)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/5)"
exit 1

HINTS
Полный flow: git add . && git commit -m "feat: initial"
Ветка: git checkout -b feature/spells
Слить: git checkout main && git merge feature/spells
Удалить ветку: git branch -d feature/spells
Remote: git remote add origin /tmp/git_006_bare.git
Push: git push origin main
История: git log --oneline
