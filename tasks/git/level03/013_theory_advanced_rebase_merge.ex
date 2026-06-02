META
# Track: git
# Title: Стратегии Канцлера
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
echo "Зелье" >> зелья.txt && git add . && git commit -m "feat: potions"

TASK
📜 **Стратегии Канцлера**

Канцлер знает: есть много способов слить изменения и переписать историю. Выбор стратегии — это искусство.

📖 **Стратегии слияния**:
• `git merge -X ours <branch>` — при конфликте предпочитать нашу версию
• `git merge -X theirs <branch>` — при конфликте предпочитать их версию
• `git merge --no-ff <branch>` — создать merge-коммит даже если возможен fast-forward
• Стратегии: `recursive` (по умолчанию), `octopus`, `ours`, `subtree`

📖 **Rerere — повторное разрешение конфликтов**:
• `git config rerere.enabled true` — включить
• Git запоминает, как ты разрешил конфликт
• При следующем таком же конфликте применит то же решение автоматически

📖 **Переписывание истории**:
• `git filter-branch` — старый способ (медленный, не рекомендуется)
• `git filter-repo` — современный replacement (быстрый, безопасный)
• Используй для: удаления секретов из истории, переименования автора

📖 **Worktree — несколько рабочих каталогов**:
• `git worktree add ../other-dir <branch>` — второй каталог для другой ветки
• Работай с двумя ветками одновременно без переключения!
• `git worktree list` / `git worktree remove ../other-dir`

📖 **Bundle — передача без сети**:
• `git bundle create archive.bundle --all` — упаковать в файл
• `git clone archive.bundle repo` — распаковать
• Полезно для air-gapped систем

📂 Рабочий каталог: `~/.termtrainer/git_013`

ASSIGNMENT
📋 **Попробуй**:
1. Создай worktree для другой ветки
2. Включи rerere: `git config rerere.enabled true`
3. Посмотри стратегии merge: `git merge -s help` (если доступно)

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_013"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 1 ] 2>/dev/null && { echo "✓ Репозиторий работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Стратегии Канцлера изучены! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Merge стратегия ours: git merge -X theirs feature — предпочесть их версию при конфликте
No fast-forward: git merge --no-ff feature — всегда создаёт merge-коммит
Rerere: git config rerere.enabled true — запоминать разрешения конфликтов
Filter-repo: pip install git-filter-repo; git filter-repo --invert-paths --path secret.txt
Worktree: git worktree add ../hotfix hotfix-branch — вторая рабочая копия
Bundle: git bundle create backup.bundle --all; git clone backup.bundle restored/
