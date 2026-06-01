META
# Track: docker
# Title: Два сосуда в гармонии
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 20
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #003: Два сосуда в гармонии

Архиканцлер поставил перед тобой два пустых сосуда:
«Ринсвинд! Мне нужен веб-сервер и база данных. В разных сосудах!
Они должны работать одновременно. И чтобы порты были проброшены!
В прошлый раз ты забыл про порт, и мы три дня не могли понять,
почему страница не открывается. ТРИ ДНЯ, Ринсвинд.»

📋 **Задания**:

1. **Запусти nginx** на порту 8080:
   ```bash
   docker run -d --name web -p 8080:80 nginx
   curl http://localhost:8080    # Проверь что работает!
   ```

2. **Запуши postgres** на порту 5432:
   ```bash
   docker run -d --name db \
     -e POSTGRES_PASSWORD=secret \
     -e POSTGRES_DB=university \
     -p 5432:5432 \
     postgres:15
   ```

3. **Проверь оба сосуда**:
   ```bash
   docker ps                      # Оба работают?
   docker logs web | head -5      # Записи nginx
   docker logs db | head -5       # Записи postgres
   ```

4. **Проникни внутрь nginx**:
   ```bash
   docker exec web cat /etc/nginx/nginx.conf | head -10
   ```

5. **Очисти всё**:
   ```bash
   docker stop web db && docker rm web db
   ```

📂 Рабочий каталог: `~/.ninja_trainer/docker_003`

VALIDATION
#!/bin/bash
score=0

docker run -d --name ninja_test_web -p 18080:80 nginx &>/dev/null && sleep 2
curl -s http://localhost:18080 &>/dev/null && { echo "✓ Nginx работает"; score=$((score+1)); }
docker stop ninja_test_web &>/dev/null; docker rm ninja_test_web &>/dev/null

docker run -d --name ninja_test_db -e POSTGRES_PASSWORD=t -p 15432:5432 postgres:15 &>/dev/null && sleep 3
docker ps | grep -q ninja_test_db && { echo "✓ Postgres работает"; score=$((score+1)); }
docker stop ninja_test_db &>/dev/null; docker rm ninja_test_db &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Мульти-контейнеры освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Nginx: docker run -d --name web -p 8080:80 nginx
Postgres: docker run -d --name db -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres
Проверка: curl http://localhost:8080 — проверить что nginx отвечает
Переменные: -e KEY=value — передать переменную окружения в сосуд
Порты: -p host_port:container_port — проброс порта
Logs: docker logs <name> — прочитать записи сосуда
Exec: docker exec <name> command — выполнить команду внутри
Cleanup: docker stop web db && docker rm web db
