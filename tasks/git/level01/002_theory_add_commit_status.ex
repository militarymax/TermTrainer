META
# Track: git
# Title: Первые заклинания Гита
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"

TASK
📜 **Первые заклинания Гита**

Контракт подписан — репозиторий создан. Теперь нужно научиться сохранять изменения. Гит запоминает каждый снимок состояния (коммит), и ты всегда можешь вернуться в прошлое.

📖 **Основной цикл**:
• `git status` — что изменилось? (untracked / modified / staged)
• `git add <file>` — добавить файл в staging area
• `git add .` — добавить ВСЕ изменения в текущем каталоге
• `git commit -m "message"` — сохранить снимок с сообщением

📖 **Просмотр изменений**:
• `git diff` — неподготовленные изменения (рабочий каталог vs staging)
• `git diff --staged` — подготовленные изменения (staging vs последний коммит)
• `git log` — история коммитов
• `git log --oneline` — краткая история (одна строка на коммит)

📖 **Хорошие сообщения коммитов**:
• Краткие и понятные: `feat: add login page`, `fix: correct calculation`
• Не: `update`, `changes`, `asdf`
• Используй императив: "add feature", не "added feature"

📂 Рабочий каталог: `~/.ninja_trainer/git_002`

📋 **Попробуй**:
1. Создай файл `свиток.txt` с любым текстом
2. Проверь `git status` — увидишь untracked file
3. Выполни `git add свиток.txt`
4. Проверь `git status` — увидишь "new file" в staging
5. Выполни `git commit -m "feat: add first scroll"`
6. Посмотри `git log`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/git_002"
score=0

cd "$DIR" 2>/dev/null || exit 1

commits=$(git rev-list --count HEAD 2>/dev/null)
if [ "$commits" -ge 1 ] 2>/dev/null; then
  echo "✓ Есть минимум $commits коммит(ов)"
  score=$((score+1))
fi

if [ -f "$DIR/свиток.txt" ]; then
  echo "✓ свиток.txt существует"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Первые заклинания освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай файл, добавь и закоммить (баллов: $score/2)"
exit 1

HINTS
Создать файл: echo "Мой первый свиток" > ~/.ninja_trainer/git_002/свиток.txt
Статус: cd ~/.ninja_trainer/git_002 && git status
Добавить: git add свиток.txt или git add .
Закоммитить: git commit -m "feat: add first scroll"
История: git log или git log --oneline
Разница: git diff — до add; git diff --staged — после add, до commit
