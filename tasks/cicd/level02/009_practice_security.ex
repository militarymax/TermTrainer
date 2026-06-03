META
# Track: cicd
# Title: Защита заклинаний от тёмных сил
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
⚗️ ПРАКТИКУМ #009: Защита заклинаний от тёмных сил

Архиканцлер указал на трещину в защите:
«Ринсвинд! Кто-то утёк секрет! В конвейере НЕЛЬЗЯ хранить пароли
в открытом виде. GitHub Secrets, переменные окружения,
сканирование образов на уязвимости — всё это нужно!
Иначе любой тёмный маг украдёт ключи от Башни.»

📋 **Задания**:

ASSIGNMENT
1. **Создай `.github/workflows/security.yml`**:
   ```yaml
   name: Security Scan
   on:
     push:
       branches: [main]
     schedule:
       - cron: '0 6 * * 1'    # Каждый понедельник в 6:00
   
   jobs:
     trivy-scan:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - name: Run Trivy vulnerability scanner
         uses: aquasecurity/trivy-action@master
         with:
           scan-type: 'fs'
           scan-ref: '.'
           severity: 'CRITICAL,HIGH'
     
     secret-scan:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - name: Check for leaked secrets
         uses: gitleaks/gitleaks-action@v2
           env:
             GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
   ```

2. **Напиши `.gitignore`** для секретов:
   ```
   .env
   *.key
   *.pem
   secrets/
   ```

3. **Проверь что секреты не утекли**:
   ```bash
   git log --all --full-history -- '*.env' '*.key' '*secret*'
   ```

📂 Рабочий каталог: `~/.termtrainer/cicd_009`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/cicd_009

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_009"
score=0

[ -f "$DIR/.github/workflows/security.yml" ] && grep -q "trivy\|secret\|scan\|security" "$DIR/.github/workflows/security.yml" && { echo "✓ security.yml создан"; score=$((score+1)); }

[ -f "$DIR/.gitignore" ] && grep -q "env\|key\|secret" "$DIR/.gitignore" && { echo "✓ .gitignore создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Безопасность CI/CD освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Создай security workflow и .gitignore (баллов: $score/2)"
exit 1

HINTS
Trivy: сканирование Docker-образов и ФС на уязвимости (CRITICAL/HIGH)
Gitleaks: поиск утёкших секретов в истории коммитов
GitHub Secrets: Settings → Secrets → New — хранить ключи безопасно
.gitignore: исключить .env, *.key, *.pem из репозитория
Schedule: cron: '0 6 * * 1' — регулярное сканирование по расписанию
Severity filter: CRITICAL,HIGH — только критичные уязвимости
