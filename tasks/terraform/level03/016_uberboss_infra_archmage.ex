META
# Track: terraform
# Title: Архимаг Инфраструктуры
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/modules/tower-server"

TASK
👑 UBERBOSS #016: Архимаг Инфраструктуры

Архиканцлер стоял на вершине Башни, ветер развевал его мантию:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Создай production-ready инфраструктуру
с модулями, for_each, workspaces, security, CI pipeline и GitOps.
Используй ВСЁ: modules, moved, import, tfsec, terragrunt.
Если справишься — ты Архимаг Инфраструктуры.
Если нет... знаешь того кактуса?»

📋 **БЛОК 1 — Модульная инфраструктура**:

Создай `modules/tower-server/` с:
- `main.tf` — docker_container + docker_image + healthcheck
- `variables.tf` — name, image, port (с defaults и validation)
- `outputs.tf` — container_name, container_port

📋 **БЛОК 2 — Корневой конфиг с for_each**:

```hcl
locals {
  servers = {
    web   = { image = "nginx:latest", port = 8080 }
    api   = { image = "nginx:alpine", port = 8081 }
    admin = { image = "nginx:alpine", port = 8082 }
  }
  env = terraform.workspace
}

module "server" {
  source   = "./modules/tower-server"
  for_each = local.servers
  
  name  = "${local.env}-${each.key}"
  image = each.value.image
  port  = each.value.port
}
```

📋 **БЛОК 3 — Безопасность**:

- `variables.tf` с sensitive переменной для API ключа
- `.gitignore` для tfstate/.terraform/tfvars
- `security_check.sh` — аудит hardcoded secrets

📋 **БЛОК 4 — CI Pipeline**:

`.github/workflows/terraform.yml`:
- terraform fmt -check
- terraform validate
- tfsec scan
- terraform plan (на PR)

📋 **БЛОК 5 — Quality Gate Script**:

Напиши `$DIR/tf_quality_gate.sh`:
```bash
#!/bin/bash
set -euo pipefail
echo "═══ Terraform Quality Gate ═══"
echo "── Format ──"; terraform fmt -check -recursive
echo "── Validate ──"; terraform init -backend=false && terraform validate
echo "── Security ──"; command -v tfsec &>/dev/null && tfsec . || echo "(tfsec not installed)"
echo "═══ Gate Complete ═══"
```

ASSIGNMENT

📂 Рабочий каталог: `~/.termtrainer/terraform_016`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/terraform_016

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_016"
score=0
max=5

[ -f "$DIR/main.tf" ] && grep -q "for_each\|module\|locals" "$DIR/main.tf" && { echo "✓ main.tf создан"; score=$((score+1)); }

[ -f "$DIR/modules/tower-server/main.tf" ] && { echo "✓ Модуль создан"; score=$((score+1)); }

[ -f "$DIR/.gitignore" ] && grep -q "tfstate\|tfvars\|terraform" "$DIR/.gitignore" && { echo "✓ .gitignore создан"; score=$((score+1)); }

[ -f "$DIR/security_check.sh" ] || [ -f "$DIR/tf_quality_gate.sh" ] && { echo "✓ Скрипт проверки создан"; score=$((score+1)); }

[ -f "$DIR/.github/workflows/terraform.yml" ] && { echo "✓ CI workflow создан"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 3 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Module with validation: variable with type + default + validation block

=== БЛОК 2 ===
For_each + locals: один модуль → много экземпляров через map

=== БЛОК 3 ===
Security: sensitive vars + .gitignore + audit script

=== БЛОК 4 ===
CI pipeline: fmt → validate → tfsec → plan на каждый PR

=== БЛОК 5 ===
Quality gate script: автоматическая проверка перед apply
