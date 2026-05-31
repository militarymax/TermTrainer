META
# Track: git
# Title: Переписывание свитков
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
echo "Зелье 1" >> зелья.txt && git add . && git commit -m "feat: add potion1"
echo "Зелье 2" >> зелья.txt && git add . && git commit -m "feat: add potion2"
echo "Зелье 3" >> зелья.txt && git add . && git commit -m "feat: add potion3"

TASK
📜 **Переписывание свитков**

Иногда нужно исправить последний коммит или переписать целую историю. Гит позволяет менять прошлое — но будь осторожен с публичными ветками!

📖 **Исправление последнего коммита**:
• `git commit --amend` — изменить сообщение или добавить забытые файлы
• Меняет ТОЛЬКО последний коммит
• Не используй на публичных ветках!

📖 **Интерактивный rebase**:
• `git rebase -i HEAD~n` — переписать последние n коммитов
• Команды в rebase:
  - `pick` — оставить как есть
  - `squash` — объединить с предыдущим коммитом
  - `fixup` — как squash, но отбросить сообщение
  - `reword` — изменить сообщение коммита
  - `drop` — удалить коммит
  - Можно менять порядок строк = менять порядок коммитов

⚠️ **Правило**: Никогда не делай rebase публичных веток! Только локальные.

📂 Рабочий каталог: `~/.ninja_trainer/git_008`

📋 **Попробуй**:
1. Измени последний коммит: добавь файл и сделай `git commit --amend`
2. Посмотри интерактивный rebase: `git rebase -i HEAD~3` (объедини два коммита)

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_008"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 2 ] 2>/dev/null && { echo "✓ $commits коммитов"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Переписывание свитков освоено! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Amend: git commit --amend -m "Новое сообщение" — изменит последний коммит
Amend + файл: git add forgotten.txt && git commit --amend --no-edit
Rebase interactive: git rebase -i HEAD~3 — откроет редактор с 3 коммитами
В редакторе: замени pick на squash чтобы объединить коммиты
Squash vs fixup: squash сохраняет оба сообщения, fixup — только первое
Reword: замени pick на reword чтобы изменить сообщение
Drop: удали строку полностью чтобы убрать коммит
