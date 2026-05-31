META
# Track: docker
# Title: Компонование сосудов
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/docker-compose.yaml" << 'EOF'
services:
  web:
    image: nginx:alpine
    ports:
      - "9093:80"
    environment:
      - NGINX_PORT=80
    depends_on:
      - api
    networks:
      - ninja-net

  api:
    image: python:3.12-alpine
    command: python -m http.server 8080
    working_dir: /app
    volumes:
      - ninja-data:/data
    networks:
      - ninja-net

networks:
  ninja-net:
    driver: bridge

volumes:
  ninja-data:
EOF

TASK
📜 **Компонование сосудов**

Один сосуд — хорошо, но настоящие приложения состоят из нескольких: веб-сервер, API, база данных. Docker Compose позволяет описать весь стек в одном файле и управлять им одной командой.

📖 **docker-compose.yaml** — декларация стека:
• `services:` — контейнеры (каждый — как `docker run`)
• `networks:` — пользовательские сети (сервисы видят друг друга по имени!)
• `volumes:` — именованные тома для данных
• `depends_on:` — порядок запуска

📖 **Команды Compose**:
• `docker compose up -d` — запустить стек в фоне
• `docker compose down` — остановить и удалить контейнеры + сети
• `docker compose down -v` — то же + удалить тома
• `docker compose logs` — логи всех сервисов
• `docker compose logs -f web` — логи конкретного сервиса
• `docker compose ps` — статус сервисов
• `docker compose exec web sh` — зайти в контейнер

📖 **Переменные окружения**:
• В YAML: `environment: - KEY=VALUE`
• Из .env файла: `env_file: .env`
• Подстановка: `${VAR:-default}` в YAML

📖 **Сети между сервисами**:
• В пользовательской сети сервисы доступны по имени: `curl http://api:8080`
• DNS-резолвинг встроен!

📂 Рабочий каталог: `~/.ninja_trainer/docker_007`

📋 **Попробуй**:
1. Запусти стек: `cd ~/.ninja_trainer/docker_007 && docker compose up -d`
2. Статус: `docker compose ps`
3. Логи: `docker compose logs`
4. Проверь сеть: `docker exec <web_container> ping -c 2 api`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Теория Compose освоена! (баллов: $score/1)"; exit 0; }
echo "✗ Нужен работающий Docker"
exit 1

HINTS
Compose file: docker-compose.yaml с services/networks/volumes
Up detached: docker compose up -d — запустить всё в фоне
Down: docker compose down — остановить и удалить
Logs all: docker compose logs — все сервисы
Logs one: docker compose logs -f web — один сервис, следить
Exec: docker compose exec web sh — войти в контейнер
DNS: в custom network сервисы доступны по имени (web, api, db)
Env: environment: - KEY=VALUE или env_file: .env
