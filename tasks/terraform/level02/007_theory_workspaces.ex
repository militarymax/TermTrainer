META
# Track: terraform
# Title: Параллельные миры и удалённые архивы
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/terraform_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #007: Параллельные миры и удалённые архивы

Архиканцлер открыл дверь в параллельное измерение:
«Ринсвинд! Workspaces — это параллельные миры! Один код,
но разные состояния: dev, staging, production.
Каждый workspace хранит свой state отдельно.
А remote backend — это когда Книга Записей хранится не у тебя,
а в надёжном Хранилище (S3), доступном всей команде!»

───────────────────────────────────────
🔹 WORKSPACES — ПАРАЛЛЕЛЬНЫЕ МИРЫ
───────────────────────────────────────

```bash
terraform workspace new staging       # Создать мир "staging"
terraform workspace new production    # Создать мир "production"
terraform workspace list              # Все миры
terraform workspace select staging    # Переключиться!
terraform workspace delete staging    # Уничтожить мир

# Использование в коде:
# terraform.workspace → текущее имя workspace
```

```hcl
resource "aws_instance" "server" {
  # Разный размер для разных миров!
  instance_type = terraform.workspace == "production" ? "t3.medium" : "t3.micro"
  
  tags = {
    Environment = terraform.workspace
  }
}
```

───────────────────────────────────────
🔹 REMOTE BACKEND — УДАЛЁННЫЙ АРХИВ
───────────────────────────────────────

ASSIGNMENT
```hcl
terraform {
  backend "s3" {
    bucket         = "tower-terraform-state"
    key            = "infrastructure.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tower-terraform-locks"   # Блокировка!
    encrypt        = true                       # Шифрование!
  }
}
```

📖 **Зачем remote backend?**
• Командная работа — все видят актуальный state
• Блокировка (DynamoDB) — никто не запустит apply одновременно
• Шифрование — state содержит секреты!
• Версионирование — S3 versioning для отката

📂 Рабочий каталог: `~/.termtrainer/terraform_007`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/terraform_007

VALIDATION
#!/bin/bash
score=0

which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Workspaces и Backend освоены!"; exit 0; }
exit 0

HINTS
Workspace new: terraform workspace new NAME — создать параллельный мир
Workspace select: переключить контекст (отдельный state!)
Terraform.workspace: переменная с именем текущего workspace
Remote backend: S3 + DynamoDB для state + блокировка
State locking: DynamoDB предотвращает одновременный apply
Encrypt: шифровать state (в нём могут быть секреты!)
S3 versioning: включить версионирование bucket для отката state
