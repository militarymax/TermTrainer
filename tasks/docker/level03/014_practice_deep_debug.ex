META
# Track: docker
# Title: Глубокое расследование
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #014: Глубокое расследование

Архиканцлер вызвал тебя в Тайную Комнату:
«Ринсвинд! Мне нужен АВТОМАТИЗИРОВАННЫЙ допрос сосудов.
Напиши скрипт, который принимает имя сосуда и выдаёт
ПОЛНЫЙ отчёт: статус, сеть, env, volumes, процессы, ресурсы.
Всё через jq. Красиво. В один файл.
Чтобы любой студент мог запустить и понять что происходит.»

📋 **Задания**:

ASSIGNMENT
1. **Напиши `vessel_inspect.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   NAME="${1:?Usage: $0 <container_name>}"
   
   if ! docker ps -a --format '{{.Names}}' | grep -q "^${NAME}$"; then
       echo "ERROR: Vessel '$NAME' not found!" >&2; exit 1
   fi
   
   echo "═══ Vessel Inspection: $NAME ═══"
   echo ""
   
   echo "── Status ──"
   docker inspect "$NAME" | jq -r '"\(.State) | Started: \(.StartedAt)"' \
     --arg S "$(docker inspect "$NAME" | jq -r '.[0].State.Status')" \
     --arg T "$(docker inspect "$NAME" | jq -r '.[0].State.StartedAt')" \
     <<< "{\"State\":\"$S\",\"StartedAt\":\"$T\"}"
   
   echo ""
   echo "── Network ──"
   docker inspect "$NAME" | jq -r '.[0].NetworkSettings | {IP: .IPAddress, Gateway: .Gateway, Ports: .Ports}'
   
   echo ""
   echo "── Environment ──"
   docker inspect "$NAME" | jq -r '.[0].Config.Env[]'
   
   echo ""
   echo "── Volumes ──"
   docker inspect "$NAME" | jq -r '.[0].Mounts[]? | "\(.Source) → \(.Destination)"'
   
   echo ""
   echo "── Resources ──"
   docker stats --no-stream "$NAME" 2>/dev/null || echo "(not running)"
   
   echo ""
   echo "═══ End of Inspection ═══"
   ```

2. **Запусти тестовый сосуд и проверь**:
   ```bash
   docker run -d --name test_vessel -e SECRET=magic -p 9090:80 nginx
   chmod +x vessel_inspect.sh
   ./vessel_inspect.sh test_vessel
   ```

3. **Сохрани отчёт**: `./vessel_inspect.sh test_vessel > $DIR/report.txt`

4. Очистка: `docker stop test_vessel && docker rm test_vessel`

📂 Рабочий каталог: `~/.termtrainer/docker_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_014"
score=0

if [ -f "$DIR/vessel_inspect.sh" ]; then
  head -1 "$DIR/vessel_inspect.sh" | grep -q '^#!' && { echo "✓ Шебанг есть"; score=$((score+1)); }
  grep -q 'jq\|inspect' "$DIR/vessel_inspect.sh" && { echo "✓ Использует jq"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Глубокая отладка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Напиши vessel_inspect.sh (баллов: $score/2)"
exit 1

HINTS
Скрипт-отчёт: принять имя контейнера → собрать данные → вывести красиво
jq для inspect: извлечь State/Network/Env/Mounts из JSON
set -euo pipefail: священная троица безопасности
${1:?Usage}: обязательный аргумент с сообщением об ошибке
docker stats: мониторинг ресурсов контейнера
Перенаправление: ./script.sh > report.txt — сохранить отчёт в файл
Format check: docker ps -a --format '{{.Names}}' — список имён
