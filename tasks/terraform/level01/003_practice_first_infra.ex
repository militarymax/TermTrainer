META
# Track: terraform
# Title: Первый чертёж Башни
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 20
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #003: Первый чертёж Башни

Архиканцлер дал тебе перо и свиток:
«Ринсвинд! Нарисуй первый чертёж! Создай main.tf с провайдером,
ресурсом и переменными. Запусти init, plan, validate.
Даже если у тебя нет AWS — Terraform проверит синтаксис!
А если есть Docker — можно создать реальный контейнер!»

📋 **Задания**:

1. **Создай `main.tf`** (Docker provider — работает локально!):
   ```hcl
   terraform {
     required_providers {
       docker = {
         source  = "kreuzwerker/docker"
         version = "~> 3.0"
       }
     }
   }
   
   provider "docker" {}
   
   resource "docker_image" "nginx" {
     name = "nginx:latest"
   }
   
   resource "docker_container" "tower_web" {
     image = docker_image.nginx.image_id
     name  = "tower-web"
     ports {
       internal = 80
       external = 8080
     }
   }
   ```

2. **Запусти цикл Terraform**:
   ```bash
   cd $DIR
   terraform init          # Скачать Docker провайдер
   terraform validate     # Проверить синтаксис
   terraform plan          # Предпросмотр: что будет создано?
   terraform apply -auto-approve  # Строить!
   
   # Проверь:
   docker ps | grep tower-web
   curl http://localhost:8080
   
   # Разрушить:
   terraform destroy -auto-approve
   ```

📂 Рабочий каталог: `~/.ninja_trainer/terraform_003`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_003"
score=0

which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }

if [ -f "$DIR/main.tf" ]; then
  grep -q "provider\|resource\|terraform" "$DIR/main.tf" && { echo "✓ main.tf создан"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Первый чертёж освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Создай main.tf (баллов: $score/2)"
exit 1

HINTS
Terraform block: required_providers — указать версию провайдера
Provider config: provider "docker" {} — локальный Docker!
Resource: resource "TYPE" "NAME" { ... } — что создаём
Init: terraform init — скачать провайдеры
Validate: terraform validate — проверить синтаксис без подключения
Plan: terraform plan — что будет создано/изменено/удалено
Apply: terraform apply -auto-approve — применить без подтверждения
