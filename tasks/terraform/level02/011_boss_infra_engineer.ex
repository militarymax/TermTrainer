META
# Track: terraform
# Title: Экзамен Инженера Инфраструктуры
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/modules/tower-server"

TASK
🐉 БОСС #011: Экзамен Инженера Инфраструктуры

Архиканцлер вызвал тебя в Главный Зал:
«Ринсвинд! Создай модульную инфраструктуру с for_each,
workspaces, sensitive variables, security audit и .gitignore.
Всё по лучшим практикам!»

📋 **Боевые задания**:

1. **Модуль `modules/tower-server/`** с variables + outputs

2. **Корневой `main.tf`** — три сервера через for_each:
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
     source = "./modules/tower-server"
     for_each = local.servers
     
     name  = "${local.env}-${each.key}"
     image = each.value.image
     port  = each.value.port
   }
   ```

3. **`variables.tf`** — с sensitive переменной для API ключа

4. **`.gitignore`** — tfstate, .terraform/, *.tfvars

5. **`security_check.sh`** — аудит безопасности

6. **Запусти**: `terraform init && terraform fmt && terraform validate`

📂 Рабочий каталог: `~/.termtrainer/terraform_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_011"
score=0

[ -f "$DIR/main.tf" ] && grep -q "for_each\|module\|locals" "$DIR/main.tf" && { echo "✓ main.tf создан"; score=$((score+1)); }

[ -f "$DIR/modules/tower-server/main.tf" ] && { echo "✓ Модуль создан"; score=$((score+1)); }

[ -f "$DIR/.gitignore" ] && grep -q "tfstate\|tfvars" "$DIR/.gitignore" && { echo "✓ .gitignore создан"; score=$((score+1)); }

[ -f "$DIR/security_check.sh" ] && { echo "✓ security_check.sh создан"; score=$((score+1)); }

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Инженер! (баллов: $score/4)"; exit 0; }
echo "✗ Создай полную инфраструктуру (баллов: $score/4)"
exit 1

HINTS
Module with for_each: module "X" { for_each = map, source, ...each.key/value }
Locals: вычисляемые значения вместо повторения кода
Sensitive vars: variable "X" { sensitive = true } — скрыть секреты
.gitignore: tfstate + .terraform/ + tfvars — не коммитить!
Security check: grep hardcoded secrets и public access в .tf файлах
Fmt + validate: terraform fmt && terraform validate — проверить код
