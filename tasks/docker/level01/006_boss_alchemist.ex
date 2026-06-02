META
# Track: docker
# Title: Экзамен Алхимика
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #006: Экзамен Алхимика

Архиканцлер встал во весь рост:
«Ринсвинд! ФИНАЛЬНЫЙ экзамен первого уровня!
Запусти веб-сервер, проверь его через curl,
извлеки IP через jq, собери свой образ и выведи отчёт.
Всё одним скриптом! И без ошибок!
Если справишься — допущу ко второму уровню.
Если нет... знаешь того кактуса? Он до сих пор колется.»

📋 **Боевые задания**:

ASSIGNMENT
1. **Запусти nginx** на порту 8888:
   ```bash
   docker run -d --name boss_web -p 8888:80 nginx
   ```

2. **Проверь через curl**:
   ```bash
   curl -s http://localhost:8888 | head -5
   ```

3. **Извлеки данные через jq**:
   ```bash
   docker inspect boss_web | jq '{ip: .[0].NetworkSettings.IPAddress, env: .[0].Config.Env, ports: .[0].NetworkSettings.Ports}'
   ```

4. **Собери отчёт** `$DIR/boss_report.txt`:
   ```bash
   {
     echo "═══ Alchemist Exam Report ═══"
     echo "Date: $(date)"
     echo ""
     echo "--- Container Status ---"
     docker ps --filter name=boss_web --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
     echo ""
     echo "--- Container IP ---"
     docker inspect boss_web | jq -r '.[0].NetworkSettings.IPAddress'
     echo ""
     echo "--- Nginx Response ---"
     curl -s -o /dev/null -w "HTTP Code: %{http_code}\nTime: %{time_total}s\n" http://localhost:8888
     echo ""
     echo "═══ End of Report ═══"
   } > "$DIR/boss_report.txt"
   cat "$DIR/boss_report.txt"
   ```

5. **Очисти**: `docker stop boss_web && docker rm boss_web`

📂 Рабочий каталог: `~/.termtrainer/docker_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_006"
score=0

docker run -d --name tower_boss -p 18888:80 nginx &>/dev/null && sleep 2

curl -s http://localhost:18888 &>/dev/null && { echo "✓ Nginx отвечает"; score=$((score+1)); }

ip=$(docker inspect tower_boss | jq -r '.[0].NetworkSettings.IPAddress' 2>/dev/null)
[ -n "$ip" ] && { echo "✓ IP извлечён через jq"; score=$((score+1)); }

if [ -f "$DIR/boss_report.txt" ]; then
  grep -q "Report\|Status\|IP\|HTTP" "$DIR/boss_report.txt" && { echo "✓ Отчёт создан"; score=$((score+1)); }
fi

docker stop tower_boss &>/dev/null; docker rm tower_boss &>/dev/null

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Экзамен Алхимика сдан! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Run: docker run -d --name web -p 8888:80 nginx
Curl: curl -s http://localhost:8888 — проверить ответ
Inspect+jq: docker inspect X | jq '.[0].NetworkSettings.IPAddress'
Report format: заголовок + статус + IP + HTTP код + время
Docker ps filter: docker ps --filter name=X --format "table {{.Names}}"
Curl timing: curl -w "%{http_code} %{time_total}" — код и время
Save: перенаправить вывод > report.txt
Cleanup: docker stop X && docker rm X
