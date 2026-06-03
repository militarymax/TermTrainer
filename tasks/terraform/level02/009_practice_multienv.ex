META
# Track: terraform
# Title: Башня в нескольких мирах
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #009: Башня в нескольких мирах

Архиканцлер указал на три одинаковых чертежа:
«Ринсвинд! Один код — три среды! Используй for_each для создания
разных серверов, workspaces для разделения state,
и locals для вычисляемых значений. Не дублируй код!»

📋 **Задания**:

ASSIGNMENT
1. **Создай `main.tf`** с for_each и locals:
   ```hcl
   terraform {
     required_providers {
       docker = { source = "kreuzwerker/docker", version = "~> 3.0" }
     }
   }
   provider "docker" {}
   
   locals {
     servers = {
       web = { image = "nginx:latest", port = 8080 }
       api = { image = "nginx:alpine", port = 8081 }
     }
     env_name = terraform.workspace
   }
   
   resource "docker_image" "server" {
     for_each = local.servers
     name     = each.value.image
   }
   
   resource "docker_container" "server" {
     for_each = local.servers
     image    = docker_image.server[each.key].image_id
     name     = "${local.env_name}-${each.key}"
     
     ports {
       internal = 80
       external = each.value.port
     }
   }
   ```

2. **Создай `outputs.tf`**:
   ```hcl
   output "containers" {
     value = { for k, v in docker_container.server : k => v.name }
   }
   
   output "environment" {
     value = local.env_name
   }
   ```

3. **Запусти с workspace**:
   ```bash
   terraform init
   terraform workspace new dev
   terraform plan
   ```

📂 Рабочий каталог: `~/.termtrainer/terraform_009`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/terraform_009

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_009"
score=0

[ -f "$DIR/main.tf" ] && grep -q "for_each\|locals\|workspace" "$DIR/main.tf" && { echo "✓ main.tf с for_each создан"; score=$((score+1)); }

[ -f "$DIR/outputs.tf" ] && grep -q "output\|for " "$DIR/outputs.tf" && { echo "✓ outputs.tf создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Multi-env Terraform освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Создай main.tf с for_each (баллов: $score/2)"
exit 1

HINTS
For_each: for_each = local.map → создать ресурс для каждого ключа
Locals: locals { key = value } — вычисляемые значения
Workspace: terraform.workspace — имя текущего окружения
Dynamic naming: "${local.env_name}-${each.key}" — уникальные имена
Output for: { for k, v in resource : k => v.attr } — map outputs
Count vs for_each: for_each безопаснее при удалении элементов из середины
