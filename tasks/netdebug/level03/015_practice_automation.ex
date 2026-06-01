META
# Track: netdebug
# Title: Автоматизация сетевой диагностики
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🤖 **Автоматизация сетевой диагностики**

Ручные проверки — хорошо. Автоматизированный сбор диагностики — лучше. Напиши скрипты для непрерывного мониторинга.

📋 **Задания**:

1. **Скрипт непрерывного мониторинга RTT**:
   Напиши `rtt_monitor.sh`:
   ```bash
   #!/bin/bash
   HOST="${1:-google.com}"
   INTERVAL="${2:-1}"
   while true; do
     rtt=$(ping -c 1 -W 2 "$HOST" 2>/dev/null | grep "time=" | sed 's/.*time=\([0-9.]*\).*/\1/')
     ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
     [ -n "$rtt" ] && echo "{\"ts\":\"$ts\",\"host\":\"$HOST\",\"rtt_ms\":$rtt}" || \
       echo "{\"ts\":\"$ts\",\"host\":\"$HOST\",\"rtt_ms\":null,\"error\":\"timeout\"}"
     sleep "$INTERVAL"
   done
   ```
   Сохрани в `$DIR/rtt_monitor.sh`

2. **Запусти мониторинг** (Ctrl+C для остановки):
   `bash $DIR/rtt_monitor.sh google.com 1 | head -20`

3. **Анализ через jq** — запусти 10 измерений и проанализируй:
   ```bash
   bash $DIR/rtt_monitor.sh google.com 0.5 | head -10 > $DIR/rtt_data.jsonl
   cat $DIR/rtt_data.jsonl | jq -s '[.[].rtt_ms | select(. != null)] | {min, max, avg: (add/length), count: length}'
   ```

4. **Скрипт проверки нескольких хостов**:
   Напиши `multi_check.sh`:
   ```bash
   #!/bin/bash
   HOSTS=("google.com" "github.com" "cloudflare.com")
   for h in "${HOSTS[@]}"; do
     dns_time=$(dig +short "$h" 2>/dev/null | head -1)
     http_code=$(curl -sI -o /dev/null -w "%{http_code}" "https://$h" --connect-timeout 5 2>/dev/null)
     http_time=$(curl -s -o /dev/null -w "%{time_total}" "https://$h" --connect-timeout 5 2>/dev/null)
     cert_date=$(echo | openssl s_client -connect "$h:443" -servername "$h" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
     echo "{\"host\":\"$h\",\"dns\":\"$dns_time\",\"http_code\":${http_code:-0},\"http_time\":${http_time:-0},\"cert_expires\":\"$cert_date\"}"
   done | jq -s '.'
   ```
   Сохрани в `$DIR/multi_check.sh` и запусти

5. **Порт-сканер на bash + jq**:
   Напиши `portscan.sh`:
   ```bash
   #!/bin/bash
   HOST="$1"
   [ -z "$HOST" ] && { echo "Usage: $0 <host>" >&2; exit 1; }
   for PORT in 22 80 443 3306 5432 6379 8080 8443 9090; do
     timeout 2 bash -c "echo >/dev/tcp/$HOST/$PORT" 2>/dev/null && \
       echo "{\"host\":\"$HOST\",\"port\":$PORT,\"status\":\"open\"}" || \
       echo "{\"host\":\"$HOST\",\"port\":$PORT,\"status\":\"closed\"}"
   done | jq -s '.'
   ```

6. **Полный отчёт о сети** — объединяющий скрипт `net_report.sh`:
   Собирает: IP, шлюз, DNS, ping stats, TCP states, listening ports, TLS certs
   Выводит один JSON-объект через jq

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_015"
score=0

if [ -f "$DIR/rtt_monitor.sh" ]; then
  chmod +x "$DIR/rtt_monitor.sh"
  out=$(timeout 5 bash "$DIR/rtt_monitor.sh" google.com 1 2>&1 | head -3)
  echo "$out" | grep -q "rtt_ms" && { echo "✓ rtt_monitor.sh работает"; score=$((score+1)); }
fi

if [ -f "$DIR/multi_check.sh" ]; then
  chmod +x "$DIR/multi_check.sh"
  out=$(bash "$DIR/multi_check.sh" 2>&1 | head -5)
  echo "$out" | grep -q "host" && { echo "✓ multi_check.sh работает"; score=$((score+1)); }
fi

if [ -f "$DIR/portscan.sh" ]; then
  chmod +x "$DIR/portscan.sh"
  out=$(bash "$DIR/portscan.sh" google.com 2>&1 | head -5)
  echo "$out" | grep -q "port" && { echo "✓ portscan.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Автоматизация диагностики освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Напиши скрипты мониторинга (баллов: $score/3)"
exit 1

HINTS
RTT monitor: loop → ping → extract time → JSON output → pipe to file or jq
JQ analysis: cat data.jsonl | jq -s '[.[].field] | {min,max,avg:(add/length)}'
Multi-host check: loop hosts → dig/curl/openssl → JSON per host → jq -s array
Port scanner: loop ports → /dev/tcp test → JSON status → jq -s array
Net report: combine IP/gateway/DNS/ping/TCP/TLS into one JSON object
Timeout control: timeout N command — ограничить время выполнения
JSON from bash: echo '{"key":"value"}' → pipe through jq for validation
Continuous output: while true loop → JSON lines → head -N to limit
