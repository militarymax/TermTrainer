META
# Track: terraform
# Title: Рефакторинг чертежей без разрушения
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/terraform_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: Рефакторинг чертежей без разрушения

В Тайной Комнате Архиканцлер открыл древний свиток:
«Ринсвинд! Иногда нужно переименовать ресурс или перенести его
в модуль — БЕЗ пересоздания! moved блок говорит Terraform:
"Этот ресурс переехал, не уничтожай старый!"
А terraform import — вписать существующий ресурс в Книгу Записей.
И taint — пометить ресурс на пересоздание.»

───────────────────────────────────────
🔹 MOVED — ПЕРЕЕЗД БЕЗ РАЗРУШЕНИЯ
───────────────────────────────────────

```hcl
# Ресурс переименован: aws_instance.web → aws_instance.tower_web
moved {
  from = aws_instance.web
  to   = aws_instance.tower_web
}
```

📖 При `terraform plan` Terraform поймёт: это тот же ресурс, просто переименован!

───────────────────────────────────────
🔹 IMPORT — ВПИСАТЬ СУЩЕСТВУЮЩЕЕ В STATE
───────────────────────────────────────

```bash
# Импортировать существующий EC2:
terraform import aws_instance.tower i-1234567890abcdef0

# Импортировать с конфигурацией:
import {
  to = aws_instance.tower
  id = "i-1234567890abcdef0"
}
```

───────────────────────────────────────
🔹 STATE MANIPULATION
───────────────────────────────────────

```bash
terraform state list                    # Все ресурсы
terraform state show aws_instance.web  # Детали ресурса
terraform state mv aws_instance.old aws_instance.new  # Переименовать!
terraform state rm aws_instance.orphan # Удалить из state (не из облака!)
terraform refresh                       # Обновить state из реальности
```

⚠️ `terraform state rm` удаляет ТОЛЬКО из state, реальный ресурс остаётся!

📂 Рабочий каталог: `~/.ninja_trainer/terraform_012`

VALIDATION
#!/bin/bash
score=0
which terraform &>/dev/null && { echo "✓ terraform установлен"; score=$((score+1)); }
[ $score -ge 1 ] && { echo "✓ ok: Продвинутый state освоен!"; exit 0; }
exit 0

HINTS
Moved block: moved { from = old, to = new } — переезд без пересоздания
Import: terraform import TYPE.NAME ID — вписать существующий ресурс
Import block: import { to = TYPE.NAME, id = "RESOURCE_ID" } — декларативный импорт
State mv: terraform state mv OLD NEW — переместить в state
State rm: удалить из state (ресурс в облаке ОСТАНЕТСЯ!)
State show: детали конкретного ресурса из state
Refresh: обновить state чтобы соответствовал реальной инфраструктуре
