META
# Track: terraform
# Title: Защита чертежей от тёмных сил
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #010: Защита чертежей от тёмных сил

Архиканцлер указал на трещину в защите:
«Ринсвинд! State содержит секреты в открытом виде!
Sensitive variables, encryption at rest, least privilege —
всё это нужно для защиты чертежей. И не забудь про tfsec —
он проверяет чертежи на уязвимости ещё ДО постройки!»

📋 **Задания**:

ASSIGNMENT
1. **Sensitive переменные**:
   ```hcl
   variable "db_password" {
     type      = string
     sensitive = true          # Не показывать в plan/output!
   }
   
   resource "aws_db_instance" "tower_db" {
     password = var.db_password    # В state будет зашифровано*
   }
   ```

2. **`.gitignore` для Terraform**:
   ```
   *.tfstate
   *.tfstate.*
   .terraform/
   .terraform.lock.hcl
   *.tfvars        # Может содержать секреты!
   crash.log
   ```

3. **tfsec — сканер безопасности**:
   ```bash
   brew install tfsec
   tfsec $DIR/       # Проверить все .tf файлы!
   ```

4. **checkov — альтернативный сканер**:
   ```bash
   pip install checkov
   checkov -d $DIR/
   ```

5. **Напиши `security_check.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   DIR="${1:-.}"
   echo "═══ Terraform Security Audit ═══"
   
   echo "── Sensitive Variables ──"
   grep -r "sensitive.*=.*true" "$DIR"/*.tf 2>/dev/null || echo "(none found)"
   
   echo ""
   echo "── Hardcoded Secrets ──"
   grep -riE "(password|secret|api_key)\s*=\s*\"[^\"]+\"" "$DIR"/*.tf 2>/dev/null && echo "⚠️ FOUND!" || echo "✓ None found"
   
   echo ""
   echo "── Public Resources ──"
   grep -r "0\.0\.0\.0/0" "$DIR"/*.tf 2>/dev/null && echo "⚠️ Wide open!" || echo "✓ No public access"
   
   echo ""
   echo "═══ End of Audit ═══"
   ```

📂 Рабочий каталог: `~/.termtrainer/terraform_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_010"
score=0

[ -f "$DIR/.gitignore" ] && grep -q "tfstate\|terraform\|tfvars" "$DIR/.gitignore" && { echo "✓ .gitignore создан"; score=$((score+1)); }

if [ -f "$DIR/security_check.sh" ]; then
  chmod +x "$DIR/security_check.sh"
  out=$(bash "$DIR/security_check.sh" "$DIR" 2>&1)
  echo "$out" | grep -q "Security\|Sensitive\|Secrets" && { echo "✓ security_check.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Безопасность TF освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Создай .gitignore и security_check.sh (баллов: $score/2)"
exit 1

HINTS
Sensitive: variable "X" { sensitive = true } — скрыть из output/plan
.gitignore: tfstate, .terraform/, tfvars — НЕ коммитить!
Tfsec: сканер безопасности для Terraform кода
Checkov: альтернативный сканер от Bridgecrew
Encryption at rest: шифровать remote state (S3 encrypt=true)
Least privilege: IAM роли с минимальными правами для terraform
No hardcoded secrets: использовать variables + vault для секретов
