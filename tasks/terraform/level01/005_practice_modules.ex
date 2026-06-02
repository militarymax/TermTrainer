META
# Track: terraform
# Title: Библиотека чертежей
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/modules/tower-server"

TASK
⚗️ ПРАКТИКУМ #005: Библиотека чертежей

Архиканцлер указал на полку с каталогом:
«Ринсвинд! Модули — это библиотека чертежей! Один раз написал —
используй много раз. Каждый модуль — как заклинание в книге:
вызвал с нужными параметрами и готово!
Не копируй код — используй модули!»

📋 **Задания**:

1. **Создай модуль `modules/tower-server/main.tf`**:
   ```hcl
   variable "name" {
     type = string
   }
   
   variable "image" {
     type    = string
     default = "nginx:latest"
   }
   
   variable "port" {
     type    = number
     default = 80
   }
   
   resource "docker_image" "app" {
     name = var.image
   }
   
   resource "docker_container" "app" {
     image = docker_image.app.image_id
     name  = var.name
     ports {
       internal = 80
       external = var.port
     }
   }
   
   output "container_name" {
     value = docker_container.app.name
   }
   
   output "container_port" {
     value = var.port
   }
   ```

2. **Используй модуль в `main.tf`**:
   ```hcl
   terraform {
     required_providers {
       docker = { source = "kreuzwerker/docker", version = "~> 3.0" }
     }
   }
   provider "docker" {}
   
   module "web_server" {
     source = "./modules/tower-server"
     name   = "tower-web"
     image  = "nginx:latest"
     port   = 8080
   }
   
   module "api_server" {
     source = "./modules/tower-server"
     name   = "tower-api"
     image  = "nginx:alpine"
     port   = 8081
   }
   ```

3. **Запусти**: `terraform init && terraform plan`

📂 Рабочий каталог: `~/.termtrainer/terraform_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_005"
score=0

[ -f "$DIR/modules/tower-server/main.tf" ] && { echo "✓ Модуль создан"; score=$((score+1)); }

[ -f "$DIR/main.tf" ] && grep -q "module\|source" "$DIR/main.tf" && { echo "✓ Module используется"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Модули освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Создай модуль и main.tf (баллов: $score/2)"
exit 1

HINTS
Module structure: modules/NAME/main.tf + variables.tf + outputs.tf
Module call: module "NAME" { source = "./modules/X", param = val }
Source local: ./modules/module-name — локальный модуль
Source remote: git::https://github.com/org/tf-module.git — из Git
Terraform registry: app.terraform.io — публичные модули
Module inputs: variables — параметры модуля
Module outputs: output — результаты модуля для использования снаружи
