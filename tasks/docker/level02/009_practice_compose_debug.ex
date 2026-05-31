META
# Track: docker
# Title: Отладка стека сосудов
# Number: 009
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/app.py" << 'PYEOF'
from http.server import HTTPServer, BaseHTTPRequestHandler
import os, json, subprocess

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "healthy"}).encode())
        elif self.path == '/db-check':
            try:
                result = subprocess.run(['pg_isready', '-h', 'db', '-p', '5432'], capture_output=True, text=True, timeout=3)
                self.send_response(200 if result.returncode == 0 else 503)
                self.send_header('Content-Type', 'text/plain')
                self.end_headers()
                self.wfile.write(result.stdout.encode())
            except Exception as e:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(str(e).encode())
        else:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            data = {"app": "ninja-api", "env": os.getenv("APP_ENV", "dev")}
            self.wfile.write(json.dumps(data).encode())

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF
cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
RUN apk add --no-cache postgresql-client
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
      - "9094:8080"
    environment:
      - APP_ENV=staging
    depends_on:
      - db
    networks:
      - ninja-net

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=ninja_db
    volumes:
      - ninja-db-data:/var/lib/postgresql/data
    networks:
      - ninja-net

networks:
  ninja-net:

volumes:
  ninja-db-data:
EOF

TASK
🔬 **Отладка стека сосудов**

Запусти стек из нескольких сервисов и научись расследовать проблемы — от недоступности до сетевых ошибок.

📋 **Задания**:

1. **Запусти стек**:
   `cd ~/.ninja_trainer/docker_009 && docker compose up -d --build`

2. **Проверь статус всех сервисов**:
   `docker compose ps`
   `docker compose ps --format json | jq '.[] | {Name, State}'`

3. **Проверь API**:
   `curl -s http://localhost:9094 | jq '.'`

4. **Проверь health endpoint**:
   `curl -s http://localhost:9094/health | jq '.'`

5. **Проверь связь с БД**:
   `curl -s http://localhost:9094/db-check`

6. **Логи всех сервисов**:
   `docker compose logs`
   `docker compose logs api | grep -i error`

7. **Зайди в API контейнер и проверь DNS**:
   `docker compose exec api sh`
   Внутри: `ping -c 2 db` (DNS-резолвинг по имени сервиса!)
   Внутри: `pg_isready -h db -p 5432`

8. **Обнови конфигурацию через yq**:
   `yq -i '.services.api.environment[0] = "APP_ENV=production"' docker-compose.yaml`
   `docker compose up -d` (пересоздать с новыми переменными)

9. **Инспектируй сеть через jq**:
   `docker network inspect docker_009_ninja-net | jq '.[0].Containers[] | {Name, IPv4Address}'`

10. **Останови стек**:
    `docker compose down -v`

💡 **Кросс-навыки**: yq для обновления compose.yaml, jq для парсинга inspect/logs, grep для фильтрации логов

📂 Рабочий каталог: `~/.ninja_trainer/docker_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_009"
score=0

cd "$DIR" 2>/dev/null || exit 1

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

running=$(docker compose ps --format json 2>/dev/null | jq -r '.[].State' 2>/dev/null | grep -c "running")
if [ "$running" -ge 2 ]; then
  echo "✓ $running сервиса запущены"; score=$((score+1))
fi

resp=$(curl -s http://localhost:9094 2>/dev/null)
echo "$resp" | grep -q "ninja-api" && { echo "✓ API отвечает"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Отладка стека освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Запусти стек через docker compose up -d (баллов: $score/3)"
exit 1

HINTS
Compose up: cd dir && docker compose up -d --build
Compose ps: docker compose ps или docker compose ps --format json | jq
Compose logs: docker compose logs или docker compose logs api
Exec in service: docker compose exec api sh
DNS between services: ping db внутри контейнера (имя = имя сервиса)
Update config with yq: yq -i '.services.api.environment[0] = "KEY=VAL"' compose.yaml
Network inspect + jq: docker network inspect <net> | jq '.[0].Containers'
Down with volumes: docker compose down -v — удалить всё включая данные
