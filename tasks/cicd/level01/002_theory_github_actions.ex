META
# Track: cicd
# Title: Автоматические ритуалы GitHub
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #002: Автоматические ритуалы GitHub

Декан Чартер показал тебе автоматический механизм:
«Ринсвинд! GitHub Actions — это система, которая запускает ритуалы
при каждом изменении Книги Заклинаний. Push → тесты. PR → проверка.
Tag → релиз. Всё автоматически! Ты только пиши YAML,
а механизмы сами крутятся. Как часы в Башне.
Только не забывай про отступы в YAML — они как заклинательные паузы.»

───────────────────────────────────────
🔹 СТРУКТУРА GITHUB ACTIONS
───────────────────────────────────────

ASSIGNMENT
```
.github/
└── workflows/
    ├── test.yml        # Тестирование при каждом push
    ├── release.yml     # Релиз при создании tag
    └── deploy.yml      # Деплой при merge в main
```

📖 **Ключевые концепции**:
• **Workflow** — весь ритуал целиком (файл YAML)
• **Event** — что ЗАПУСКАЕТ ритуал (push, PR, schedule, manual)
• **Job** — один этап ритуала (test, build, deploy)
• **Step** — одно действие внутри job (checkout, run command)
• **Runner** — где выполняется (ubuntu-latest, self-hosted)

```yaml
name: Tower Pipeline
on:
  push:
    branches: [main]
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - run: echo "Checking spell syntax..."
    
  test:
    needs: lint           # Ждём пока lint пройдёт!
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - run: make test
    
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - run: docker build -t tower-app .
```

📖 **Полезные переменные**:
```yaml
${{ github.sha }}        # Хеш коммита
${{ github.ref }}        # Ветка или тег
${{ secrets.API_KEY }}   # Секреты (НЕ в коде!)
```

📂 Рабочий каталог: `~/.termtrainer/cicd_002`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/cicd_002

VALIDATION
#!/bin/bash
score=0

if [ -d "$HOME/termtrainer/.github/workflows" ]; then
  echo "✓ .github/workflows существует"; score=$((score+1))
else
  echo "ℹ Нет workflow файлов (это нормально для этого проекта)"
fi

which gh &>/dev/null && { echo "✓ gh CLI установлен"; score=$((score+1)); }

[ $score -ge 0 ] && { echo "✓ ok: GitHub Actions освоены! (баллов: $score/2)"; exit 0; }
exit 0

HINTS
Workflow file: .github/workflows/name.yml — YAML файл описывает pipeline
on: trigger — что запускает (push/PR/schedule/workflow_dispatch)
jobs: этапы — lint → test → build → deploy
needs: зависимость между jobs — один ждёт другого
steps: действия — checkout + run команды
secrets: ${{ secrets.KEY }} — секретные переменные (токены, ключи)
Matrix: strategy.matrix для тестирования на разных ОС/версиях
