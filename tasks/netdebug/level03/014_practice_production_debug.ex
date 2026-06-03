META
# Track: netdebug
# Title: Production-расследование
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #014: Production-расследование

Архиканцлер вызвал тебя в командный центр:
«Ринсвинд! Production-сценарий: задержки скачут, соединения рвутся.
Используй ВСЕ инструменты для глубокого анализа.
TLS-сертификаты, DNS trace, HTTP profiling — всё в бой!»

📋 **Задания**:

ASSIGNMENT
1. **TLS-анализ сертификата**:
   ```bash
   echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | \
     openssl x509 -noout -subject -dates -issuer
   ```

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

4. **Обратный DNS для диапазона** (скрипт на bash):
   ```bash
   for i in $(seq 1 5); do
     name=$(dig -x 8.8.8.$i +short 2>/dev/null)
     echo "{\"ip\":\"8.8.8.$i\",\"name\":\"$name\"}"
   done | jq -s '.'
   ```

5. **Полный HTTP-профайлинг через curl + jq**:
   ```bash
   curl -s -o /dev/null -w '{"dns":%{time_namelookup},"tcp":%{time_connect},"tls":%{time_appconnect},"ttfb":%{time_starttransfer},"total":%{time_total},"code":%{http_code}}\n' https://google.com | jq '.'
   ```

6. **Напиши `cert_check.sh`** — проверка срока сертификатов:
   ```bash
   #!/bin/bash
   set -euo pipefail
   for domain in "$@"; do
     expiry=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | \
       openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
     echo "{\"domain\":\"$domain\",\"expires\":\"${expiry:-ERROR}\"}"
   done | jq -s '.'
   ```
   Сохрани в `$DIR/cert_check.sh` и запусти: `bash cert_check.sh google.com github.com`

📂 Рабочий каталог: `~/.termtrainer/netdebug_014`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_014

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_014"
score=0

cert=$(echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | openssl x509 -noout -dates 2>/dev/null)
[ -n "$cert" ] && { echo "✓ TLS-анализ работает"; score=$((score+1)); }

if [ -f "$DIR/cert_check.sh" ]; then
  out=$(bash "$DIR/cert_check.sh" google.com 2>&1)
  echo "$out" | grep -q "expires\|domain" && { echo "✓ cert_check.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Production-отладка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Cert dates: echo | openssl s_client host:443 2>/dev/null | openssl x509 -noout -dates
TLS compare: loop sites → openssl s_client → grep Protocol/Cipher
DNS trace: dig +trace domain — полный путь от корневых серверов
Reverse DNS range: for i in seq; do dig -x IP +short; done | jq -s
Curl profiling: curl -w json_format URL | jq '.' — полный тайминг как JSON
Cert check script: loop domains → openssl → extract dates → JSON output
JQ array: pipe multiple JSON objects through jq -s '.' to create array
