META
# Track: docker
# Title: Первые сосуды
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #001: Первые сосуды

Архиканцлер провёл тебя в подвалы Башни Алхимика:
«Ринсвинд! Видишь эти сосуды? Каждый — изолированный мир.
В одном варится зелье, в другом живёт демон, в третьем —
целый сервер. И ни один не знает о существовании других.
Пока мы не откроем канал. Научись управлять сосудами —
или последний сосуд, который ты случайно разбил,
потребует ещё трёх месяцев ремонта.»

───────────────────────────────────────
🔹 УСТАНОВКА И ПРОВЕРКА
───────────────────────────────────────

• **macOS**: `brew install --cask docker` (Docker Desktop)
• **Linux**: `curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $USER`
• Проверка: `docker version` и `docker info`

───────────────────────────────────────
🔹 ЖИЗНЕННЫЙ ЦИКЛ СОСУДА
───────────────────────────────────────

```bash
docker run nginx              # Создать и запустить сосуд
docker ps                     # Работающие сосуды (-a — все)
docker stop <id>              # Остановить (SIGTERM → SIGKILL)
docker start <id>             # Запустить остановленный
docker restart <id>           # Перезапустить
docker rm <id>                # Уничтожить остановленный сосуд
docker kill <id>              # Убить немедленно (SIGKILL)
```

⚠️ `stop` даёт процессу время на завершение. `kill` — мгновенная смерть!

───────────────────────────────────────
🔹 КЛЮЧЕВЫЕ ФЛАГИ docker run
───────────────────────────────────────

• `-d` — запустить в фоне (detached) — сосуд работает сам по себе
• `-it` — интерактивный режим (с терминалом)
• `--name myapp` — дать сосуду имя (иначе случайный хекс)
• `--rm` — уничтожить после остановки (одноразовый сосуд)
• `-p 8080:80` — проброс порта (внешний:внутренний)

```bash
docker run -d --name web -p 8080:80 nginx   # Nginx на порту 8080
docker logs web                              # Прочитать записи сосуда
docker stop web && docker rm web             # Остановить и уничтожить
```

📂 Рабочий каталог: `~/.termtrainer/docker_001`

ASSIGNMENT
📋 **Попробуй**:
1. `docker version` — проверить установку
2. `docker run -d --name hello nginx` — запустить первый сосуд
3. `docker ps` — увидеть работающий сосуд
4. `docker logs hello` — прочитать записи
5. `docker stop hello && docker rm hello` — очистить

VALIDATION
#!/bin/bash
score=0

docker version &>/dev/null && { echo "✓ Docker установлен"; score=$((score+1)); }

docker run -d --name tower_test_hello nginx &>/dev/null && { echo "✓ Сосуд запущен"; score=$((score+1)); }
sleep 2
docker ps | grep -q tower_test_hello 2>/dev/null && { echo "✓ Сосуд работает"; score=$((score+1)); }
docker stop tower_test_hello &>/dev/null; docker rm tower_test_hello &>/dev/null

[ $score -ge 2 ] && { echo "✓ ok: Первые сосуды освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Install macOS: brew install --cask docker → запустить Docker Desktop
Install Linux: curl -fsSL https://get.docker.com | sh
Check: docker version — проверить что Docker работает
Run: docker run -d --name myapp nginx — запустить сосуд в фоне
List: docker ps — работающие, docker ps -a — все
Logs: docker logs <name> — прочитать записи сосуда
Stop+Remove: docker stop <name> && docker rm <name>
Port mapping: -p 8080:80 — проброс порта хост→контейнер
