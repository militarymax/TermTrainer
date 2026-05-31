META
# Track: docker
# Title: Глубокая отладка
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

# App that writes to a mystery file and has network issues
cat > "$DIR/app.py" << 'PYEOF'
import os, json, time
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok", "pid": os.getpid()}).encode())
        elif self.path == '/debug':
            # Write suspicious file
            with open('/tmp/debug_dump.txt', 'w') as f:
                f.write(f"PID={os.getpid()}\nENV={dict(os.environ)}\n")
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Debug dump written')
        else:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            data = {"app": "ninja-debug", "host": os.getenv("HOSTNAME", "?")}
            self.wfile.write(json.dumps(data).encode())

print("Ninja debug app starting on :8080")
HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF

cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
RUN apk add --no-cache iputils net-tools
WORKDIR /app
COPY app.py .
EXPOSE 8080
CMD ["python", "app.py"]
DEOF

cat > "$DIR/docker-compose.yaml" << 'EOF'
services:
  api:
    build: .
    ports:
      - "9098:8080"
    networks:
      - frontend
      - backend

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=ninja_db
    networks:
      - backend

  cache:
    image: redis:7-alpine
    networks:
      - backend

networks:
  frontend:
  backend:
EOF

TASK
🔬 **Глубокая отладка**

Реальный production-сценарий: приложение работает, но что-то не так. Используй все инструменты — от docker diff до сетевого debug.

📋 **Задания**:

1. **Запусти стек**:
   `cd ~/.ninja_trainer/docker_014 && docker compose up -d --build`

2. **Вызови debug endpoint** (запишет файл в контейнер):
   `curl http://localhost:9098/debug`

3. **Проверь изменения файловой системы**:
   `docker compose ps --format json | jq -r '.[].Name' | head -1 | xargs docker diff`
   Что появилось? (A = Added, C = Changed)

4. **Скопируй файл из контейнера на хост**:
   ```bash
   API_CONTAINER=$(docker compose ps -q api)
   docker cp "$API_CONTAINER":/tmp/debug_dump.txt ./debug_dump.txt
   cat debug_dump.txt
   ```

5. **Сетевая диагностика — проверь DNS между сервисами**:
   `docker compose exec api sh`
   Внутри:
   ```
   ping -c 2 db
   ping -c 2 cache
   nc -zv db 5432
   nc -zv cache 6379
   ```

6. **Инспектируй сети через jq**:
   ```bash
   docker network ls --filter name=docker_014 --format json | jq '.Name'
   docker network inspect docker_014_frontend | jq '.[0].Containers[] | {Name, IPv4Address}'
   docker network inspect docker_014_backend | jq '.[0].Containers[] | {Name, IPv4Address}'
   ```

7. **Переопредели entrypoint для исследования**:
   `docker run -it --rm --entrypoint sh --network docker_014_backend ninja-014-api`
   Внутри попробуй: `ping db`, `ping cache`

8. **Скрипт полной диагностики на bash + jq**:
   ```bash
   echo "=== CONTAINERS ==="
   docker compose ps --format json | jq '.[] | {Name, State}'
   
   echo "=== NETWORKS ==="
   for net in $(docker network ls --filter name=docker_014 --format '{{.Name}}'); do
     echo "--- $net ---"
     docker network inspect "$net" | jq '.[0].Containers[] | .Name + ": " + .IPv4Address'
   done
   
   echo "=== RESOURCE USAGE ==="
   docker stats --no-stream --format json | jq '{Name, CPUPerc, MemUsage}'
   ```

9. **Очистка**: `docker compose down -v`

📂 Рабочий каталог: `~/.ninja_trainer/docker_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_014"
score=0

cd "$DIR" 2>/dev/null || exit 1

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

running=$(docker compose ps --format json 2>/dev/null | jq -r '.[].State' 2>/dev/null | grep -c "running")
if [ "$running" -ge 2 ]; then
  echo "✓ $running сервиса запущены"; score=$((score+1))
fi

resp=$(curl -s http://localhost:9098/health 2>/dev/null)
echo "$resp" | grep -q "ok" && { echo "✓ API отвечает"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Глубокая отладка освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Запусти стек и проведи диагностику (баллов: $score/3)"
exit 1

HINTS
Diff filesystem: docker diff <container> — A=added C=changed D=deleted
Copy from container: docker cp <container>:/path/file ./local_copy
Network DNS: ping <service_name> внутри контейнера (работает в custom networks)
Port check: nc -zv hostname port — проверить доступность TCP-порта
Override entrypoint: docker run -it --entrypoint sh image — исследовать образ
Inspect network + jq: docker network inspect <net> | jq '.[0].Containers'
Full diagnose script: compose ps + network inspect + stats через jq pipeline
Multiple networks: сервис может быть в нескольких сетях одновременно
