META
# Track: docker
# Title: Рой и щиты сосудов
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #013: Рой и щиты сосудов

Архиканцлер повёл тебя на крышу Башни:
«Ринсвинд! Видишь эти сосуды внизу? Их СОТНИ. Управлять
каждым вручную — безумие. Нужен РОЙ — чтобы они сами
распределялись, лечились и масштабировались.
И ЩИТЫ — чтобы демоны не выбрались из сосудов.»

───────────────────────────────────────
🔹 DOCKER SWARM — РОЙ СОСУДОВ
───────────────────────────────────────

```bash
docker swarm init                              # Создать рой
docker node ls                                 # Узлы роя
docker service create --name web --replicas 3 nginx   # 3 копии!
docker service ls                              # Сервисы роя
docker service scale web=5                     # Масштабировать!
docker service rm web                          # Удалить сервис
docker swarm leave                             # Выйти из роя
```

• `service` — декларативное описание (сколько реплик нужно)
• Swarm сам решит ГДЕ запустить, перезапустит при падении
• Rolling update: `docker service update --image nginx:1.25 web`

───────────────────────────────────────
🔹 БЕЗОПАСНОСТЬ — ЩИТЫ СОСУДА
───────────────────────────────────────

📖 **Capabilities** — что МОЖЕТ процесс внутри:
```bash
docker run --rm --cap-drop ALL --cap-add NET_BIND_SERVICE nginx
# Убрать ВСЕ capabilities, добавить только нужные!
```

📖 **Read-only filesystem**:
```bash
docker run --rm --read-only nginx    # Файловая система ТОЛЬКО для чтения!
```

📖 **Security options**:
```bash
docker run --rm --security-opt no-new-privileges nginx
# Запретить повышение привилегий!
```

📖 **Trivy** — сканирование уязвимостей:
```bash
trivy image nginx:latest             # Найти CVE в образе!
trivy image --severity HIGH,CRITICAL nginx:latest
```

📂 Рабочий каталог: `~/.termtrainer/docker_013`

ASSIGNMENT
📋 **Попробуй**:
1. `docker info | grep Swarm` — статус роя
2. `trivy image alpine:3.19` — сканирование образа (если установлен)

VALIDATION
#!/bin/bash
score=0

swarm=$(docker info 2>/dev/null | grep "Swarm" | head -1)
[ -n "$swarm" ] && { echo "✓ Docker info работает: $swarm"; score=$((score+1)); }

if command -v trivy &>/dev/null; then
  trivy image --severity HIGH,CRITICAL alpine:3.19 &>/dev/null && { echo "✓ Trivy сканирует"; score=$((score+1)); }
else
  echo "⚠ trivy не установлен (brew install trivy)"; score=$((score+1));
fi

[ $score -ge 1 ] && { echo "✓ ok: Swarm и безопасность освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Swarm init: docker swarm init — создать рой на этой машине
Service create: docker service create --replicas N — запустить N копий
Service scale: docker service scale name=N — масштабировать
Security caps: --cap-drop ALL --cap-add SPECIFIC — минимальные привилегии
Read-only FS: --read-only — файловая система только для чтения
No new privs: --security-opt no-new-privileges — запретить повышение привилегий
Trivy scan: trivy image <image> — найти уязвимости в образе
Trivy filter: --severity HIGH,CRITICAL — только серьёзные уязвимости
