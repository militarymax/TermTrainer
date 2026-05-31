META
# Track: docker
# Title: Продвинутая отладка сосудов
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Продвинутая отладка сосудов**

Когда простые логи не помогают — нужны продвинутые инструменты. Переопределение entrypoint, копирование файлов, анализ изменений и сетевой debug.

📖 **Переопределение точки входа**:
• `docker run -it --entrypoint sh image` — зайти в оболочку вместо CMD
• `docker run --entrypoint python image debug.py` — запустить другой скрипт
• Полезно когда контейнер падает до того как можно зайти через exec

📖 **Копирование файлов**:
• `docker cp <container>:/path/file ./local_file` — из контейнера на хост
• `docker cp ./local_file <container>:/path/file` — с хоста в контейнер
• Работает даже с остановленными контейнерами!

📖 **Анализ изменений**:
• `docker diff <container>` — изменения файловой системы относительно образа
• A = Added, C = Changed, D = Deleted
• Помогает понять что контейнер делает с диском

📖 **Сетевой debug внутри контейнера**:
• Установка инструментов: `apk add iputils tcpdump netcat-openbsd` (alpine)
• `ping db` — проверить DNS-резолвинг
• `nc -zv db 5432` — проверить доступность порта
• `ip addr` — сетевые интерфейсы
• `ip route` — таблица маршрутизации

📖 **Минимальные образы**:
• `scratch` — пустой образ (только статически скомпранный бинарник)
• `distroless` — нет оболочки, только приложение (от Google)
• `alpine` — минимальный Linux (~5MB), есть apk

📖 **Полезные комбинации jq для диагностики**:
```bash
# Все остановленные контейнеры с кодами выхода
docker ps -a --format json | jq 'select(.Status | test("Exited")) | {Names, Status}'

# Контейнеры без лимитов памяти
docker ps -q | xargs -I{} docker inspect {} | \
  jq '.[] | select(.HostConfig.Memory == 0) | .Name'

# Порты всех работающих контейнеров
docker ps --format json | jq '.Names + ": " + (.Ports // "none")'
```

📂 Рабочий каталог: `~/.ninja_trainer/docker_012`

📋 **Попробуй**:
1. Запусти alpine с shell вместо sleep: `docker run -it --rm --entrypoint sh alpine`
2. Внутри: `apk add iputils && ping -c 2 google.com`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"; score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Продвинутая отладка освоена! (баллов: $score/1)"; exit 0; }
echo "✗ Нужен работающий Docker"
exit 1

HINTS
Override entrypoint: docker run -it --entrypoint sh image — зайти вместо CMD
Copy from container: docker cp <c>:/path/file ./local_copy
Copy to container: docker cp ./file <c>:/path/
Diff filesystem: docker diff <c> — A=added C=changed D=deleted
Network debug: apk add iputils tcpdump netcat-openbsd (alpine)
Ping test: ping -c 2 hostname — DNS + connectivity
Port test: nc -zv hostname port — доступность порта
Minimal images: scratch (empty), distroless (no shell), alpine (~5MB)
