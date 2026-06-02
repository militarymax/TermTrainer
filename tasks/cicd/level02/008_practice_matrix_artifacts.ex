META
# Track: cicd
# Title: Матрица заклинаний и артефакты
# Number: 008
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
⚗️ ПРАКТИКУМ #008: Матрица заклинаний и артефакты

Библиотекарь дал тебе задание:
«Ууук!» — что на языке Библиотекаря означало: «Напиши workflow,
который тестирует на нескольких версиях Go, собирает бинарник,
сохраняет его как артефакт и кэширует зависимости!»

📋 **Задания**:

1. **Создай `.github/workflows/build.yml`** с matrix + artifacts + cache:
   ```yaml
   name: Tower Build Matrix
   on: [push, pull_request]
   
   jobs:
     test:
       strategy:
         matrix:
           go-version: ['1.21', '1.22']
           os: [ubuntu-latest]
       runs-on: ${{ matrix.os }}
       steps:
       - uses: actions/checkout@v4
       - uses: actions/setup-go@v5
         with:
           go-version: ${{ matrix.go-version }}
       - uses: actions/cache@v3
         with:
           path: ~/go/pkg/mod
           key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
       - run: go test ./...
     
     build:
       needs: test
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - uses: actions/setup-go@v5
         with:
           go-version: '1.22'
       - run: go build -o tower-app .
       - uses: actions/upload-artifact@v4
         with:
           name: tower-binary
           path: ./tower-app
   ```

📂 Рабочий каталог: `~/.termtrainer/cicd_008`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_008"
score=0

[ -f "$DIR/.github/workflows/build.yml" ] && grep -q "matrix\|artifact\|cache" "$DIR/.github/workflows/build.yml" && { echo "✓ build.yml создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Matrix и артефакты освоены! (баллов: $score/1)"; exit 0; }
echo "✗ Создай build.yml (баллов: $score/1)"
exit 1

HINTS
Matrix: strategy.matrix.go-version — тестировать на разных версиях
Setup Go: actions/setup-go@v5 — установить нужную версию Go
Cache: actions/cache с key по hashFiles — ускорить загрузку зависимостей
Upload artifact: actions/upload-artifact@v4 — сохранить результат сборки
Download artifact: actions/download-artifact@v4 — получить в другом job
Needs: needs: test — запустить build только после успешных тестов
