META
# Track: docker
# Title: Цикл жизни сосуда
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/app.py" << 'PYEOF'
from http.server import HTTPServer, BaseHTTPRequestHandler
import os, json

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        data = {"status": "ok", "env": os.getenv("APP_ENV", "dev"), "host": os.getenv("HOSTNAME", "unknown")}
        self.wfile.write(json.dumps(data).encode())
    def log_message(self, format, *args):
        with open('/data/access.log', 'a') as f:
            f.write(f"{self.client_address[0]} - {format % args}\n")

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF
cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
WORKDIR /app
COPY app.py .
RUN mkdir -p /data
EXPOSE 8080
CMD ["python", "app.py"]
DEOF

TASK
🐉 **Цикл жизни сосуда** (БОСС)

Докажи что ты владеешь полным циклом: от сборки образа до удаления контейнера, используя навыки jq и bash.

📋 **Боевые задания**:

1. **Собери образ**: `cd ~/.ninja_trainer/docker_006 && docker build -t ninja-boss:v1 .`

2. **Запусти с портом, переменной и томом**:
   `docker run -d --name ninja-boss -p 9092:8080 -e APP_ENV=production -v ninja-boss-data:/data ninja-boss:v1`

3. **Проверь ответ**:
   `curl -s http://localhost:9092 | jq '.'`

4. **Извлеки IP через inspect | jq**:
   `docker inspect ninja-boss | jq -r '.[0].NetworkSettings.IPAddress'`

5. **Извлеки все переменные окружения**:
   `docker inspect ninja-boss | jq '.[0].Config.Env'`

6. **Создай запрос и проверь логи в томе**:
   `curl -s http://localhost:9092 > /dev/null`
   `docker exec ninja-boss cat /data/access.log`

7. **Проверь статус через inspect + jq**:
   `docker inspect ninja-boss | jq '.[0].State | {Status, Running, StartedAt}'`

8. **Перезапусти и проверь что работает**:
   `docker restart ninja-boss`
   `curl -s http://localhost:9092 | jq '.status'`

9. **Останови и удали всё**:
   `docker stop ninja-boss && docker rm ninja-boss`
   `docker volume rm ninja-boss-data`

📂 Рабочий каталог: `~/.ninja_trainer/docker_006`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

images=$(docker images ninja-boss --format '{{.Repository}}' 2>/dev/null)
[ "$images" = "ninja-boss" ] && { echo "✓ Образ собран"; score=$((score+1)); }

running=$(docker ps --filter name=ninja-boss --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-boss" ]; then
  resp=$(curl -s http://localhost:9092 2>/dev/null)
  status=$(echo "$resp" | jq -r '.status' 2>/dev/null)
  [ "$status" = "ok" ] && { echo "✓ Приложение отвечает: $resp"; score=$((score+1)); }
fi

vol=$(docker volume ls --filter name=ninja-boss-data --format '{{.Name}}' 2>/dev/null)
[ "$vol" = "ninja-boss-data" ] && { echo "✓ Том создан"; score=$((score+1)); }

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Полный цикл освоен! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
Build: cd dir && docker build -t name:tag .
Run with all flags: docker run -d --name c -p port:port -e KEY=VAL -v vol:/path image
Curl + jq: curl -s URL | jq '.' — красивый JSON-ответ
Inspect IP: docker inspect <c> | jq -r '.[0].NetworkSettings.IPAddress'
Inspect env: docker inspect <c> | jq '.[0].Config.Env'
Exec in container: docker exec <c> cat /path/file
Restart: docker restart <c>
Cleanup: docker stop <c> && docker rm <c> && docker volume rm <vol>
