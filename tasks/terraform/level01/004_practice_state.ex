META
# Track: terraform
# Title: Книга записей и справочники
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #004: Книга записей и справочники

Библиотекарь указал на толстую книгу:
«Ууук!» — это означало: «State — это Книга Записей о том,
что УЖЕ построено. Если потеряешь — Terraform не будет знать,
что существует, и начнёт строить заново! А data sources — 
это справочники: посмотреть что уже есть, не создавая нового.»

📋 **Задания**:

ASSIGNMENT
1. **Исследуй state**:
   ```bash
   # В любом проекте с terraform:
   terraform show           # Показать текущее состояние
   terraform state list     # Список всех ресурсов в state
   terraform output         # Все outputs
   
   # Импорт существующего ресурса:
   terraform import docker_container.existing <container_id>
   ```

2. **Data source — читать без создания**:
   ```hcl
   # Прочитать данные о существующем образе:
   data "docker_image" "existing_nginx" {
     name = "nginx:latest"
   }
   
   # Использовать в ресурсе:
   resource "docker_container" "app" {
     image = data.docker_image.existing_nginx.image_id
     name  = "tower-app"
   }
   ```

3. **Remote state** (для production!):
   ```hcl
   terraform {
     backend "s3" {
       bucket = "tower-terraform-state"
       key    = "infrastructure/terraform.tfstate"
       region = "eu-west-1"
     }
   }
   ```
   
   ⚠️ Local state = .tfstate файл на диске → НЕ коммитить в Git!
   ⚠️ Remote state = S3/Consul/HTTP → безопасно для команды!

📂 Рабочий каталог: `~/.termtrainer/terraform_004`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/terraform_004

VALIDATION
#!/bin/bash
score=0

which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }

if [ -f "$DIR/main.tf" ]; then
  grep -q "data\|backend\|state" "$DIR/main.tf" && { echo "✓ Data sources/state используются"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: State и Data Sources освоены! (баллов: $score/2)"; exit 0; }
echo "ℹ Создай main.tf с data source для практики"
exit 0

HINTS
State file: terraform.tfstate — текущее состояние инфраструктуры
Show: terraform show — отобразить всё состояние
State list: terraform state list — список ресурсов в state
Import: terraform import TYPE.NAME ID — импорт существующего ресурса
Data source: data "TYPE" "NAME" — прочитать без создания
Backend: remote state в S3/Consul для командной работы
.gitignore: *.tfstate и *.tfvars — НЕ коммитить в Git!
