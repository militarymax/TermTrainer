META
# Track: docker
# Title: Управление сосудами
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
# Cleanup any previous containers
docker rm -f ninja-web ninja-db 2>/dev/null

TASK
⚗️ **Управление сосудами**

Потренируйся запускать, останавливать и исследовать контейнеры. Используй навыки grep/sed для фильтрации вывода!

📋 **Задания**:

1. **Запусти nginx** с пробросом порта:
   `docker run -d --name ninja-web -p 9090:80 nginx`

2. **Проверь что работает**:
   `curl -s http://localhost:9090 | head -5`
   `docker ps --filter name=ninja-web`

3. **Прочитай логи** и отфильтруй через grep:
   `docker logs ninja-web`
   `docker logs ninja-web 2>&1 | grep -i "GET\|error"`

4. **Запусти PostgreSQL**:
   `docker run -d --name ninja-db -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:16-alpine`

5. **Зайди внутрь nginx** и посмотри конфигурацию:
   `docker exec ninja-web cat /etc/nginx/nginx.conf`

6. **Выполни команду в postgres**:
   `docker exec ninja-db pg_isready`

7. **Останови и удали** оба контейнера:
   `docker stop ninja-web ninja-db && docker rm ninja-web ninja-db`

💡 **Кросс-навыки (text-fu)**:
• `docker ps | grep ninja` — фильтрация контейнеров
• `docker logs web 2>&1 | sed -n '1,10p'` — первые 10 строк логов

📂 Рабочий каталог: `~/.ninja_trainer/docker_003`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"
  score=$((score+1))
fi

running=$(docker ps --filter name=ninja-web --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-web" ]; then
  echo "✓ Контейнер ninja-web запущен"
  score=$((score+1))
fi

db_running=$(docker ps --filter name=ninja-db --format '{{.Names}}' 2>/dev/null)
if [ "$db_running" = "ninja-db" ]; then
  echo "✓ Контейнер ninja-db запущен"
  score=$((score+1))
fi

[ $score -ge 2 ] && { echo "✓ ok: Управление сосудами освоено! (баллов: $score/3)"; exit 0; }
echo "✗ Запусти контейнеры ninja-web и ninja-db (баллов: $score/3)"
exit 1

HINTS
Run detached: docker run -d --name myapp -p 8080:80 nginx
Check running: docker ps или docker ps --filter name=myapp
Logs + grep: docker logs myapp 2>&1 | grep error
Exec inside: docker exec -it myapp bash или docker exec myapp ls /
Stop + remove: docker stop myapp && docker rm myapp
PostgreSQL: docker run -d -e POSTGRES_PASSWORD=secret postgres:16-alpine
Check DB ready: docker exec <container> pg_isready
