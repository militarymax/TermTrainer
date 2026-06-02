META
# Track: git
# Title: Совет Астрологов
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_011"
rm -rf "$DIR" /tmp/git_011_bare.git 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Великий Архив Университета" > README.md
echo "Зелье невидимости" >> зелья.txt
git add . && git commit -m "feat: initial archive"
git init --bare /tmp/git_011_bare.git >/dev/null 2>&1

TASK
🐉 **Совет Астрологов** (БОСС)

Три Астролога работают над одним архивом. Возникают конфликты, нужны теги для релизов, а bisect поможет найти, когда сломалось заклинание.

ASSIGNMENT
📋 **Боевые задания**:
1. Создай ветку `feature/fire-spell`, добавь `огненный_свиток.txt`, закоммить
2. Создай ветку `feature/ice-spell` ОТ main, добавь `ледяной_свиток.txt`, закоммить
3. Слей обе ветки в main (одна может конфликтовать если меняли один файл)
4. Используй `git stash` чтобы временно спрятать незакоммиченные изменения
5. Сделай `git rebase -i HEAD~3` — объедини два мелких коммита в один (squash)
6. Создай аннотированный тег `v2.0`
7. Добавь remote и запушь с тегами
8. Используй `git bisect`: добавь "баг" в один из коммитов, найди его через бинарный поиск

💡 **bisect**:
• `git bisect start` — начать поиск
• `git bisect bad` — текущий коммит плохой
• `git bisect good <commit>` — известный хороший коммит
• Git сам переключает на средний коммит — ты проверяешь и говоришь good/bad

📂 Рабочий каталог: `~/.termtrainer/git_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_011"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 3 ] 2>/dev/null && { echo "✓ $commits коммитов"; score=$((score+1)); }

tags=$(git tag 2>/dev/null)
[ -n "$tags" ] && { echo "✓ Теги: $tags"; score=$((score+1)); }

remotes=$(git remote 2>/dev/null)
[ -n "$remotes" ] && { echo "✓ Remote настроен"; score=$((score+1)); }

if [ -f "$DIR/огненный_свиток.txt" ] || [ -f "$DIR/ледяной_свиток.txt" ]; then
  echo "✓ Файлы из feature-веток слиты"
  score=$((score+1))
fi

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Совет Астрологов доволен! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Feature ветки: git checkout -b feature/spell && ... && git checkout main && git merge feature/spell
Stash: git stash push -m "wip" && ... && git stash pop
Rebase interactive: GIT_SEQUENCE_EDITOR="sed -i '' 's/pick/squash/'" git rebase -i HEAD~3
Tag: git tag -a v2.0 -m "Release 2.0"
Push tags: git push origin main --tags
Bisect: git bisect start && git bisect bad HEAD && git bisect good <old-commit>
Bisect проверка: проверяешь код, git bisect good/bad, повторяешь
Bisect end: git bisect reset
