META
# Track: docker
# Title: Архимаг Алхимии
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
mkdir -p "$DIR/app" "$DIR/reports"

TASK
👑 UBERBOSS #016: Архимаг Алхимии

Архиканцлер стоял на вершине Башни, ветер развевал его мантию:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Создай production-стек
с нуля: compose с двумя сервисами, healthcheck, безопасный Dockerfile,
скрипт расследования и blue-green deploy.
Используй ВСЁ: Dockerfile, compose, jq, bash, networks.
Если справишься — ты Архимаг Алхимии.
Если нет... помнишь кактус? Он до сих пор колется.»

📋 **БЛОК 1 — Безопасный Dockerfile**:

Создай `$DIR/app/Dockerfile`:
```dockerfile
FROM nginx:alpine
RUN adduser -D appuser
COPY index.html /usr/share/nginx/html/
USER appuser
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

Создай `$DIR/app/index.html`:
```html
<h1>Unseen University — Tower App</h1>
<p>Status: <strong>OPERATIONAL</strong></p>
```

📋 **БЛОК 2 — Compose-стек**:

Создай `$DIR/docker-compose.yml`:
```yaml
version: "3.8"
services:
  web:
    build: ./app
    ports:
      - "8080:80"
    depends_on:
      db:
        condition: service_healthy
    networks:
      - tower_net
  
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD:-university_secret}
      POSTGRES_DB: university
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks:
      - tower_net

volumes:
  db_data:

networks:
  tower_net:
```

📋 **БЛОК 3 — Скрипт расследования**:

Напиши `$DIR/investigate.sh`:
```bash
#!/bin/bash
set -euo pipefail
echo "═══ Tower Stack Investigation ═══"
for svc in web db; do
  echo ""
  echo "── $svc ──"
  docker compose ps "$svc" 2>/dev/null || echo "(not running)"
done
echo ""
echo "── Network ──"
docker network ls | grep tower
echo ""
echo "── Volumes ──"
docker volume ls | grep db_data
echo ""
echo "═══ End of Investigation ═══"
```

📋 **БЛОК 4 — Запуск и проверка**:
1. `cd $DIR && docker compose build`
2. `docker compose up -d`
3. `curl http://localhost:8080`
4. `docker compose ps`
5. `./investigate.sh > reports/full_report.txt`

📋 **БЛОК 5 — Очистка**:
`docker compose down -v`

📂 Рабочий каталог: `~/.ninja_trainer/docker_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_016"
score=0
max=5

[ -f "$DIR/app/Dockerfile" ] && grep -qi "FROM\|HEALTHCHECK\|USER" "$DIR/app/Dockerfile" && { echo "✓ Dockerfile создан"; score=$((score+1)); }

[ -f "$DIR/docker-compose.yml" ] && grep -qi "services\|networks\|volumes\|healthcheck" "$DIR/docker-compose.yml" && { echo "✓ Compose файл создан"; score=$((score+1)); }

[ -f "$DIR/investigate.sh" ] && head -1 "$DIR/investigate.sh" | grep -q '^#!' && { echo "✓ investigate.sh создан"; score=$((score+1)); }

[ -f "$DIR/app/index.html" ] && { echo "✓ index.html есть"; score=$((score+1)); }

[ -d "$DIR/reports" ] && { echo "✓ Каталог reports есть"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 3 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Dockerfile: FROM nginx:alpine + USER appuser + HEALTHCHECK
Index page: простая HTML страница для проверки

=== БЛОК 2 ===
Compose: два сервиса (web+db) в одной сети (tower_net)
Healthcheck для db: pg_isready -U postgres
Depends_on с condition: service_healthy — ждать пока БД будет готова
Volumes: db_data для постоянного хранения данных

=== БЛОК 3 ===
Investigate script: перебрать сервисы → compose ps → network → volumes
set -euo pipefail: священная троица безопасности

=== БЛОК 4 ===
Build: docker compose build — собрать образы
Up: docker compose up -d — поднять стек
Curl: curl http://localhost:8080 — проверить ответ
Report: ./investigate.sh > reports/full_report.txt

=== БЛОК 5 ===
Down: docker compose down -v — остановить и удалить тома
