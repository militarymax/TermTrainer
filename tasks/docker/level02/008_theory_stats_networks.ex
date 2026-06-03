META
# Track: docker
# Title: Пульс сосудов и магические сети
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #008: Пульс сосудов и магические сети

Астролог Университета приложил палец к стеклу сосуда:
«Ринсвинд! Каждый сосуд дышит — потребляет память, CPU, сеть.
Нужно уметь слушать его пульс. И ещё — сосуды могут общаться
через магические сети. Но только если ты их правильно настроишь.
Иначе они как два глухих мага в разных комнатах.»

───────────────────────────────────────
🔹 МОНИТОРИНГ — ПУЛЬС СОСУДА
───────────────────────────────────────

```bash
docker stats                    # Реальное время: CPU, RAM, NET, IO
docker stats --no-stream       # Один снимок
docker stats web db            # Конкретные сосуды
```

• `CPU %` — загрузка процессора
• `MEM USAGE / LIMIT` — память использовано / лимит
• `NET I/O` — входящий/исходящий трафик
• `BLOCK I/O` — чтение/запись на диск

📖 **События в реальном времени**:
```bash
docker events                   # Поток событий (создание, запуск, смерть...)
docker events --filter type=container
docker events --since 1h        # За последний час
```

───────────────────────────────────────
🔹 СЕТИ — МАГИЧЕСКИЕ КАНАЛЫ
───────────────────────────────────────

```bash
docker network ls               # Список сетей
docker network create tower_net # Создать свою сеть!
docker network inspect bridge   # Кто подключён к bridge?
```

📖 **Типы сетей**:
• `bridge` — по умолчанию; сосуды видят друг друга по IP
• `host` — сосуд использует сеть хоста напрямую
• `none` — изоляция, никакой сети
• Своя сеть — сосуды видят друг друга ПО ИМЕНИ!

```bash
docker run -d --name web --network tower_net nginx
docker run -d --name db --network tower_net postgres
# Теперь web может обратиться к db по имени "db"!
```

📂 Рабочий каталог: `~/.termtrainer/docker_008`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/docker_008
📋 **Попробуй**:
1. `docker stats --no-stream` — снимок пульса
2. `docker network ls` — список сетей
3. `docker network create tower_net && docker network inspect tower_net`
4. `docker network rm tower_net` — очистка

VALIDATION
#!/bin/bash
score=0

stats=$(docker stats --no-stream 2>&1 | head -3)
[ -n "$stats" ] && { echo "✓ Stats работает"; score=$((score+1)); }

nets=$(docker network ls 2>&1)
echo "$nets" | grep -q "bridge\|host" && { echo "✓ Сети видны"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Stats и сети освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Stats: docker stats — мониторинг в реальном времени
Stats snapshot: docker stats --no-stream — один снимок
Events: docker events — поток событий (create/start/die)
Network list: docker network ls — все сети
Network create: docker network create mynet — своя сеть
Network inspect: docker network inspect mynet — кто подключён
Custom network: контейнеры видят друг друга ПО ИМЕНИ сервиса
Host network: --network host — использовать сеть хоста напрямую
