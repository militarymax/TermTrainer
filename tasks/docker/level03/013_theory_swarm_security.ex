META
# Track: docker
# Title: Безопасность и оркестрация
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Безопасность и оркестрация**

Production-контейнеры должны быть безопасными. А для масштабирования нужна оркестрация.

📖 **Безопасность контейнеров**:
• `USER nobody` в Dockerfile — не запускать от root!
• `--read-only` — корневая файловая система только для чтения
• `--cap-drop=ALL --cap-add=NET_BIND_SERVICE` — минимальные Linux capabilities
• `--security-opt no-new-privileges` — запретить повышение привилегий
• Избегать `--privileged` — это даёт доступ ко ВСЕМУ хосту!

📖 **Сканирование уязвимостей**:
• `docker scout cves <image>` — встроенное сканирование (Docker Desktop)
• `trivy image <image>` — Trivy (от Aqua Security, бесплатный)
• Интеграция в CI: сканирование при каждой сборке

📖 **Docker Swarm** (базовая оркестрация):
• `docker swarm init` — инициализировать кластер
• `docker service create --name web -p 8080:80 --replicas 3 nginx`
• `docker service ls` — список сервисов
• `docker service scale web=5` — масштабировать
• `docker stack deploy -c compose.yaml mystack` — деплой стека
• `docker node ls` — узлы кластера

📖 **Секреты**:
• В Swarm: `echo "secret" | docker secret create db_password -`
• Использование: `docker service create --secret db_password image`
• В Compose: `secrets:` секция
• ❌ Не храните секреты в переменных окружения! (видно в inspect)

📖 **Полезные проверки безопасности через jq**:
```bash
# Контейнеры с root-доступом
docker ps -q | xargs docker inspect | \
  jq '.[] | select(.Config.User == "" or .Config.User == "root") | .Name'

# Контейнеры с privileged
docker ps -q | xargs docker inspect | \
  jq '.[] | select(.HostConfig.Privileged == true) | .Name'

# Все проброшенные порты
docker ps -q | xargs docker inspect | \
  jq '.[] | {Name, Ports: .HostConfig.PortBindings}'
```

📂 Рабочий каталог: `~/.ninja_trainer/docker_013`

📋 **Попробуй**:
1. Сканирование: `trivy image python:3.12-alpine` (если установлен trivy)
2. Проверь root-контейнеры: скрипт из примеров выше

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Безопасность и Swarm освоены! (баллов: $score/1)"; exit 0; }
echo "✗ Нужен работающий Docker"
exit 1

HINTS
Non-root: USER nobody в Dockerfile — никогда от root!
Read-only FS: docker run --read-only image — защита файловой системы
Drop caps: docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE image
No new privs: docker run --security-opt no-new-privileges image
Avoid privileged: --privileged = полный доступ к хосту, ОПАСНО!
Trivy scan: trivy image <name> — CVE уязвимости в образе
Swarm init: docker swarm init — создать кластер
Secrets: echo "pass" | docker secret create my_secret - — секреты в Swarm
