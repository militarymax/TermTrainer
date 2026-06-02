META
# Track: docker
# Title: Оркестр сосудов
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #007: Оркестр сосудов

Архиканцлер подвёл тебя к стене с рычагами:
«Ринсвинд! Запускать сосуды по одному — это как управлять
оркестром, где каждый музыкант глух. Нужен ДИРИЖЁР!
docker-compose — это партитура, где записано ВСЁ:
какие сосуды нужны, как они связаны, какие порты открыты.
Один файл — и весь оркестр играет!»

───────────────────────────────────────
🔹 DOCKER COMPOSE YAML
───────────────────────────────────────

```yaml
# docker-compose.yml — партитура оркестра
version: "3.8"
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    depends_on:
      - db
  
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: university
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

───────────────────────────────────────
🔹 КОМАНДЫ COMPOSE
───────────────────────────────────────

```bash
docker compose up -d          # Поднять весь оркестр (в фоне)
docker compose ps             # Статус всех сосудов
docker compose logs web       # Записи конкретного сосуда
docker compose logs -f        # Следить за всеми записями
docker compose exec web bash  # Проникнуть в сосуд
docker compose down           # Остановить и уничтожить всё
docker compose down -v        # Уничтожить и тома тоже!
```

• `depends_on` — веб запустится ПОСЛЕ базы
• `volumes` — данные переживут пересоздание сосуда
• Сосуды видят друг друга по имени сервиса (`db`, `web`)

📂 Рабочий каталог: `~/.termtrainer/docker_007`

ASSIGNMENT
📋 **Попробуй**:
1. Создай `docker-compose.yml` с nginx и postgres
2. `docker compose up -d`
3. `docker compose ps && docker compose logs`

VALIDATION
#!/bin/bash
score=0

cat > /tmp/tower_compose_test/docker-compose.yml << 'EOF'
version: "3.8"
services:
  test_web:
    image: nginx
    ports:
      - "18765:80"
EOF

cd /tmp/tower_compose_test && docker compose up -d &>/dev/null && sleep 2

curl -s http://localhost:18765 &>/dev/null && { echo "✓ Compose работает"; score=$((score+1)); }

cd /tmp/tower_compose_test && docker compose down &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Compose освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Compose file: docker-compose.yml — описание всех сервисов
Up: docker compose up -d — поднять все сервисы в фоне
Down: docker compose down — остановить и удалить все контейнеры
Logs: docker compose logs -f — следить за логами всех сервисов
Exec: docker compose exec <service> bash — войти в контейнер
depends_on: порядок запуска сервисов
Volumes: постоянное хранилище данных между перезапусками
Network: сервисы видят друг друга по имени
