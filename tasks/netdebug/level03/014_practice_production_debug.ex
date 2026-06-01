META
# Track: netdebug
# Title: Production-отладка сети
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🏭 **Production-отладка сети**

Production-сценарий: задержки скачут, соединения рвутся. Используй все инструменты для глубокого анализа.

📋 **Задания**:

1. **TLS-анализ сертификата**:
   ```bash
   echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | \
     openssl x509 -noout -subject -dates -issuer
   ```
   Когда истекает сертификат? Кто выдал?

2. **Сравни TLS-параметры разных сайтов**:
   ```bash
   for site in google.com github.com cloudflare.com; do
     proto=$(echo | openssl s_client -connect $site:443 -servername $site 2>/dev/null | grep "Protocol")
     cipher=$(echo | openssl s_client -connect $site:443 -servername $site 2>/dev/null | grep "Cipher")
     echo "$site: $proto | $cipher"
   done
   ```

3. **DNS trace — полный путь резолвинга**:
   `dig +trace google.com 2>&1 | head -40`
   Сколько серверов участвуют?

4. **Обратный DNS для диапазона** (скрипт на bash):
   ```bash
   for i in $(seq 1 5); do
     name=$(dig -x 8.8.8.$i +short 2>/dev/null)
     echo "{\"ip\":\"8.8.8.$i\",\"name\":\"$name\"}"
   done | jq -s '.'
   ```

5. **Мониторинг TCP-соединений в реальном времени**:
   ```bash
   # Количество соединений по состоянию каждую секунду
   for i in $(seq 1 10); do
     estab=$(ss -t state established 2>/dev/null | wc -l)
     tw=$(ss -t state time-wait 2>/dev/null | wc -l)
     cw=$(ss -t state close-wait 2>/dev/null | wc -l)
     echo "{\"time\":\"$(date +%H:%M:%S)\",\"estab\":$estab,\"timewait\":$tw,\"closewait\":$cw}"
     sleep 1
   done
   ```

6. **Полный HTTP-профайлинг через curl + jq**:
   ```bash
   curl -s -o /dev/null -w "{\"dns\":%{time_namelookup},\"tcp\":%{time_connect},\"tls\":%{time_appconnect},\"ttfb\":%{time_starttransfer},\"total\":%{time_total},\"code\":%{http_code}}\n" https://google.com | jq '.'
   ```

7. **Скрипт проверки срока сертификатов**:
   Напиши `cert_check.sh` который принимает список доменов и выводит JSON с датами истечения:
   ```bash
   #!/bin/bash
   for domain in "$@"; do
     expiry=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | \
       openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
     echo "{\"domain\":\"$domain\",\"expires\":\"$expiry\"}"
   done | jq -s '.'
   ```
   Сохрани в `$DIR/cert_check.sh` и запусти:
   `bash cert_check.sh google.com github.com`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_014"
score=0

cert=$(echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | openssl x509 -noout -dates 2>/dev/null)
[ -n "$cert" ] && { echo "✓ TLS-анализ работает"; score=$((score+1)); }

rdns=$(dig -x 8.8.8.8 +short 2>/dev/null)
[ -n "$rdns" ] && { echo "✓ Обратный DNS: $rdns"; score=$((score+1)); }

if [ -f "$DIR/cert_check.sh" ]; then
  out=$(bash "$DIR/cert_check.sh" google.com 2>&1)
  echo "$out" | grep -q "expires" && { echo "✓ cert_check.sh работает"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Production-отладка освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Cert dates: echo | openssl s_client host:443 2>/dev/null | openssl x509 -noout -dates
TLS compare: loop sites → openssl s_client → grep Protocol/Cipher
DNS trace: dig +trace domain — полный путь от корневых серверов
Reverse DNS range: for i in seq; do dig -x IP +short; done | jq -s
TCP monitor: loop ss -t state X → count → JSON → jq analysis
Curl profiling: curl -w json_format URL | jq '.' — полный тайминг как JSON
Cert check script: loop domains → openssl → extract dates → JSON output
JQ array: pipe multiple JSON objects through jq -s '.' to create array
