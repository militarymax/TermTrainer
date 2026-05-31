META
# Track: docker
# Title: Ресурсы и многоэтапная сборка
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_010"
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
        data = {"app": "ninja-api", "env": os.getenv("APP_ENV", "dev"), "memory_limit": os.getenv("MEMORY_LIMIT", "none")}
        self.wfile.write(json.dumps(data).encode())

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
PYEOF
cat > "$DIR/Dockerfile" << 'DEOF'
# Stage 1: Build (не попадёт в финальный образ)
FROM python:3.12 AS builder
WORKDIR /build
RUN echo "Build stage - dependencies would go here" > build_info.txt

# Stage 2: Runtime (минимальный)
FROM python:3.12-alpine
WORKDIR /app
COPY --from=builder /build/build_info.txt /tmp/
COPY app.py .
ARG APP_VERSION=1.0
ENV APP_VERSION=$APP_VERSION
LABEL maintainer="ninja-trainer" version="${APP_VERSION}"
USER nobody
EXPOSE 8080
CMD ["python", "app.py"]
DEOF

TASK
⚡ **Ресурсы и многоэтапная сборка**

Оптимизируй образы через multi-stage builds и управляй ресурсами контейнеров.

📋 **Задания**:

1. **Собери с аргументом сборки**:
   `cd ~/.ninja_trainer/docker_010 && docker build --build-arg APP_VERSION=2.0 -t ninja-opt:v2 .`

2. **Запусти с ограничением ресурсов**:
   `docker run -d --name ninja-opt -p 9095:8080 --memory=128m --cpus=0.5 -e APP_ENV=production ninja-opt:v2`

3. **Проверь ограничения через inspect + jq**:
   `docker inspect ninja-opt | jq '.[0].HostConfig.Memory'`
   `docker inspect ninja-opt | jq '.[0].HostConfig.NanoCpus'`

4. **Мониторинг ресурсов**:
   `docker stats --no-stream ninja-opt`

5. **Проверь что контейнер работает от пользователя nobody**:
   `docker exec ninja-opt whoami`
   `docker inspect ninja-opt | jq '.[0].Config.User'`

6. **Проверь метки (labels)**:
   `docker inspect ninja-opt | jq '.[0].Config.Labels'`

7. **Сравни размеры образов**:
   `docker images | grep ninja-opt`
   `docker images python:3.12` (полный) vs `docker images python:3.12-alpine` (alpine)

8. **Скрипт мониторинга на bash + jq**:
   ```bash
   for c in $(docker ps --format '{{.Names}}'); do
     mem=$(docker stats --no-stream "$c" | tail -1 | awk '{print $4}')
     echo "$c: memory=$mem"
   done
   ```

9. **Останови**: `docker stop ninja-opt && docker rm ninja-opt`

💡 **Multi-stage builds**: Каждый `FROM` — новый этап. В финальный образ попадает только то, что скопировано через `COPY --from=`.

📂 Рабочий каталог: `~/.ninja_trainer/docker_010`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

images=$(docker images ninja-opt --format '{{.Repository}}' 2>/dev/null)
[ "$images" = "ninja-opt" ] && { echo "✓ Образ собран"; score=$((score+1)); }

running=$(docker ps --filter name=ninja-opt --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-opt" ]; then
  mem=$(docker inspect ninja-opt | jq '.[0].HostConfig.Memory' 2>/dev/null)
  [ "$mem" != "null" ] && [ "$mem" != "0" ] && { echo "✓ Лимит памяти установлен: $mem"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Ресурсы и multi-stage освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Собери образ и запусти с лимитами (баллов: $score/3)"
exit 1

HINTS
Multi-stage: FROM image AS stage1 ... COPY --from=stage1 /path /path
Build arg: docker build --build-arg VERSION=2.0 -t app:v2 .
Memory limit: docker run --memory=128m image
CPU limit: docker run --cpus=0.5 image
Stats: docker stats --no-stream — снимок метрик
Inspect limits: docker inspect <c> | jq '.[0].HostConfig.Memory'
User in Dockerfile: USER nobody — запуск от непривилегированного пользователя
Labels: LABEL key=value — метаданные образа
Compare sizes: docker images | grep pattern
