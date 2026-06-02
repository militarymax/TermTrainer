META
# Track: git
# Title: Автоматические стражи
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив Университета" > README.md && git add . && git commit -m "feat: initial"

TASK
🤖 **Автоматические стражи**

Хуки — это скрипты, которые автоматически запускаются при определённых событиях Git. Они как стражники у ворот Башни — проверяют каждого входящего и выходящего.

📋 **Задания**:
1. Создай `pre-commit` хук:
   - Файл: `.git/hooks/pre-commit`
   - Проверяет: если в коммите есть файлы с расширением `.secret` — отклонить!
   - Выводит: `ERROR: .secret files are forbidden!`
   - Не забудь `chmod +x .git/hooks/pre-commit`

2. Создай `commit-msg` хук:
   - Файл: `.git/hooks/commit-msg`
   - Проверяет: сообщение коммита должно начинаться с `feat:`, `fix:`, `docs:` или `chore:`
   - Если нет — вывести ошибку и выйти с кодом 1
   - Подсказка: сообщение находится в файле, путь к которому передан как `$1`

3. Протестируй:
   - Попробуй закоммитить `.secret` файл — должно быть отказано
   - Попробуй закоммитить с плохим сообщением — должно быть отказано
   - Закоммить нормальный файл с хорошим сообщением — должно пройти

📖 **Типы клиентских хуков**:
• `pre-commit` — перед созданием коммита (проверки кода)
• `commit-msg` — проверка сообщения коммита
• `pre-push` — перед push (запуск тестов)
• `post-merge` — после merge (установка зависимостей)
• `prepare-commit-msg` — подготовка сообщения (шаблон)

📂 Рабочий каталог: `~/.termtrainer/git_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_014"
score=0

if [ -f "$DIR/.git/hooks/pre-commit" ]; then
  echo "✓ pre-commit хук существует"
  score=$((score+1))
  [ -x "$DIR/.git/hooks/pre-commit" ] && { echo "✓ pre-commit исполняемый"; score=$((score+1)); }
fi

if [ -f "$DIR/.git/hooks/commit-msg" ]; then
  echo "✓ commit-msg хук существует"
  score=$((score+1))
  [ -x "$DIR/.git/hooks/commit-msg" ] && { echo "✓ commit-msg исполняемый"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: Автоматические стражи установлены! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Pre-commit хук: cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
if git diff --cached --name-only | grep -q '\.secret$'; then
    echo "ERROR: .secret files are forbidden!"
    exit 1
fi
EOF
chmod +x .git/hooks/pre-commit

Commit-msg хук: cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
msg=$(cat "$1")
if ! echo "$msg" | grep -qE '^(feat|fix|docs|chore):'; then
    echo "ERROR: Message must start with feat:/fix:/docs:/chore:"
    exit 1
fi
EOF
chmod +x .git/hooks/commit-msg

Пропустить хуки: git commit --no-verify -m "emergency fix"
