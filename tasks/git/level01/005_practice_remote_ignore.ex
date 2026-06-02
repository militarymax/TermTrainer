META
# Track: git
# Title: Дальняя связь и щиты игнора
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_005"
rm -rf "$DIR" "$DIR-remote" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "Архив Университета" > README.md && git add . && git commit -m "feat: initial commit"

TASK
🌐 **Дальняя связь и щиты игнора**

Архивы нужно не только хранить локально, но и отправлять в удалённые хранилища. А некоторые файлы — секретные, их Гит не должен видеть.

ASSIGNMENT
📋 **Задания**:
1. Создай `.gitignore` с правилами:
   - `*.tmp` — временные файлы
   - `секреты/` — каталог секретов
   - `.env` — переменные окружения
2. Закоммить `.gitignore`
3. Создай файл `данные.tmp`, каталог `секреты/` с файлом внутри, и `.env`
4. Проверь `git status` — эти файлы НЕ должны появиться как untracked
5. Добавь remote (локальный для практики): `git remote add origin /tmp/git_remote_005.git`
6. Проверь: `git remote -v`

📖 **Удалённые репозитории**:
• `git remote add origin <url>` — привязать удалённый репо
• `git push origin main` — отправить коммиты
• `git pull` — забрать изменения (fetch + merge)
• `git clone <url>` — скачать репозиторий

📂 Рабочий каталог: `~/.termtrainer/git_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_005"
score=0

cd "$DIR" 2>/dev/null || exit 1

if [ -f ".gitignore" ]; then
  echo "✓ .gitignore создан"
  score=$((score+1))
  if grep -q '.tmp' .gitignore && grep -q 'секреты' .gitignore; then
    echo "✓ Правила игнорирования корректны"
    score=$((score+1))
  fi
fi

remotes=$(git remote 2>/dev/null)
if [ -n "$remotes" ]; then
  echo "✓ Remote настроен: $remotes"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Дальняя связь установлена! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Создать .gitignore: cat > .gitignore << 'EOF'
*.tmp
секреты/
.env
EOF
Добавить remote: git remote add origin /tmp/git_remote_005.git
Проверить remote: git remote -v
Проверить игнорирование: git status — .tmp, секреты/, .env не видны
Push: git push origin main (если remote существует)
Pull: git pull origin main
