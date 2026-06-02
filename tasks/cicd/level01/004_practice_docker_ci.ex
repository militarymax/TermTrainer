META
# Track: cicd
# Title: Сборка сосудов в конвейере
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
⚗️ ПРАКТИКУМ #004: Сборка сосудов в конвейере

Декан Чартер указал на автоматическую линию сборки:
«Ринсвинд! Каждый коммит должен автоматически собирать Docker-образ
и пушить его в Хранилище (registry). GitHub Container Registry,
Docker Hub — выбирай! Главное — тегируй правильно!
Последний раз забыли тег — и вся Башня два часа откатывалась.»

📋 **Задания**:

1. **Создай `.github/workflows/docker.yml`**:
   ```yaml
   name: Build & Push Vessel
   on:
     push:
       branches: [main]
   
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       
       - name: Login to GHCR
         uses: docker/login-action@v3
         with:
           registry: ghcr.io
           username: ${{ github.actor }}
           password: ${{ secrets.GITHUB_TOKEN }}
       
       - name: Build and push
         uses: docker/build-push-action@v5
         with:
           context: .
           push: true
           tags: |
             ghcr.io/${{ github.repository }}:latest
             ghcr.io/${{ github.repository }}:${{ github.sha }}
   ```

2. **Создай простой `Dockerfile`**:
   ```dockerfile
   FROM alpine:3.19
   RUN echo '#!/bin/sh' > /app.sh && \
       echo 'echo "Tower App v1.0"' >> /app.sh && \
       chmod +x /app.sh
   CMD ["/app.sh"]
   ```

3. **Локальная проверка**: `docker build -t tower-test . && docker run --rm tower-test`

📂 Рабочий каталог: `~/.termtrainer/cicd_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_004"
score=0

if [ -f "$DIR/.github/workflows/docker.yml" ]; then
  grep -q "docker\|build\|push\|login" "$DIR/.github/workflows/docker.yml" && { echo "✓ docker.yml создан"; score=$((score+1)); }
fi

if [ -f "$DIR/Dockerfile" ]; then
  grep -q "FROM\|CMD" "$DIR/Dockerfile" && { echo "✓ Dockerfile создан"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Docker CI освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Создай workflow и Dockerfile (баллов: $score/2)"
exit 1

HINTS
Docker login action: docker/login-action — авторизация в registry
Build+push action: docker/build-push-action — собрать и запушить образ
GHCR: ghcr.io — GitHub Container Registry (бесплатный для публичных репо)
Tags: latest + SHA хеш — для воспроизводимости деплоев
GITHUB_TOKEN: встроенный секрет для авторизации в GHCR
Docker Hub: docker/login-action с username/password для Docker Hub
Multi-arch: platforms: linux/amd64,linux/arm64 — мультиплатформенная сборка
