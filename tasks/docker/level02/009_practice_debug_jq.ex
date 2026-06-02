META
# Track: docker
# Title: Расследование сосудов
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #009: Расследование сосудов

Декан Чартер влетел в лабораторию:
«Ринсвинд! Один из сосудов ведёт себя странно — жрёт память,
пишет ошибки, и никто не знает ПОЧЕМУ. Мне нужен полный допрос!
Извлеки ВСЁ через inspect+jq — IP, env, volumes, порты,
статус, образ. И не забудь про docker diff — что изменилось внутри?»

📋 **Задания**:

1. **Запусти подозрительный сосуд**:
   ```bash
   docker run -d --name suspect \
     -e SECRET_KEY=forbidden_knowledge \
     -e DEBUG=true \
     -v /tmp:/host_tmp \
     -p 9999:80 \
     nginx
   ```

2. **Полный допрос через jq**:
   ```bash
   # Статус и здоровье
   docker inspect suspect | jq '{status: .[0].State.Status, running: .[0].State.Running, started: .[0].State.StartedAt}'
   
   # Сеть
   docker inspect suspect | jq '{ip: .[0].NetworkSettings.IPAddress, ports: .[0].NetworkSettings.Ports}'
   
   # Переменные окружения (ищем секреты!)
   docker inspect suspect | jq '.[0].Config.Env[]' 
   
   # Тома (что подключено?)
   docker inspect suspect | jq '.[0].Mounts[] | {source: .Source, dest: .Destination}'
   ```

3. **Что изменилось внутри?**:
   ```bash
   docker exec suspect sh -c "echo 'MWAHAHA' > /tmp/hacked.txt"
   docker diff suspect    # A = добавлено, C = изменено, D = удалено
   ```

4. **Сохрани отчёт расследования** `$DIR/investigation.txt`:
   ```bash
   {
     echo "═══ Vessel Investigation Report ═══"
     echo "Date: $(date)"
     echo ""
     echo "--- Status ---"
     docker inspect suspect | jq -r '"\(.Status) since \(.StartedAt)"' --arg S "$(docker inspect suspect | jq -r '.[0].State.Status')" --arg T "$(docker inspect suspect | jq -r '.[0].State.StartedAt')" <<< "{\"Status\":\"$S\",\"StartedAt\":\"$T\"}"
     echo ""
     echo "--- Network ---"
     docker inspect suspect | jq -r '.[0].NetworkSettings.IPAddress'
     echo ""
     echo "--- Secrets Found ---"
     docker inspect suspect | jq -r '.[0].Config.Env[]' | grep -i secret || echo "(none)"
     echo ""
     echo "--- Modified Files ---"
     docker diff suspect
     echo ""
     echo "═══ End of Investigation ═══"
   } > "$DIR/investigation.txt"
   cat "$DIR/investigation.txt"
   ```

5. Очистка: `docker stop suspect && docker rm suspect`

📂 Рабочий каталог: `~/.termtrainer/docker_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_009"
score=0

docker run -d --name tower_suspect -e SECRET=magic nginx &>/dev/null && sleep 2

ip=$(docker inspect tower_suspect | jq -r '.[0].NetworkSettings.IPAddress' 2>/dev/null)
[ -n "$ip" ] && { echo "✓ IP извлечён"; score=$((score+1)); }

env=$(docker inspect tower_suspect | jq -r '.[0].Config.Env[]' 2>/dev/null | grep SECRET)
[ -n "$env" ] && { echo "✓ Секрет найден: $env"; score=$((score+1)); }

diff_out=$(docker diff tower_suspect 2>&1)
[ -n "$diff_out" ] && { echo "✓ Diff работает"; score=$((score+1)); }

docker stop tower_suspect &>/dev/null; docker rm tower_suspect &>/dev/null

[ $score -ge 2 ] && { echo "✓ ok: Расследование освоено! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Inspect JSON: docker inspect <name> — полная информация как JSON
jq filter: docker inspect X | jq '.[0].NetworkSettings.IPAddress'
jq Env: docker inspect X | jq '.[0].Config.Env[]' — переменные окружения
jq Mounts: docker inspect X | jq '.[0].Mounts[]' — подключённые тома
jq State: docker inspect X | jq '.[0].State.Status' — статус контейнера
docker diff: показать какие файлы добавлены(A)/изменены(C)/удалены(D) внутри
Report: перенаправить вывод > file.txt для сохранения отчёта
