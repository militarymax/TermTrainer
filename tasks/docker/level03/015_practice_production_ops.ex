META
# Track: docker
# Title: Production-операции
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

cat > "$DIR/app.py" << 'PYEOF'
import os, json, time
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        data = {"app": "ninja-prod", "version": os.getenv("APP_VERSION", "unknown"), "env": os.getenv("APP_ENV", "dev")}
        self.wfile.write(json.dumps(data).encode())

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF

cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
WORKDIR /app
COPY app.py .
ARG APP_VERSION=1.0
ENV APP_VERSION=$APP_VERSION
USER nobody
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/ || exit 1
EXPOSE 8080
CMD ["python", "app.py"]
DEOF

cat > "$DIR/docker-compose.yaml" << 'EOF'
services:
  api:
    build:
      context: .
      args:
        - APP_VERSION=${APP_VERSION:-1.0}
    ports:
      - "${API_PORT:-9099}:8080"
    environment:
      - APP_ENV=${APP_ENV:-production}
    mem_limit: 128m
    cpus: 0.5
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8080/"]
      interval: 10s
      timeout: 3s
      retries: 3
    deploy:
      replicas: 2
    restart: unless-stopped
    logging:
      driver: json-file
      options:
        max-size: "5m"
        max-file: "2"

networks:
  default:
EOF

cat > "$DIR/.env" << 'EOF'
APP_VERSION=2.0
APP_ENV=production
API_PORT=9099
EOF

TASK
🏭 **Production-операции**

Настрой контейнер для production: healthchecks, лимиты ресурсов, ротация логов, blue-green обновление.

📋 **Задания**:

1. **Запусти стек** (обрати внимание на .env файл!):
   `cd ~/.ninja_trainer/docker_015 && docker compose up -d --build`

2. **Проверь healthcheck**:
   `docker compose ps` (статус должен быть "healthy")
   `docker inspect <container> | jq '.[0].State.Health'`

3. **Проверь что переменные из .env подставились**:
   `curl -s http://localhost:9099 | jq '.'`
   Должно быть `version: 2.0`, `env: production`

4. **Валидируй конфигурацию Compose**:
   `docker compose config` — итоговый YAML с подставленными переменными
   `docker compose config | yq '.' ` — просмотр через yq

5. **Обнови версию (blue-green)**:
   ```bash
   # Обнови .env
   echo "APP_VERSION=3.0" > .env
   echo "APP_ENV=production" >> .env
   echo "API_PORT=9099" >> .env
   
   # Пересобери и запусти
   docker compose up -d --build
   
   # Проверь новую версию
   curl -s http://localhost:9099 | jq '.version'
   ```

6. **Мониторинг ресурсов всех контейнеров**:
   `docker stats --no-stream`
   `docker stats --no-stream --format json | jq '{Name, CPUPerc, MemUsage}'`

7. **Проверь ротацию логов через inspect + jq**:
   `docker inspect <container> | jq '.[0].HostConfig.LogConfig'`

8. **Prune — очистка неиспользуемых ресурсов**:
   `docker system df` — сколько места занимает Docker
   `docker image prune -f` — удалить неиспользуемые образы
   `docker container prune -f` — удалить остановленные контейнеры

9. **Скрипт мониторинга production**:
   ```bash
   #!/bin/bash
   echo "=== HEALTH ==="
   for c in $(docker ps --format '{{.Names}}'); do
     h=$(docker inspect "$c" | jq -r '.[0].State.Health.Status // "none"' 2>/dev/null)
     echo "$c: $h"
   done
   echo "=== DISK ==="
   docker system df
   echo "=== EVENTS (last 10) ==="
   docker events --since 5m --until $(date +%s) --filter type=container 2>/dev/null | tail -5
   ```

10. **Очистка**: `docker compose down -v`

📂 Рабочий каталог: `~/.ninja_trainer/docker_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_015"
score=0

cd "$DIR" 2>/dev/null || exit 1

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

running=$(docker compose ps --format json 2>/dev/null | jq -r '.[].State' 2>/dev/null | grep -c "running\|healthy")
if [ "$running" -ge 1 ]; then
  resp=$(curl -s http://localhost:9099 2>/dev/null)
  ver=$(echo "$resp" | jq -r '.version' 2>/dev/null)
  [ -n "$ver" ] && { echo "✓ API v$ver работает"; score=$((score+1)); }
fi

health=$(docker compose ps --format json 2>/dev/null | jq -r '.[].Health' 2>/dev/null | grep -c "healthy")
[ "$health" -ge 1 ] && { echo "✓ Healthcheck работает"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Production-операции освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Запусти стек и проверь healthcheck (баллов: $score/3)"
exit 1

HINTS
.env file: переменные подставляются в docker-compose.yaml автоматически
Compose config: docker compose config — итоговый YAML с подставленными значениями
Healthcheck in Dockerfile: HEALTHCHECK CMD wget -qO- URL || exit 1
Healthcheck status: docker inspect <c> | jq '.[0].State.Health'
Blue-green update: изменить .env → docker compose up -d --build
Stats + jq: docker stats --no-stream --format json | jq '{Name, CPUPerc}'
Log rotation: logging: driver: json-file options: max-size: "5m"
Prune: docker system df + docker image prune + docker container prune
