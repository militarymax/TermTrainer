META
# Track: terraform
# Title: GitOps для чертежей
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #015: GitOps для чертежей

Архиканцлер указал на автоматический механизм:
«Ринсвинд! Atlantis — это демон, который автоматически запускает
terraform plan при каждом PR и показывает результат прямо в комментах!
А при merge — автоматически применяет! Это GitOps для Terraform:
Книга Заклинаний (Git) → автоматическая стройка!»

📋 **Задания**:

1. **Настройка Atlantis** (концептуально):
   ```yaml
   # atlantis.yaml — конфиг в корне репо
   version: 3
   projects:
   - name: infrastructure
     dir: infra/
     terraform_version: "1.7"
     autoplan:
       when_modified: ["*.tf", "*.tfvars"]
       enabled: true
     apply_requirements:
       - approved          # Нужен approval перед apply!
   ```

2. **Напиши `tf_gitops_check.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   echo "═══ Terraform GitOps Audit ═══"
   
   echo ""
   echo "── Changed Files ──"
   git diff --name-only HEAD~1 2>/dev/null | grep '\.tf$' || echo "(no .tf changes)"
   
   echo ""
   echo "── Plan Summary ──"
   if [ -d ".terraform" ] || [ -f "terraform.tfstate" ]; then
     terraform plan -detailed-exitcode 2>&1 | tail -5 || true
   else
     echo "(terraform not initialized in this dir)"
   fi
   
   echo ""
   echo "── Drift Detection ──"
   echo "Compare desired state (git) vs actual state (cloud):"
   echo "  terraform plan -detailed-exitcode"
   echo "  Exit code 0 = no changes, 2 = drift detected!"
   
   echo ""
   echo "═══ End of GitOps Audit ═══"
   ```

3. **Создай `.github/workflows/tf-plan.yml`**:
   ```yaml
   name: Terraform Plan
   on: [pull_request]
   
   jobs:
     plan:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - uses: hashicorp/setup-terraform@v3
       - run: terraform init -backend=false
       - run: terraform plan -no-color 2>&1 | tee plan_output.txt
       - uses: actions/github-script@v7
         with:
           script: |
             const fs = require('fs');
             const plan = fs.readFileSync('plan_output.txt', 'utf8');
             github.rest.issues.createComment({
               ...context.repo,
               issue_number: context.issue.number,
               body: '## Terraform Plan\n```\n' + plan + '\n```'
             });
   ```

📂 Рабочий каталог: `~/.termtrainer/terraform_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_015"
score=0

if [ -f "$DIR/tf_gitops_check.sh" ]; then
  chmod +x "$DIR/tf_gitops_check.sh"
  out=$(bash "$DIR/tf_gitops_check.sh" 2>&1)
  echo "$out" | grep -q "GitOps\|Changed\|Plan\|Drift" && { echo "✓ tf_gitops_check.sh работает"; score=$((score+1)); }
fi

[ -f "$DIR/.github/workflows/tf-plan.yml" ] && grep -q "terraform\|plan\|comment" "$DIR/.github/workflows/tf-plan.yml" && { echo "✓ CI workflow создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: GitOps для TF освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Создай скрипт и workflow (баллов: $score/2)"
exit 1

HINTS
Atlantis: автоматический terraform plan/apply по PR
Atlantis config: atlantis.yaml — какие проекты, когда планировать, approval
Autoplan: when_modified: ["*.tf"] — запускать plan при изменении .tf файлов
Apply requirements: approved — нужен аппрув перед apply
Drift detection: terraform plan -detailed-exitcode → exit code 2 = drift!
PR comment: GitHub Action публикует план как комментарий к PR
