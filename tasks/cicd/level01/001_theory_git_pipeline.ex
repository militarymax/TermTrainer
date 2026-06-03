META
# Track: cicd
# Title: Книга Заклинаний и Конвейер
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #001: Книга Заклинаний и Конвейер

Архиканцлер подвёл тебя к длинному столу, уставленному свитками:
«Ринсвинд! Каждый маг должен вести Книгу Заклинаний — Git.
Каждое изменение записывается, каждое заклинание версонируется.
А Конвейер (Pipeline) — это автоматическая система, которая
проверяет, собирает и развёртывает твои заклинания без ручного труда.
Последний раз, когда мы делали это вручную... Башня горела три дня.»

───────────────────────────────────────
🔹 GIT — КНИГА ЗАКЛИНАНИЙ С ВЕРСИЯМИ
───────────────────────────────────────

```bash
git init                          # Создать новую книгу
git clone <url>                   # Скопировать чужую книгу
git add .                         # Подготовить все изменения
git commit -m "feat: new spell"   # Записать версию!
git push origin main              # Отправить в Хранилище
git pull                          # Получить обновления от других

# Ветвление — параллельные книги:
git branch feature/fireball       # Новая ветка заклинаний
git checkout feature/fireball     # Переключиться
git merge main                    # Объединить с основной книгой
```

📖 **Коммиты-сообщения**: `feat:` / `fix:` / `docs:` / `ci:` — Convention!

───────────────────────────────────────
🔹 CI/CD — КОНВЕЙЕР АВТОМАЦИИ
───────────────────────────────────────

📖 **CI (Continuous Integration)**: каждый коммит → автосборка + тесты
📖 **CD (Continuous Delivery)**: после CI → автодеплой на staging/production

```yaml
# .github/workflows/spell-check.yml — пример GitHub Actions
name: Spell Check Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run tests
      run: |
        echo "Testing spells..."
        make test
```

📂 Рабочий каталог: `~/.termtrainer/cicd_001`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/cicd_001
📋 **Попробуй**:
1. `git log --oneline | head -5` — история коммитов этого проекта
2. `git branch -a` — все ветки

VALIDATION
#!/bin/bash
score=0

which git &>/dev/null && { echo "✓ git установлен"; score=$((score+1)); }

log=$(git -C $HOME/termtrainer log --oneline 2>/dev/null | head -3)
[ -n "$log" ] && { echo "✓ Git работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Git и CI/CD основы освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Git init: создать новый репозиторий
Git add+commit: подготовить и зафиксировать изменения
Git branch: параллельная разработка без влияния на main
CI: Continuous Integration — автосборка и тесты при каждом коммите
CD: Continuous Delivery — автодеплой после успешных тестов
GitHub Actions: YAML файл в .github/workflows/ описывает pipeline
Pipeline stages: lint → test → build → deploy — типичные этапы
