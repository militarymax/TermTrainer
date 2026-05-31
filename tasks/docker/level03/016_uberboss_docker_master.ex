META
# Track: docker
# Title: Архимаг Контейнеров
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

cat > "$DIR/app.py" << 'PYEOF'
import os, json, sys, time
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "healthy", "uptime": time.time()}).encode())
        elif self.path == '/env':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            env = {k: v for k, v in os.environ.items() if not k.startswith('_')}
            self.wfile.write(json.dumps(env).encode())
        elif self.path == '/crash':
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b'CRASH!')
            sys.exit(1)
        else:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            data = {
                "app": "ninja-prod",
                "version": os.getenv("APP_VERSION", "unknown"),
                "db_host": os.getenv("DB_HOST", "NOT SET"),
                "db_port": os.getenv("DB_PORT", "NOT SET")
            }
            self.wfile.write(json.dumps(data).encode())

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF

cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
RUN apk add --no-cache postgresql-client iputils net-tools wget
WORKDIR /app
COPY app.py .
ARG APP_VERSION=1.0
ENV APP_VERSION=$APP_VERSION
USER nobody
HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1
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
      - "${API_PORT:-9100}:8080"
    environment:
      - APP_ENV=${APP_ENV:-production}
      - DB_HOST=db
      - DB_PORT=5432
    depends_on:
      db:
        condition: service_healthy
    networks:
      - frontend
      - backend
    mem_limit: ${API_MEM:-128m}
    cpus: ${API_CPU:-0.5}
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8080/health"]
      interval: 5s
      timeout: 3s
      retries: 3
    restart: unless-stopped
    logging:
      driver: json-file
      options:
        max-size: "5m"
        max-file: "2"

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD:-secret}
      - POSTGRES_DB=ninja_db
    volumes:
      - ninja-db-data:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5

networks:
  frontend:
  backend:

volumes:
  ninja-db-data:
EOF

cat > "$DIR/.env" << 'EOF'
APP_VERSION=2.0
APP_ENV=production
API_PORT=9100
DB_PASSWORD=topsecret
API_MEM=128m
API_CPU=0.5
EOF

TASK
👑 **Архимаг Контейнеров** (UBERBOSS)

Production-инцидент! Стек упал после обновления. Расследуй, восстанови и захардени — используя все навыки: Docker CLI, jq/yq, bash-скриптинг.

📋 **БЛОК 1 — Запуск и проверка**:
1. Запусти стек: `cd ~/.ninja_trainer/docker_016 && docker compose up -d --build`
2. Проверь здоровье всех сервисов: `docker compose ps`
3. Проверь API: `curl -s http://localhost:9100 | jq '.'`

📋 **БЛОК 2 — Инспекция через jq**:
4. Все IP контейнеров в сетях:
   ```bash
   for net in $(docker network ls --filter name=docker_016 --format '{{.Name}}'); do
     echo "=== $net ==="
     docker network inspect "$net" | jq '.[0].Containers[] | .Name + ": " + .IPv4Address'
   done
   ```
5. Переменные окружения API через inspect + jq:
   `docker inspect <api_container> | jq '.[0].Config.Env'`
6. Лимиты ресурсов через inspect + jq:
   `docker inspect <api_container> | jq '.[0].HostConfig | {Memory, NanoCpus}'`

📋 **БЛОК 3 — Сетевая диагностика**:
7. Зайди в API контейнер и проверь связь с БД:
   `docker compose exec api sh`
   Внутри: `pg_isready -h db -p 5432` и `ping -c 2 db`

📋 **БЛОК 4 — Инцидент: краш**:
8. Вызови crash endpoint: `curl http://localhost:9100/crash`
9. Проверь что контейнер перезапустился (restart policy!):
   `docker compose ps`
   `docker inspect <api_container> | jq '.[0].RestartCount'`
10. Прочитай логи краша: `docker compose logs api --since 2m`

📋 **БЛОК 5 — Обновление конфигурации через yq**:
11. Увеличь лимит памяти:
    `yq -i '.services.api.mem_limit = "256m"' docker-compose.yaml`
12. Добавь cache сервис в compose.yaml через yq:
    `yq -i '.services.cache.image = "redis:7-alpine"' docker-compose.yaml`
    `yq -i '.services.cache.networks = ["backend"]' docker-compose.yaml`
13. Перезапусти: `docker compose up -d`

📋 **БЛОК 6 — Скрипт мониторинга**:
14. Напиши скрипт `monitor.sh` который:
    - Показывает статус healthcheck каждого контейнера
    - Показывает использование диска (`docker system df`)
    - Показывает использование памяти/CPU (`docker stats --no-stream`)
    - Использует jq для парсинга

📋 **БЛОК 7 — Очистка**:
15. `docker compose down -v && docker image prune -f`

📂 Рабочий каталог: `~/.ninja_trainer/docker_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_016"
score=0
max=7

cd "$DIR" 2>/dev/null || exit 1

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

running=$(docker compose ps --format json 2>/dev/null | jq -r '.[].State' 2>/dev/null | grep -c "running\|healthy")
if [ "$running" -ge 2 ]; then
  echo "✓ $running сервиса запущены"; score=$((score+1))
fi

resp=$(curl -s http://localhost:9100 2>/dev/null)
echo "$resp" | grep -q "ninja-prod" && { echo "✓ API отвечает"; score=$((score+1)); }

health=$(docker compose ps --format json 2>/dev/null | jq -r '.[].Health' 2>/dev/null | grep -c "healthy")
[ "$health" -ge 1 ] && { echo "✓ Healthcheck работает ($health healthy)"; score=$((score+1)); }

net=$(docker network ls --filter name=docker_016 --format '{{.Name}}' 2>/dev/null | wc -l)
[ "$net" -ge 2 ] && { echo "✓ $net сети созданы"; score=$((score+1)); }

vol=$(docker volume ls --filter name=ninja-db-data --format '{{.Name}}' 2>/dev/null)
[ "$vol" = "ninja-db-data" ] && { echo "✓ Том БД создан"; score=$((score+1)); }

cache=$(docker compose ps --format json 2>/dev/null | jq -r '.[].Service' 2>/dev/null | grep -c "cache")
[ "$cache" -ge 1 ] && { echo "✓ Cache сервис добавлен"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 4 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Compose up: cd dir && docker compose up -d --build
Check all: docker compose ps — статусы + health

=== БЛОК 2 ===
Network IPs: docker network inspect <net> | jq '.[0].Containers[] | .Name + ": " + .IPv4Address'
Inspect env: docker inspect <c> | jq '.[0].Config.Env'
Inspect limits: docker inspect <c> | jq '.[0].HostConfig | {Memory, NanoCpus}'

=== БЛОК 3 ===
DNS test: ping db внутри контейнера (custom network DNS)
DB ready: pg_isready -h db -p 5432

=== БЛОК 4 ===
Crash: curl /crash → container exits but restart policy restarts it
Restart count: docker inspect <c> | jq '.[0].RestartCount'
Logs since: docker compose logs api --since 5m

=== БЛОК 5 ===
Update with yq: yq -i '.services.api.mem_limit = "256m"' compose.yaml
Add service: yq -i '.services.cache.image = "redis:7-alpine"' compose.yaml
Reapply: docker compose up -d after changes

=== БЛОК 6 ===
Monitor script: loop containers → inspect health → stats → system df
