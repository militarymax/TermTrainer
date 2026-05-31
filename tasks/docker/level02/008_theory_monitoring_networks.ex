META
# Track: docker
# Title: Мониторинг и сети
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Мониторинг и сети**

Алхимик должен следить за своими сосудами — сколько ресурсов они потребляют, какие процессы внутри, что происходит. А сети — это каналы между сосудами.

📖 **Мониторинг**:
• `docker stats` — CPU/память/сеть всех контейнеров в реальном времени
• `docker stats --no-stream` — один снимок метрик (для скриптов!)
• `docker stats --no-stream --format json | jq '.'` — парсинг через jq
• `docker top <container>` — процессы внутри контейнера (как ps)
• `docker events` — поток событий Docker (create/start/die/destroy)

📖 **Сети**:
• `docker network ls` — список сетей
• `docker network create ninja-net` — создать bridge-сеть
• `docker network connect ninja-net <container>` — подключить контейнер
• `docker network inspect ninja-net | jq '.[0].Containers'` — кто в сети
• `docker network disconnect ninja-net <container>`
• В custom bridge-сети работает DNS по имени контейнера!

📖 **Логирование и ротация**:
• Драйверы: `--log-driver json-file` (по умолчанию), `syslog`, `journald`, `none`
• Ротация: `--log-opt max-size=10m --log-opt max-file=3`
• Пример: `docker run -d --log-opt max-size=5m --log-opt max-file=2 nginx`

📖 **Полезные комбинации с jq**:
```bash
# Все IP контейнеров в сети
docker network inspect ninja-net | jq '.[0].Containers[] | .Name + ": " + .IPv4Address'

# Размеры образов
docker images --format json | jq '.Repository + ":" + .Tag + " " + .Size'

# Статусы контейнеров
docker ps -a --format json | jq '{Name, Status}'
```

📂 Рабочий каталог: `~/.ninja_trainer/docker_008`

📋 **Попробуй**:
1. Метрики: `docker stats --no-stream`
2. Процессы: `docker top <container>` (нужен запущенный контейнер)
3. События: `docker events &` (запусти в фоне, потом создай контейнер)
4. Создай сеть: `docker network create ninja-test && docker network inspect ninja-test | jq '.'`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

net=$(docker network ls --filter name=ninja-test --format '{{.Name}}' 2>/dev/null)
[ "$net" = "ninja-test" ] && { echo "✓ Сеть ninja-test создана"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Мониторинг и сети освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Stats: docker stats — реальное время; docker stats --no-stream — один снимок
Stats + jq: docker stats --no-stream --format json | jq '.' — парсинг метрик
Top: docker top <container> — процессы внутри (как ps aux)
Events: docker events — поток событий (create/start/die/...)
Network create: docker network create my-net
Network inspect: docker network inspect my-net | jq '.[0].Containers'
Network connect: docker network connect my-net <container> — добавить контейнер
Log rotation: docker run --log-opt max-size=10m --log-opt max-file=3 image
