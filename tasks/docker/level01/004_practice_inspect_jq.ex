META
# Track: docker
# Title: Инспекция сосудов через jq
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
docker rm -f ninja-inspect 2>/dev/null

TASK
🔍 **Инспекция сосудов через jq**

`docker inspect` выдаёт огромный JSON. С помощью jq ты можешь извлечь любую крупицу информации — IP-адрес, переменные окружения, порты, тома.

📋 **Задания**:

1. **Запусти контейнер** с переменными и портом:
   `docker run -d --name ninja-inspect -p 9091:80 -e APP_ENV=production nginx`

2. **Полный inspect** (огромный JSON!):
   `docker inspect ninja-inspect`

3. **IP-адрес контейнера** через jq:
   `docker inspect ninja-inspect | jq '.[0].NetworkSettings.IPAddress'`

4. **Проброшенные порты**:
   `docker inspect ninja-inspect | jq '.[0].NetworkSettings.Ports'`

5. **Переменные окружения**:
   `docker inspect ninja-inspect | jq '.[0].Config.Env'`

6. **Имя образа**:
   `docker inspect ninja-inspect | jq '.[0].Config.Image'`

7. **Тома (монтирования)**:
   `docker inspect ninja-inspect | jq '.[0].Mounts'`

8. **Используй --format** (альтернатива jq):
   `docker inspect --format '{{.NetworkSettings.IPAddress}}' ninja-inspect`
   `docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' ninja-inspect`

9. **Bind mount — подключи каталог хоста**:
   `docker run -d --name ninja-mount -v "$HOME/.ninja_trainer/docker_004:/data" alpine sleep 300`
   `docker exec ninja-mount ls /data`
   `echo "hello from host" > "$HOME/.ninja_trainer/docker_004/test.txt"`
   `docker exec ninja-mount cat /data/test.txt`

10. **Именованные тома**:
    `docker volume create ninja-vol`
    `docker volume ls`
    `docker volume inspect ninja-vol | jq '.[0].Mountpoint'`

💡 **Кросс-навыки (jq-yq)**:
• `docker inspect | jq '.[0].State.Status'` — статус контейнера
• `docker inspect | jq '.[0] | {IP: .NetworkSettings.IPAddress, Image: .Config.Image}'` — собрать объект

📂 Рабочий каталог: `~/.ninja_trainer/docker_004`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"
  score=$((score+1))
fi

running=$(docker ps --filter name=ninja-inspect --format '{{.Names}}' 2>/dev/null)
if [ "$running" = "ninja-inspect" ]; then
  ip=$(docker inspect ninja-inspect | jq -r '.[0].NetworkSettings.IPAddress' 2>/dev/null)
  [ -n "$ip" ] && { echo "✓ Контейнер запущен, IP=$ip"; score=$((score+1)); }
fi

env=$(docker inspect ninja-inspect | jq -r '.[0].Config.Env[] | select(startswith("APP_ENV"))' 2>/dev/null)
[ "$env" = "APP_ENV=production" ] && { echo "✓ Переменная найдена через jq"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Инспекция + jq освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Запусти контейнер ninja-inspect (баллов: $score/3)"
exit 1

HINTS
Inspect JSON: docker inspect <container> — полный JSON с метаданными
IP через jq: docker inspect <c> | jq '.[0].NetworkSettings.IPAddress'
Env через jq: docker inspect <c> | jq '.[0].Config.Env'
Ports через jq: docker inspect <c> | jq '.[0].NetworkSettings.Ports'
--format: docker inspect --format '{{.NetworkSettings.IPAddress}}' <container>
Bind mount: docker run -v /host/path:/container/path image
Named volume: docker volume create myvol && docker run -v myvol:/data image
Volume inspect: docker volume inspect myvol | jq '.[0].Mountpoint'
