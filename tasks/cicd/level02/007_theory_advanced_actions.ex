META
# Track: cicd
# Title: Продвинутые ритуалы и артефакты
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #007: Продвинутые ритуалы и артефакты

Библиотекарь открыл секцию Запрещённых Свитков:
«Ууук!» — это означало: «Matrix-стратегии для тестирования на разных
версиях. Артефакты для передачи данных между jobs. Кэширование
для ускорения сборки. И Reusable Workflows — заклинания,
которые можно вызывать из других заклинаний!»

───────────────────────────────────────
🔹 MATRIX — ТЕСТИРОВАНИЕ НА ВСЕХ ВЕРСИЯХ
───────────────────────────────────────

```yaml
jobs:
  test:
    strategy:
      matrix:
        go-version: ['1.21', '1.22']
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
    - run: echo "Testing Go ${{ matrix.go-version }} on ${{ matrix.os }}"
```

───────────────────────────────────────
🔹 АРТЕФАКТЫ — ПЕРЕДАЧА МЕЖДУ JOBS
───────────────────────────────────────

```yaml
# Сохранить артефакт:
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: ./dist/

# Скачать в другом job:
- uses: actions/download-artifact@v4
  with:
    name: build-output
```

───────────────────────────────────────
🔹 КЭШИРОВАНИЕ — УСКОРЕНИЕ СБОРКИ
───────────────────────────────────────

```yaml
- uses: actions/cache@v3
  with:
    path: ~/go/pkg/mod
    key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
```

───────────────────────────────────────
🔹 REUSABLE WORKFLOWS
───────────────────────────────────────

ASSIGNMENT
```yaml
# Вызвать другой workflow как функцию:
jobs:
  call-test:
    uses: ./.github/workflows/test.yml
```

📂 Рабочий каталог: `~/.termtrainer/cicd_007`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/cicd_007

VALIDATION
#!/bin/bash
score=0
which gh &>/dev/null && { echo "✓ gh CLI установлен"; score=$((score+1)); }
[ $score -ge 0 ] && { echo "✓ ok: Продвинутые Actions освоены!"; exit 0; }
exit 0

HINTS
Matrix: strategy.matrix — параллельное тестирование разных версий/ОС
Artifacts: upload-artifact/download-artifact — передача файлов между jobs
Cache: actions/cache — кэширование зависимостей для ускорения сборки
Reusable workflows: uses: ./.github/workflows/other.yml — вызов как функции
Environment files: $GITHUB_ENV, $GITHUB_OUTPUT — передача данных между шагами
Conditional steps: if: contains(github.ref, 'release') — условное выполнение
Timeout: timeout-minutes: N — ограничение времени выполнения job
