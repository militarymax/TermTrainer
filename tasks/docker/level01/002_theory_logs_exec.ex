META
# Track: docker
# Title: Наблюдение за сосудами
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/docker_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Наблюдение за сосудами**

Запустить сосуд — полдела. Нужно уметь заглядывать внутрь, читать показания и выполнять команды.

📖 **Логи контейнера**:
• `docker logs <name>` — все логи с начала работы
• `docker logs -f <name>` — следить за логами (как tail -f)
• `docker logs --tail 20 <name>` — последние 20 строк
• `docker logs --since 5m <name>` — логи за последние 5 минут
• `docker logs --until 2024-01-01T00:00:00 <name>` — до указанного времени

📖 **Выполнение команд внутри**:
• `docker exec -it <name> bash` — зайти в оболочку контейнера
• `docker exec -it <name> sh` — если нет bash (alpine)
• `docker exec <name> cat /etc/hostname` — выполнить команду без входа

📖 **Образы**:
• `docker pull nginx:alpine` — скачать образ
• `docker images` — список локальных образов
• `docker rmi nginx:alpine` — удалить образ
• `docker image prune` — удалить неиспользуемые образы

📖 **Проброс портов**:
• `-p 8080:80` — порт хоста 8080 → порт контейнера 80
• `-p 127.0.0.1:8080:80` — только localhost
• `-P` — пробросить все EXPOSE порты на случайные

📂 Рабочий каталог: `~/.ninja_trainer/docker_002`

📋 **Попробуй**:
1. Запусти: `docker run -d --name web -p 8080:80 nginx`
2. Логи: `docker logs web`
3. Следи: `docker logs -f --tail 5 web` (Ctrl+C для выхода)
4. Зайди внутрь: `docker exec -it web bash`
5. Внутри: `cat /etc/hostname && exit`

VALIDATION
#!/bin/bash
score=0

if command -v docker &>/dev/null && docker info &>/dev/null; then
  echo "✓ Docker работает"
  score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Наблюдение освоено! (баллов: $score/1)"; exit 0; }
echo "✗ Нужен работающий Docker"
exit 1

HINTS
Logs: docker logs <container> — весь вывод stdout/stderr
Follow: docker logs -f <container> — как tail -f
Tail N: docker logs --tail 50 <container> — последние N строк
Since: docker logs --since 10m <container> — за последние 10 минут
Exec bash: docker exec -it <container> bash — интерактивный вход
Exec command: docker exec <container> ls /app — одна команда
Pull: docker pull nginx:alpine — скачать без запуска
