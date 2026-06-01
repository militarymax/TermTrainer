META
# Track: terraform
# Title: Экзамен Архитектора
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/modules/tower-server"

TASK
🐉 БОСС #006: Экзамен Архитектора

Архиканцлер вызвал тебя в кабинет:
«Ринсвинд! Создай полную инфраструктуру Башни с модулями!
Два сервера через один модуль, переменные для конфигурации,
outputs для результатов. И всё это с terraform validate!»

📋 **Боевые задания**:

1. **Модуль `modules/tower-server/`**:
   - `main.tf` — docker_container + docker_image
   - `variables.tf` — name, image, port (с defaults)
   - `outputs.tf` — container_name, container_port

2. **Корневой `main.tf`** — два экземпляра:
   ```hcl
   module "web" {
     source = "./modules/tower-server"
     name   = "tower-web"
     port   = 8080
   }
   
   module "api" {
     source = "./modules/tower-server"
     name   = "tower-api"
     image  = "nginx:alpine"
     port   = 8081
   }
   ```

3. **`variables.tf`** — environment variable

4. **`outputs.tf`** — web_port, api_port из модулей

5. **Запусти**: `terraform init && terraform fmt && terraform validate`

📂 Рабочий каталог: `~/.ninja_trainer/terraform_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_006"
score=0

[ -f "$DIR/main.tf" ] && grep -q "module\|provider\|terraform" "$DIR/main.tf" && { echo "✓ main.tf создан"; score=$((score+1)); }

[ -f "$DIR/modules/tower-server/main.tf" ] && { echo "✓ Модуль создан"; score=$((score+1)); }

[ -f "$DIR/outputs.tf" ] || [ -f "$DIR/variables.tf" ] && { echo "✓ Variables/outputs созданы"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Архитектор! (баллов: $score/3)"; exit 0; }
echo "✗ Создай полную инфраструктуру (баллов: $score/3)"
exit 1

HINTS
Module structure: main.tf + variables.tf + outputs.tf в modules/NAME/
Module call: module "X" { source, name, image, port }
Root outputs: output "web_port" { value = module.web.container_port }
Fmt: terraform fmt — автоформатирование всех .tf файлов
Validate: terraform validate — проверить синтаксис всей конфигурации
