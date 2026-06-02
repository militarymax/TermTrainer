META
# Track: terraform
# Title: Параметры чертежа и выходы
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #002: Параметры чертежа и выходы

Декан Чартер показал тебе свиток с пустыми полями:
«Ринсвинд! Variables — это параметры чертежа. Один чертёж,
но разные значения для dev/staging/production.
Outputs — это то, что Башня сообщает после постройки:
IP-адрес, DNS-имя, ID ресурса. Без outputs ты не найдёшь
собственную башню!»

───────────────────────────────────────
🔹 VARIABLES — ПАРАМЕТРЫ ЧЕРТЕЖА
───────────────────────────────────────

```hcl
# variables.tf
variable "tower_name" {
  description = "Name of the tower"
  type        = string
  default     = "Unseen University"
}

variable "tower_size" {
  description = "Size of the tower"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.tower_size)
    error_message = "Size must be t3.micro, t3.small or t3.medium."
  }
}

variable "floors" {
  type    = number
  default = 5
}
```

📖 **Использование**: `var.tower_name`, `var.tower_size`

📖 **Переопределение**:
```bash
terraform apply -var="tower_name=New Tower" -var="tower_size=t3.small"
terraform apply -var-file="production.tfvars"
```

───────────────────────────────────────
🔹 OUTPUTS — РЕЗУЛЬТАТЫ СТРОИТЕЛЬСТВА
───────────────────────────────────────

ASSIGNMENT
```hcl
# outputs.tf
output "tower_ip" {
  description = "Public IP of the tower"
  value       = aws_instance.tower_server.public_ip
}

output "tower_dns" {
  value = aws_instance.tower_server.public_dns
}
```

📂 Рабочий каталог: `~/.termtrainer/terraform_002`

VALIDATION
#!/bin/bash
score=0

which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }

if [ -f "$DIR/variables.tf" ] || [ -f "$DIR/main.tf" ]; then
  grep -q "variable\|output" "$DIR"/*.tf 2>/dev/null && { echo "✓ Variables/outputs созданы"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Variables и Outputs освоены! (баллов: $score/2)"; exit 0; }
echo "ℹ Создай variables.tf и outputs.tf для практики"
exit 0

HINTS
Variable: variable "name" { type, default, description } — параметр чертежа
Variable types: string, number, bool, list, map, object
Default: значение по умолчанию если не передано
Validation: условие проверки значения переменной
tfvars: файл со значениями переменных для конкретной среды
Output: output "name" { value = resource.attr } — результат после apply
-var: переопределить переменную через CLI
