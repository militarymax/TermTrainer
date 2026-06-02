META
# Track: terraform
# Title: Чертёж Башни
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #001: Чертёж Башни

Архиканцлер развернул на столе огромный свиток:
«Ринсвинд! Terraform — это Чертёж Башни. Ты описываешь в коде,
КАКАЯ башня тебе нужна, а Terraform САМ строит её.
Не нужно вручную класть каждый камень — просто опписывай!
HCL (HashiCorp Configuration Language) — язык чертежей.
Infrastructure as Code — инфраструктура как код!»

───────────────────────────────────────
🔹 ОСНОВЫ HCL
───────────────────────────────────────

```hcl
# provider — кто будет строить?
provider "aws" {
  region = "eu-west-1"
}

# resource — что строим?
resource "aws_instance" "tower_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "TowerServer"
  }
}
```

📖 **Ключевые концепции**:
• **Provider** — строитель (AWS, GCP, Azure, Docker, Kubernetes...)
• **Resource** — что создаём (сервер, сеть, база данных...)
• **State** — что УЖЕ построено (terraform.tfstate)
• **Plan** — что ИЗМЕНИТСЯ (предварительный просмотр)
• **Apply** — СТРОИТЬ!

───────────────────────────────────────
🔹 ЖИЗНЕННЫЙ ЦИКЛ TERRAFORM
───────────────────────────────────────

```bash
terraform init      # Скачать провайдеры и модули
terraform plan      # Предпросмотр изменений
terraform apply     # Применить изменения (строить!)
terraform destroy   # Разрушить всё!
terraform fmt       # Отформатировать код
terraform validate  # Проверить синтаксис
```

⚠️ **НИКОГДА не редактируй .tfstate вручную!**

📂 Рабочий каталог: `~/.termtrainer/terraform_001`

📋 **Попробуй**:
1. `which terraform && terraform version`
2. Создай `main.tf` с простым провайдером и запусти `terraform init`

VALIDATION
#!/bin/bash
score=0

which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }

if which terraform &>/dev/null; then
  ver=$(terraform version 2>/dev/null | head -1)
  [ -n "$ver" ] && { echo "✓ $ver"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Основы Terraform освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Установи terraform: brew install terraform"
exit 1

HINTS
Provider: строитель инфраструктуры (AWS/GCP/Azure/Docker/K8s)
Resource: ресурс для создания (instance/vpc/database)
Init: скачать провайдеры → terraform init
Plan: предпросмотр изменений → terraform plan
Apply: применить изменения → terraform apply
Destroy: разрушить всё → terraform destroy
State: terraform.tfstate — текущее состояние инфраструктуры
