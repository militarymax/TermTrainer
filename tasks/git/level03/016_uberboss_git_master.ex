META
# Track: git
# Title: Архимаг Гитологии
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_016"
rm -rf "$DIR" /tmp/git_016_bare.git /tmp/git_016_worktree 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Великий Архив Университета" > README.md
echo "Зелье невидимости" >> зелья.txt
git add . && git commit -m "feat: initial archive"
echo "Зелье силы" >> зелья.txt && git add . && git commit -m "feat: add strength potion"
echo "Зелье мудрости" >> зелья.txt && git add . && git commit -m "feat: add wisdom potion"
echo "# БАГ: заклинание разрушено" >> баг.txt && git add . && git commit -m "feat: add bug accidentally"
echo "Свиток огня" >> свитки.txt && git add . && git commit -m "feat: add fire scroll"
git init --bare /tmp/git_016_bare.git >/dev/null 2>&1

TASK
👑 **Архимаг Гитологии** (UBERBOSS)

Ты достиг вершины мастерства. Докажи, что владеешь всеми аспектами Гита — от восстановления потерянных коммитов до написания хуков и безопасного форс-пуша.

📋 **БЛОК 1 — Восстановление через reflog**:

ASSIGNMENT
1. Выполни `git reset --hard HEAD~2` — "случайно" удали 2 коммита
2. Найди потерянные коммиты через `git reflog`
3. Восстанови через `git reset --hard HEAD@{1}` или по хешу

📋 **БЛОК 2 — Cherry-pick и Revert**:
4. Создай ветку `hotfix` от предпоследнего коммита
5. Добавь файл `патч.txt` и закоммить в hotfix
6. Переключись на main и сделай `git cherry-pick <hash-коммита-из-hotfix>`
7. Сделай `git revert HEAD` — безопасно отменить последний коммит (создаст новый)

📋 **БЛОК 3 — Интерактивный rebase**:
8. Сделай `GIT_SEQUENCE_EDITOR="sed -i '' '2s/pick/squash/'" git rebase -i HEAD~3`
   Или вручную: `git rebase -i HEAD~3` и замени pick на squash для второго коммита

📋 **БЛОК 4 — Хуки**:
9. Создай `pre-push` хук: если текущая ветка main — вывести предупреждение
10. Создай `commit-msg` хук: сообщение должно содержать номер (feat/fix/docs/chore)

📋 **БЛОК 5 — Force-with-lease и Worktree**:
11. Добавь remote: `git remote add origin /tmp/git_016_bare.git`
12. Запушь: `git push origin main`
13. Попробуй: `git push --force-with-lease origin main` (безопасный force push)
14. Создай worktree: `git worktree add /tmp/git_016_worktree -b review`

📋 **БЛОК 6 — Bisect run**:
15. Используй `git bisect` чтобы найти коммит с "БАГ" в сообщении:
    - `git bisect start`
    - `git bisect bad HEAD`
    - `git bisect good HEAD~4`
    - Проверяй каждый коммит и отмечай good/bad
    - Или автоматизируй: `git bisect run bash -c 'git log -1 --format=%s | grep -q БАГ && exit 1 || exit 0'`

📂 Рабочий каталог: `~/.termtrainer/git_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_016"
score=0
max=8

cd "$DIR" 2>/dev/null || exit 1

# БЛОК 1: Reflog использовался
reflog_lines=$(git reflog 2>/dev/null | wc -l)
[ "$reflog_lines" -ge 5 ] 2>/dev/null && { echo "✓ Reflog богат ($reflog_lines записей)"; score=$((score+1)); }

# БЛОК 2: Cherry-pick или revert
commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 5 ] 2>/dev/null && { echo "✓ $commits коммитов (cherry/revert)"; score=$((score+1)); }

# БЛОК 3: Rebase был (проверяем что история переписана)
if git log --oneline 2>/dev/null | head -5 | grep -qi 'squash\|merge\|revert'; then
  echo "✓ История переписана"
  score=$((score+1))
fi

# БЛОК 4: Хуки
if [ -f ".git/hooks/pre-push" ] || [ -f ".git/hooks/commit-msg" ]; then
  echo "✓ Хуки созданы"
  score=$((score+1))
fi

# БЛОК 5: Remote + worktree
remotes=$(git remote 2>/dev/null)
[ -n "$remotes" ] && { echo "✓ Remote настроен"; score=$((score+1)); }

worktrees=$(git worktree list 2>/dev/null | wc -l)
[ "$worktrees" -ge 1 ] 2>/dev/null && { echo "✓ Worktree используется"; score=$((score+1)); }

# БЛОК 6: Bisect завершён
if ! git bisect log 2>/dev/null | grep -q "waiting"; then
  echo "✓ Bisect завершён или не запущен"
  score=$((score+1))
fi

# Общая проверка
branches=$(git branch 2>/dev/null | wc -l)
[ "$branches" -ge 1 ] && { echo "✓ Ветки существуют"; score=$((score+1)); }

echo "✓ ok: UBERBOSS пройден! (баллов: $score/$max)"
[ $score -ge 5 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Reflog: git reflog — все перемещения HEAD
Восстановление: git reset --hard HEAD@{N} — вернуться к записи из reflog
Потерянные объекты: git fsck --unreachable — найти потерянные коммиты

=== БЛОК 2 ===
Cherry-pick: git checkout main && git cherry-pick abc123
Revert: git revert HEAD — создать обратный коммит (безопасно!)

=== БЛОК 3 ===
Rebase interactive: GIT_SEQUENCE_EDITOR="sed -i '' '2s/pick/squash/'" git rebase -i HEAD~3
Или вручную: git rebase -i HEAD~3 → заменить pick на squash

=== БЛОК 4 ===
Pre-push: cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" == "main" ]]; then echo "WARNING: pushing to main!"; fi
EOF
chmod +x .git/hooks/pre-push

=== БЛОК 5 ===
Force-with-lease: git push --force-with-lease origin main — безопасный force
Worktree: git worktree add /tmp/worktree -b new-branch

=== БЛОК 6 ===
Bisect auto: git bisect start && git bisect bad HEAD && git bisect good <old>
Bisect run: git bisect run bash -c 'test_command'
Bisect reset: git bisect reset
