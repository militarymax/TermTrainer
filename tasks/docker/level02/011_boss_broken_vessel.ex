META
# Track: docker
# Title: Сломанный сосуд
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #011: Сломанный сосуд

Архиканцлер ворвался в лабораторию:
«Ринсвинд! СОСУД СЛОМАЛСЯ! Он падает каждые 30 секунд!
Логи полны ошибок! Никто не знает что внутри!
Расследуй: почему падает? Что внутри? Какие секреты?
И ПОЧИНИ ЕГО! Используй ВСЁ: logs, inspect|jq, exec, diff.
Если не справишься — будешь вручную перезапускать его
каждые 30 секунд до конца семестра.»

📋 **Боевые задания**:

1. **Запусти сломанный сосуд**:
   ```bash
   docker run -d --name broken \
     -e DB_HOST=database \
     -e DB_PASSWORD=hunter2 \
     -e DEBUG=false \
     nginx
   ```

2. **Расследование** — собери данные:
   ```bash
   # Статус
   docker ps -a | grep broken
   docker inspect broken | jq '{status: .[0].State.Status, exitCode: .[0].State.ExitCode}'
   
   # Логи
   docker logs broken 2>&1 | tail -20
   
   # Переменные окружения
   docker inspect broken | jq '.[0].Config.Env[]'
   
   # Сеть
   docker inspect broken | jq '{ip: .[0].NetworkSettings.IPAddress, ports: .[0].NetworkSettings.Ports}'
   
   # Тома
   docker inspect broken | jq '.[0].Mounts'
   ```

3. **Напиши отчёт расследования** `$DIR/case_report.txt`:
   ```bash
   {
     echo "═══ Broken Vessel Case Report ═══"
     echo "Investigator: $(whoami)"
     echo "Date: $(date)"
     echo ""
     echo "--- Container Status ---"
     docker ps -a --filter name=broken --format "{{.Status}}"
     echo ""
     echo "--- Environment Variables ---"
     docker inspect broken | jq -r '.[0].Config.Env[]' 2>/dev/null
     echo ""
     echo "--- Network Info ---"
     docker inspect broken | jq -r '"IP: " + .[0].NetworkSettings.IPAddress' 2>/dev/null
     echo ""
     echo "--- Last 10 Log Lines ---"
     docker logs broken 2>&1 | tail -10
     echo ""
     echo "--- Diagnosis ---"
     echo "Container is running nginx but expects database at 'database'"
     echo "DB_HOST=database points to non-existent service"
     echo "Fix: connect to proper network or use compose with db service"
     echo ""
     echo "═══ End of Report ═══"
   } > "$DIR/case_report.txt"
   cat "$DIR/case_report.txt"
   ```

4. **Почини**: создай `docker-compose.yml` с nginx + postgres в одной сети

5. Очистка: `docker stop broken && docker rm broken`

📂 Рабочий каталог: `~/.termtrainer/docker_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_011"
score=0

docker run -d --name tower_broken -e SECRET=test nginx &>/dev/null && sleep 2

ip=$(docker inspect tower_broken | jq -r '.[0].NetworkSettings.IPAddress' 2>/dev/null)
[ -n "$ip" ] && { echo "✓ Inspect работает"; score=$((score+1)); }

env=$(docker inspect tower_broken | jq -r '.[0].Config.Env[]' 2>/dev/null)
echo "$env" | grep -q SECRET && { echo "✓ Секреты найдены"; score=$((score+1)); }

docker stop tower_broken &>/dev/null; docker rm tower_broken &>/dev/null

if [ -f "$DIR/case_report.txt" ]; then
  grep -q "Report\|Status\|Diagnosis\|Network" "$DIR/case_report.txt" && { echo "✓ Отчёт создан"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Сосуд расследован! (баллов: $score/3)"; exit 0; }
echo "✗ Расследуй сосуд (баллов: $score/3)"
exit 1

HINTS
Inspect status: docker inspect X | jq '.[0].State.Status' — запущен ли?
Logs: docker logs X — прочитать записи сосуда (stderr важнее stdout!)
Env vars: docker inspect X | jq '.[0].Config.Env[]' — переменные окружения
IP address: docker inspect X | jq '.[0].NetworkSettings.IPAddress'
Ports: docker inspect X | jq '.[0].NetworkSettings.Ports'
Docker diff: что изменилось внутри контейнера
Compose fix: создать docker-compose.yml с правильной сетью между сервисами
Report: собрать все данные в один файл отчёта
