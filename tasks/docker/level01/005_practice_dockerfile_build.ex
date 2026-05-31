META
# Track: docker
# Title: Свой собственный сосуд
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/app.py" << 'PYEOF'
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        env = os.getenv('APP_ENV', 'development')
        self.wfile.write(f"Ninja Trainer running in {env}\n".encode())

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF
cat > "$DIR/Dockerfile" << 'DEOF'
FROM python:3.12-alpine
WORKDIR /app
COPY app.py .
EXPOSE 8080
CMD ["python", "app.py"]
DEOF
cat > "$DIR/.dockerignore" << 'IGEOF'
*.pyc
__pycache__
.git
*.md
IGEOF

TASK
🔨 **Свой собственный сосуд**

Напиши Dockerfile, собери образ и запусти своё приложение!

📋 **Задания**:

1. **Изучи файлы** в рабочем каталоге:
   `cat ~/.ninja_trainer/docker_005/Dockerfile`
   `cat ~/.ninja_trainer/docker_005/app.py`

2. **Собери образ**:
   `cd ~/.ninja_trainer/docker_005 && docker build -t ninja-app:v1 .`

3. **Запусти контейнер**:
   `docker run -d --name ninja-app -p 8088:8080 -e APP_ENV=production ninja-app:v1`

4. **Проверь**:
   `curl http://localhost:8088`
   Должен вернуть: `Ninja Trainer running in production`

5. **Посмотри логи**:
   `docker logs ninja-app`

6. **Инспектируй через jq**:
   `docker inspect ninja-app | jq '.[0].Config.Env'`
   `docker inspect ninja-app | jq '.[0] | {Image, Status: .State.Status}'`

7. **Останови и удали**:
   `docker stop ninja-app && docker rm ninja-app`

💡 **Ключевые инструкции Dockerfile**:
• `FROM` — базовый образ
• `WORKDIR` — рабочий каталог внутри контейнера
• `COPY <src> <dst>` — скопировать файлы с хоста
• `RUN` — выполнить команду при сборке (установка зависимостей)
• `CMD` — команда при запуске контейнера
• `EXPOSE` — документировать порт (не пробрасывает!)

📂 Рабочий каталог: `~/.ninja_trainer/docker_005`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"
  score=$((score+1))
fi

images=$(docker images ninja-app --format '{{.Repository}}' 2>/dev/null)
if [ "$images" = "ninja-app" ]; then
  echo "✓ Образ ninja-app собран"
  score=$((score+1))
fi

running=$(docker ps --filter name=ninja-app --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-app" ]; then
  resp=$(curl -s http://localhost:8088 2>/dev/null | head -1)
  echo "$resp" | grep -q "Ninja Trainer" && { echo "✓ Приложение отвечает: $resp"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Сборка образов освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Собери и запусти образ ninja-app (баллов: $score/3)"
exit 1

HINTS
Build: cd directory && docker build -t name:tag .
Run built image: docker run -d --name myapp -p 8080:8080 name:tag
Dockerfile FROM: FROM python:3.12-alpine — минимальный базовый образ
COPY: COPY local_file /container/path/
CMD vs RUN: RUN — при сборке, CMD — при запуске
EXPOSE: только документирует порт, нужен -p при docker run
.dockerignore: исключить файлы из контекста сборки (.git, node_modules)
Inspect + jq: docker inspect <c> | jq '.[0].Config.Env'
