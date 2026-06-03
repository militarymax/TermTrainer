META
# Track: terraform
# Title: Мета-чертежи и принцип DRY
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 35

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #014: Мета-чертежи и принцип DRY

Архиканцлер показал тебе книгу над книгами:
«Ринсвинд! Terragrunt — это мета-чертёж! Он описывает КАК запускать
Terraform, а не только ЧТО создавать. DRY (Don't Repeat Yourself) —
не повторяй один и тот же backend конфиг в каждом модуле!
Terragrunt выносит общее в одно место.»

📋 **Задания**:

ASSIGNMENT
1. **Структура проекта с Terragrunt**:
   ```
   infra/
   ├── terragrunt.hcl           # Общий конфиг (backend, provider)
   ├── dev/
   │   └── terragrunt.hcl       # Параметры для dev
   ├── staging/
   │   └── terragrunt.hcl       # Параметры для staging
   └── production/
       └── terragrunt.hcl       # Параметры для production
   ```

2. **Корневой `terragrunt.hcl`**:
   ```hcl
   remote_state {
     backend = "s3"
     config = {
       bucket         = "tower-terraform-state"
       key            = "${path_relative_to_include()}/terraform.tfstate"
       region         = "eu-west-1"
       encrypt        = true
       dynamodb_table = "tower-terraform-locks"
     }
   }
   
   terraform {
     source = "../modules//infrastructure"
   }
   
   inputs = {
     environment = basename(get_terragrunt_dir())
   }
   ```

3. **Environment `dev/terragrunt.hcl`**:
   ```hcl
   include "root" {
     path = find_in_parent_folders()
   }
   
   inputs = {
     instance_type = "t3.micro"
     server_count  = 1
   }
   ```

4. **Напиши `tf_dry_check.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   echo "═══ Terraform DRY Audit ═══"
   echo ""
   echo "── Duplicate Resource Blocks ──"
   for type in resource data; do
     dupes=$(grep -rh "^${type}" . --include="*.tf" 2>/dev/null | sort | uniq -d)
     [ -n "$dupes" ] && echo "⚠️ Duplicates found:\n$dupes" || echo "✓ No duplicate ${type} blocks"
   done
   
   echo ""
   echo "── Hardcoded Values (should be variables) ──"
   grep -rh 'instance_type\s*=\s*"' . --include="*.tf" 2>/dev/null | grep -v variable | head -5 && echo "⚠️ Consider using variables!" || echo "✓ No hardcoded instance types"
   
   echo ""
   echo "═══ End of DRY Audit ═══"
   ```

📂 Рабочий каталог: `~/.termtrainer/terraform_014`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/terraform_014

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_014"
score=0

[ -f "$DIR/terragrunt.hcl" ] && { echo "✓ Корневой terragrunt.hcl создан"; score=$((score+1)); }

if [ -f "$DIR/tf_dry_check.sh" ]; then
  chmod +x "$DIR/tf_dry_check.sh"
  out=$(bash "$DIR/tf_dry_check.sh" 2>&1)
  echo "$out" | grep -q "DRY\|Duplicate\|Hardcoded" && { echo "✓ tf_dry_check.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Terragrunt и DRY освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай terragrunt.hcl и скрипт проверки (баллов: $score/2)"
exit 1

HINTS
Terragrunt: обёртка над Terraform для DRY конфигурации
Include: include "root" { path = find_in_parent_folders() } — наследовать общий конфиг
Remote state DRY: описать backend один раз в корневом terragrunt.hcl
Inputs: inputs = { env = basename(get_terragrunt_dir()) } — параметры по умолчанию
Source: terraform { source = "../modules//X" } — путь к модулю
DRY check: искать дублирующиеся блоки ресурсов и захардкоженные значения
