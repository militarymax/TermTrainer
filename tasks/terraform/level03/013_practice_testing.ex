META
# Track: terraform
# Title: Проверка чертежей и автоматическая стройка
# Number: 013
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 35

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #013: Проверка чертежей и автоматическая стройка

Архиканцлер указал на автоматический механизм проверки:
«Ринсвинд! Каждый чертёж должен быть проверен ДО стройки!
terraform validate, tfsec, terraform plan — всё это должно
работать автоматически в CI. Напиши скрипт проверки и workflow!»

📋 **Задания**:

1. **Напиши `tf_check.sh`** — полная проверка:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   DIR="${1:-.}"
   echo "═══ Terraform Quality Gate ═══"
   
   echo "── Format Check ──"
   terraform -chdir="$DIR" fmt -check -diff 2>/dev/null && echo "✓ Formatted" || echo "⚠️ Run: terraform fmt"
   
   echo ""
   echo "── Validation ──"
   terraform -chdir="$DIR" validate 2>&1 | tail -3
   
   echo ""
   echo "── Security Scan ──"
   if command -v tfsec &>/dev/null; then
     tfsec "$DIR" --no-color 2>&1 | tail -5 || true
   else
     echo "(tfsec not installed: brew install tfsec)"
   fi
   
   echo ""
   echo "═══ End of Quality Gate ═══"
   ```

2. **Создай `.github/workflows/terraform.yml`**:
   ```yaml
   name: Terraform CI
   on: [push, pull_request]
   
   jobs:
     quality:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - uses: hashicorp/setup-terraform@v3
       - run: terraform fmt -check -recursive
       - run: terraform init -backend=false
       - run: terraform validate
       
     security:
       runs-on: ubuntu-latest
       needs: quality
       steps:
       - uses: actions/checkout@v4
       - uses: aquasecurity/tfsec-action@v1.0.0
   ```

3. Запусти: `chmod +x tf_check.sh && ./tf_check.sh $DIR`

📂 Рабочий каталог: `~/.ninja_trainer/terraform_013`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_013"
score=0

if [ -f "$DIR/tf_check.sh" ]; then
  chmod +x "$DIR/tf_check.sh"
  out=$(bash "$DIR/tf_check.sh" "$DIR" 2>&1)
  echo "$out" | grep -q "Quality\|Format\|Validat\|Security" && { echo "✓ tf_check.sh работает"; score=$((score+1)); }
fi

[ -f "$DIR/.github/workflows/terraform.yml" ] && grep -q "terraform\|fmt\|validate\|tfsec" "$DIR/.github/workflows/terraform.yml" && { echo "✓ CI workflow создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Тестирование TF освоено! (баллов: $score/2)"; exit 0; }
echo "✗ Создай tf_check.sh и workflow (баллов: $score/2)"
exit 1

HINTS
Fmt check: terraform fmt -check -diff — проверить форматирование
Validate: terraform validate — синтаксис и логика
Tfsec: сканирование безопасности .tf файлов
Setup terraform: hashicorp/setup-terraform@v3 — установить в CI
Backend=false: terraform init -backend=false — без подключения к облаку
Quality gate: fmt → validate → tfsec → plan — полный конвейер проверок
