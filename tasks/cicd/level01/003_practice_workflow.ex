META
# Track: cicd
# Title: Свой первый ритуал
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 20
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
⚗️ ПРАКТИКУМ #003: Свой первый ритуал

Архиканцлер дал тебе пустой свиток:
«Ринсвинд! Напиши свой первый workflow! При каждом push в main —
запускай тесты. При создании tag — собирай релиз.
И не забудь про секреты — пароли в коде НЕ храним!
Как в прошлый раз, когда весь кластер узнал твой API-ключ...»

📋 **Задания**:

ASSIGNMENT
1. **Создай `.github/workflows/test.yml`**:
   ```yaml
   name: Spell Tests
   on:
     push:
       branches: [main]
     pull_request:
   
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - name: Run tests
         run: |
           echo "🧪 Testing spells..."
           echo "✓ All spells valid!"
   ```

2. **Создай `.github/workflows/release.yml`**:
   ```yaml
   name: Release Spell
   on:
     push:
       tags: ['v*']
   
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - name: Build release
         run: echo "📦 Building release ${{ github.ref_name }}"
   ```

3. **Проверь YAML на валидность**: `cat .github/workflows/test.yml`

📂 Рабочий каталог: `~/.termtrainer/cicd_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_003"
score=0

if [ -f "$DIR/.github/workflows/test.yml" ]; then
  grep -q "on:\|jobs:\|steps:" "$DIR/.github/workflows/test.yml" && { echo "✓ test.yml создан"; score=$((score+1)); }
fi

if [ -f "$DIR/.github/workflows/release.yml" ]; then
  grep -q "tags:\|release\|build" "$DIR/.github/workflows/release.yml" && { echo "✓ release.yml создан"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Workflow создан! (баллов: $score/2)"; exit 0; }
echo "✗ Создай workflow файлы (баллов: $score/2)"
exit 1

HINTS
Workflow location: .github/workflows/name.yml
On push: triggers при push в указанные ветки
On tags: push tags ['v*'] — триггер по семантическим тегам
Jobs/steps: job содержит несколько step (checkout + run)
Actions marketplace: uses: actions/checkout@v4 — готовые действия
Secrets: ${{ secrets.KEY }} — безопасное использование ключей
