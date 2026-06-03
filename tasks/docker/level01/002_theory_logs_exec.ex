META
# Track: docker
# Title: Записи и духи сосудов
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #002: Записи и духи сосудов

Декан Чартер заглянул в подвал:
«Ринсвинд! Сосуд работает — но ЧТО внутри? Какие записи он ведёт?
Какой демон там обитает? Научись читать записи сосудов
и проникать внутрь — или будешь гадать по звуку.
А звуки в подвалах... они обманчивы.»

───────────────────────────────────────
🔹 ЗАПИСИ СОСУДА (docker logs)
───────────────────────────────────────

```bash
docker logs web                  # Все записи сосуда
docker logs -f web               # Следить за записями (как tail -f)
docker logs --tail 20 web        # Последние 20 строк
docker logs --since 5m web      # Записи за последние 5 минут
```

• Каждый сосуд ведёт хронологию событий
• `-f` — следить в реальном времени (Ctrl+C для выхода)
• Записи сохраняются даже после остановки сосуда!

───────────────────────────────────────
🔹 ПРОНИКНОВЕНИЕ В СОСУД (docker exec)
───────────────────────────────────────

```bash

ASSIGNMENT
docker exec web ls /             # Выполнить команду внутри сосуда
docker exec -it web bash         # Открыть оболочку внутри!
docker exec web cat /etc/hosts   # Прочитать файл внутри сосуда
```

• `exec` — запустить команду ВНУТРИ работающего сосуда
• `-it` — интерактивный режим (нужен терминал)
• Это как войти в сосуд и оглядеться!

───────────────────────────────────────
🔹 ОБРАЗЫ — РЕЦЕПТЫ СОСУДОВ
───────────────────────────────────────

```bash
docker pull nginx:latest         # Скачать рецепт из Хранилища
docker images                    # Список скачанных рецептов
docker rmi nginx:latest          # Удалить рецепт
```

• Образ (image) = рецепт, по которому создаётся сосуд
• Сосуд (container) = воплощённый образ
• Один образ → много сосудов!

📂 Рабочий каталог: `~/.termtrainer/docker_002`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/docker_002

📋 **Попробуй**:
1. `docker run -d --name web nginx`
2. `docker logs web` — что пишет сосуд?
3. `docker exec web ls /usr/share/nginx/html` — файлы внутри
4. `docker exec -it web bash` — войти внутрь! (`exit` для выхода)
5. `docker stop web && docker rm web`

VALIDATION
#!/bin/bash
score=0

docker run -d --name tower_test_logs nginx &>/dev/null && sleep 2

logs=$(docker logs tower_test_logs 2>&1 | head -3)
[ -n "$logs" ] && { echo "✓ Записи прочитаны"; score=$((score+1)); }

exec_out=$(docker exec tower_test_logs ls / 2>&1 | head -3)
[ -n "$exec_out" ] && { echo "✓ exec работает"; score=$((score+1)); }

docker stop tower_test_logs &>/dev/null; docker rm tower_test_logs &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Записи и exec освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Logs: docker logs <name> — прочитать записи сосуда
Follow logs: docker logs -f <name> — следить в реальном времени
Tail logs: docker logs --tail N <name> — последние N строк
Exec: docker exec <name> command — выполнить команду внутри сосуда
Shell inside: docker exec -it <name> bash — открыть оболочку внутри
Pull image: docker pull nginx:latest — скачать рецепт из хранилища
List images: docker images — список скачанных рецептов
Remove image: docker rmi <image> — удалить рецепт
