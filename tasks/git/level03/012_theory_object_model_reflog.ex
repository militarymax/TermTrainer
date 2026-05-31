META
# Track: git
# Title: Внутренности демона Гита
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
echo "Зелье" >> зелья.txt && git add . && git commit -m "feat: potions"
echo "Свиток" >> свитки.txt && git add . && git commit -m "feat: scrolls"

TASK
📜 **Внутренности демона Гита**

Чтобы по-настоящему владеть Гитом, нужно понимать, как он хранит данные внутри. А reflog — твой спасательный круг, когда всё пошло не так.

📖 **Объектная модель Git**:
• **blob** — содержимое файла (только данные, без имени)
• **tree** — каталог (список имён файлов + ссылки на blob/tree)
• **commit** — снимок (ссылка на tree + автор + сообщение + родитель)
• **tag** — именованная ссылка на commit (аннотированный)
• Каждый объект имеет уникальный SHA-1 хеш

📖 **Как посмотреть объекты**:
• `git cat-file -p <hash>` — показать содержимое объекта
• `git cat-file -t <hash>` — тип объекта (blob/tree/commit/tag)
• `git ls-tree HEAD` — дерево корневого каталога

📖 **Reflog — журнал всех перемещений**:
• `git reflog` — показывает ВСЕ перемещения HEAD (даже потерянные коммиты!)
• `git reset --hard <hash>` — вернуться к любому коммиту из reflog
• Спасает после случайного rebase, reset, amend

📖 **Cherry-pick и Revert**:
• `git cherry-pick <hash>` — перенести конкретный коммит в текущую ветку
• `git revert <hash>` — создать НОВЫЙ коммит, отменяющий указанный (безопасно!)

📖 **Сборка мусора**:
• `git gc` — упаковать объекты, удалить недостижимые
• `.git/refs/heads/` — файлы веток, `.git/HEAD` — текущая ветка

📂 Рабочий каталог: `~/.ninja_trainer/git_012`

📋 **Попробуй**:
1. Посмотри последний коммит: `git cat-file -p HEAD`
2. Посмотри его tree: `git ls-tree HEAD`
3. Посмотри содержимое blob: `git cat-file -p <hash-из-tree>`
4. Посмотри reflog: `git reflog`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_012"
score=0

cd "$DIR" 2>/dev/null || exit 1

reflog_lines=$(git reflog 2>/dev/null | wc -l)
[ "$reflog_lines" -ge 1 ] 2>/dev/null && { echo "✓ Reflog работает ($reflog_lines записей)"; score=$((score+1)); }

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 2 ] 2>/dev/null && { echo "✓ $commits коммитов"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Внутренности Гита изучены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Посмотреть коммит: git cat-file -p HEAD
Тип объекта: git cat-file -t HEAD
Дерево коммита: git ls-tree HEAD
Содержимое blob: git cat-file -p abc123 (хеш из ls-tree)
Reflog: git reflog — все перемещения HEAD
Восстановление: git reset --hard HEAD@{2} — вернуться к записи из reflog
Cherry-pick: git cherry-pick abc123 — перенести коммит
Revert: git revert abc123 — безопасная отмена коммита
