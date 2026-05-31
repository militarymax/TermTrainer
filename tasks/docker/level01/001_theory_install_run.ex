META
# Track: docker
# Title: Первые сосуды
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Первые сосуды**

В Башне Алхимика контейнеры — магические сосуды, в которых варятся сервисы. Каждый сосуд изолирован от внешнего мира, но может общаться через специальные каналы. Научись управлять сосудами!

📖 **Установка и проверка**:
• **macOS**: `brew install --cask docker` (Docker Desktop)
• **Linux**: `curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $USER`
• Проверка: `docker version` и `docker info`

📖 **Жизненный цикл контейнера**:
• `docker run` — создать и запустить контейнер
• `docker ps` — работающие контейнеры (`-a` — все, включая остановленные)
• `docker stop <id>` — остановить (SIGTERM → SIGKILL)
• `docker start <id>` — запустить остановленный
• `docker restart <id>` — перезапустить
• `docker rm <id>` — удалить остановленный контейнер
• `docker kill <id>` — убить немедленно (SIGKILL)

📖 **Ключевые флаги docker run**:
• `-d` — запустить в фоне (detached)
• `-it` — интерактивный режим (с терминалом)
• `--name myapp` — дать имя контейнеру
• `--rm` — удалить после остановки
• `-p 8080:80` — проброс порта (хост:контейнер)

📖 **Примеры**:
```bash
docker run -d --name web -p 8080:80 nginx    # nginx на порту 8080
docker ps                                      # посмотреть работающие
docker logs web                                # логи контейнера
docker stop web                                # остановить
docker rm web                                  # удалить
```

📂 Рабочий каталог: `~/.ninja_trainer/docker_001`

📋 **Попробуй**:
1. Проверь установку: `docker version`
2. Запусти: `docker run -d --name hello -p 8080:80 nginx`
3. Посмотри: `docker ps`
4. Останови: `docker stop hello && docker rm hello`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null; then
  echo "✓ docker установлен"
  score=$((score+1))
else
  echo "✗ docker не установлен"
fi

if docker info &>/dev/null; then
  echo "✓ Docker daemon работает"
  score=$((score+1))
else
  echo "✗ Docker daemon не запущен"
fi

[ $score -ge 1 ] && { echo "✓ ok: Первые сосуды готовы! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно установить Docker"
exit 1

HINTS
Установка macOS: brew install --cask docker или скачай с docker.com
Установка Linux: curl -fsSL https://get.docker.com | sh
Добавить себя в группу: sudo usermod -aG docker $USER (Linux)
Проверка: docker version — клиент + сервер
Daemon не работает? macOS: открой Docker Desktop. Linux: sudo systemctl start docker
Run detached: docker run -d --name myapp nginx
Stop + remove: docker stop myapp && docker rm myapp
