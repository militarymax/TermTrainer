META
# Track: terraform
# Title: Заклинания повторения
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #008: Заклинания повторения

Библиотекарь открыл раздел мета-заклинаний:
«Ууук!» — что означало: «Не копируй код! Используй count,
for_each и dynamic blocks! Один блок — много ресурсов!
Как заклинание клонирования, только безопаснее.»

───────────────────────────────────────
🔹 COUNT — ПОВТОРИТЬ N РАЗ
───────────────────────────────────────

```hcl
variable "tower_count" { default = 3 }

resource "aws_instance" "server" {
  count         = var.tower_count
  ami           = "ami-123"
  instance_type = "t3.micro"
  
  tags = {
    Name = "tower-server-${count.index}"   # tower-server-0, -1, -2
  }
}
```

───────────────────────────────────────
🔹 FOR_EACH — ПО КЛЮЧАМ И ЗНАЧЕНИЯМ
───────────────────────────────────────

```hcl
variable "towers" {
  default = {
    web  = { size = "t3.micro", port = 80 }
    api  = { size = "t3.small", port = 8080 }
    db   = { size = "t3.medium", port = 5432 }
  }
}

resource "aws_instance" "server" {
  for_each = var.towers
  
  ami           = "ami-123"
  instance_type = each.value.size
  
  tags = {
    Name = "tower-${each.key}"
    Port = each.value.port
  }
}
```

📖 **for_each лучше count**: при удалении элемента из середины,
for_each удаляет только его, а count пересоздаёт все после!

───────────────────────────────────────
🔹 DYNAMIC BLOCKS
───────────────────────────────────────

ASSIGNMENT
```hcl
resource "aws_security_group" "tower" {
  name = "tower-sg"
  
  dynamic "ingress" {
    for_each = [80, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

📂 Рабочий каталог: `~/.termtrainer/terraform_008`

VALIDATION
#!/bin/bash
score=0
which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }
[ $score -ge 1 ] && { echo "✓ ok: Циклы Terraform освоены!"; exit 0; }
exit 0

HINTS
Count: count = N → создать N ресурсов, обращаться через count.index
For_each map: for_each = var.map → каждый ключ в each.key, значение в each.value
For_each set: for_each = toset(["a","b"]) → each.value
Dynamic block: dynamic "name" { for_each = LIST content { ... } }
For_each vs count: for_each безопаснее при удалении элементов
Locals: locals { names = [for k,v in var.map : k] } — трансформации
Splat: aws_instance.server[*].id — получить все ID из count ресурса
