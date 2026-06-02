META
# Track: docker
# Title: Вход в сосуд и сетевая магия
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: Вход в сосуд и сетевая магия

Архиканцлер открыл потайную дверь:
«Ринсвинд! За этой дверью — секреты Мастера Алхимика.
entrypoint — это привратник сосуда. cp и diff — способы
пронести что-то внутрь или вынести наружу. А сетевая отладка...
это когда два сосуда не видят друг друга, и ты должен понять почему.
Как обычно.»

───────────────────────────────────────
🔹 ENTRYPOINT VS CMD
───────────────────────────────────────

```dockerfile
# CMD — аргументы по умолчанию (можно переопределить!)
CMD ["./app.sh"]           # docker run myimg ./other.sh → заменит!

# ENTRYPOINT — неизменяемая команда
ENTRYPOINT ["./app.sh"]    # docker run myimg arg → добавит arg к app.sh!

# Комбо: ENTRYPOINT + CMD для дефолтных аргументов
ENTRYPOINT ["./app.sh"]
CMD ["--help"]             # По умолчанию --help, но можно переопределить
```

───────────────────────────────────────
🔹 DOCKER CP И DIFF
───────────────────────────────────────

```bash
# Скопировать файл ИЗ сосуда
docker cp broken:/etc/nginx/nginx.conf ./nginx.conf

# Скопировать файл В сосуд
docker cp ./fixed.conf broken:/etc/nginx/nginx.conf

# Что изменилось внутри?
docker diff broken    # A=добавлено C=изменено D=удалено
```

───────────────────────────────────────
🔹 СЕТЕВАЯ ОТЛАДКА СОСУДОВ
───────────────────────────────────────

```bash
# Могут ли сосуды видеть друг друга?
docker exec web ping -c 2 db              # По имени сервиса!
docker exec web nslookup db               # DNS-резолвинг

# Какие порты открыты внутри?
docker exec web ss -tlnp                  # Listening ports

# Маршрут между сосудами
docker exec web traceroute db             # Путь пакетов

# Подключиться к сети другого сосуда
docker network connect tower_net isolated_vessel
```

📂 Рабочий каталог: `~/.termtrainer/docker_012`

ASSIGNMENT
📋 **Попробуй**:
1. `docker run -d --name test_cp nginx && docker cp test_cp:/etc/hostname /tmp/tower_hostname`
2. `cat /tmp/tower_hostname && docker stop test_cp && docker rm test_cp`

VALIDATION
#!/bin/bash
score=0

docker run -d --name tower_cp_test nginx &>/dev/null && sleep 2

docker cp tower_cp_test:/etc/hostname /tmp/tower_cp_test_hostname &>/dev/null && { echo "✓ docker cp работает"; score=$((score+1)); }

diff_out=$(docker diff tower_cp_test 2>&1)
[ -n "$diff_out" ] && { echo "✓ docker diff работает"; score=$((score+1)); }

docker stop tower_cp_test &>/dev/null; docker rm tower_cp_test &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Entrypoint и cp освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Entrypoint: неизменяемая команда при запуске контейнера
CMD: аргументы по умолчанию (можно переопределить через docker run)
docker cp FROM: docker cp container:path host_path — вынести файл из сосуда
docker cp TO: docker cp host_path container:path — внести файл в сосуд
docker diff: показать изменения файлов внутри контейнера (A/C/D)
Network debug: exec + ping/nslookup/ss для проверки связности
docker network connect: подключить работающий контейнер к другой сети
