META
# Track: docker
# Title: Расследование инцидента
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

# Create a "broken" app that exits with error
cat > "$DIR/broken-app.py" << 'PYEOF'
import sys, os, time

print("Starting broken-app...")
print(f"DB_HOST={os.getenv('DB_HOST', 'NOT SET')}")
print(f"DB_PORT={os.getenv('DB_PORT', 'NOT SET')}")

db_host = os.getenv('DB_HOST', '')
if not db_host:
    print("ERROR: DB_HOST is not set! Exiting.")
    sys.exit(1)

print(f"Connecting to {db_host}...")
time.sleep(2)
print("App started successfully on port 8080")
from http.server import HTTPServer, BaseHTTPRequestHandler
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'OK')
HTTPServer(('0.0.0.0', 8080), H).serve_forever()
PYEOF

cat > "$DIR/Dockerfile.broken" << 'DEOF'
FROM python:3.12-alpine
WORKDIR /app
COPY broken-app.py .
CMD ["python", "broken-app.py"]
DEOF

cat > "$DIR/Dockerfile.fixed" << 'DEOF'
FROM python:3.12-alpine
WORKDIR /app
COPY broken-app.py .
ENV DB_HOST=db
ENV DB_PORT=5432
CMD ["python", "broken-app.py"]
DEOF

cat > "$DIR/docker-compose.yaml" << 'EOF'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.broken
    ports:
      - "9096:8080"
    depends_on:
      - db
    networks:
      - ninja-net

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=ninja_db
    networks:
      - ninja-net

networks:
  ninja-net:
EOF

TASK
🐉 **Расследование инцидента** (БОСС)

Контейнер постоянно падает! Тебе нужно найти причину, используя навыки отладки, и починить его.

📋 **Ситуация**: Приложение запускается, но сразу падает. Найди проблему!

📋 **Шаги расследования**:

1. **Запусти стек**:
   `cd ~/.ninja_trainer/docker_011 && docker compose up -d --build`

2. **Проверь статус** — контейнер не работает!:
   `docker compose ps -a`
   `docker compose ps -a --format json | jq '.[] | {Name, State}'`

3. **Прочитай логи упавшего контейнера**:
   `docker compose logs app`
   Что ты видишь? Какая ошибка?

4. **Проверь переменные окружения через inspect + jq**:
   `docker inspect <app_container> | jq '.[0].Config.Env'`
   Чего не хватает?

5. **Почини**: пересобери с правильным Dockerfile:
   `docker build -f Dockerfile.fixed -t ninja-fixed:v1 .`

6. **Запусти исправленный образ вручную**:
   `docker run -d --name ninja-fixed -p 9097:8080 --network docker_011_ninja-net ninja-fixed:v1`

7. **Или обнови compose.yaml через yq**:
   ```bash
   yq -i '.services.app.build.dockerfile = "Dockerfile.fixed"' docker-compose.yaml
   yq -i '.services.app.environment = ["DB_HOST=db", "DB_PORT=5432"]' docker-compose.yaml
   docker compose up -d --build
   ```

8. **Проверь что всё работает**:
   `curl http://localhost:9096`
   `docker compose ps`

9. **Скрипт диагностики на bash + jq**:
   ```bash
   for c in $(docker ps -a --format '{{.Names}}'); do
     state=$(docker inspect "$c" | jq -r '.[0].State.Status')
     echo "$c: $state"
   done
   ```

10. **Очистка**: `docker compose down -v`

📂 Рабочий каталог: `~/.ninja_trainer/docker_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_011"
score=0

cd "$DIR" 2>/dev/null || exit 1

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

# Check if fixed container is running
running=$(docker ps --filter name=ninja-fixed --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-fixed" ]; then
  resp=$(curl -s http://localhost:9097 2>/dev/null)
  [ "$resp" = "OK" ] && { echo "✓ Исправленный контейнер работает"; score=$((score+1)); }
fi

# Or check if compose is running with fixed config
compose_running=$(docker compose ps --format json 2>/dev/null | jq -r '.[] | select(.Service=="app") | .State' 2>/dev/null)
if [ "$compose_running" = "running" ]; then
  resp=$(curl -s http://localhost:9096 2>/dev/null)
  [ "$resp" = "OK" ] && { echo "✓ Compose стек починен"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Инцидент расследован! (баллов: $score/3)"; exit 0; }
echo "✗ Найди и почини проблему в контейнере (баллов: $score/3)"
exit 1

HINTS
CrashLoop: docker compose ps -a — посмотреть статус (может быть exited)
Logs of crashed: docker compose logs app — логи даже если контейнер упал
Inspect env: docker inspect <c> | jq '.[0].Config.Env' — какие переменные?
Missing env: если DB_HOST не задан, приложение падает
Fix with yq: yq -i '.services.app.environment = ["KEY=VAL"]' compose.yaml
Rebuild: docker compose up -d --build после исправления
Manual run: docker run -d --name c -e DB_HOST=db --network net image
Diagnose script: for c in $(docker ps -a --format '{{.Names}}'); do echo "$c: $(docker inspect $c | jq -r '.[0].State.Status')"; done
