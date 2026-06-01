META
# Track: netdebug
# Title: HTTP-расследование
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🌐 **HTTP-расследование**

Сайт не открывается? Нужно понять — проблема в DNS, в сети, в сервере или в приложении. curl — твой главный инструмент.

📋 **Задания**:

1. **Полный запрос с заголовками**: `curl -v https://httpbin.org/get 2>&1 | head -30`
   Обрати внимание на: DNS resolution, TCP connect, TLS handshake, HTTP response

2. **Только заголовки ответа**: `curl -sI https://httpbin.org/status/200`

3. **Разные коды ответа**:
   `curl -sI https://httpbin.org/status/404`
   `curl -sI https://httpbin.org/status/500`

4. **Время запроса**:
   `curl -s -o /dev/null -w "DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTLS: %{time_appconnect}s\nTotal: %{time_total}s\n" https://google.com`

5. **POST-запрос с данными**:
   `curl -s -X POST -d '{"name":"ninja"}' -H 'Content-Type: application/json' https://httpbin.org/post | jq '.'`

6. **Проверь редиректы**: `curl -sI -L https://httpbin.org/redirect/3`
   `-L` — следовать за редиректами

7. **Проверь через jq**: `curl -s https://httpbin.org/json | jq '.'`

8. **Таймаут**: `curl -s --connect-timeout 5 --max-time 10 https://httpbin.org/delay/3`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_004`

VALIDATION
#!/bin/bash
score=0

code=$(curl -sI -o /dev/null -w "%{http_code}" https://httpbin.org/status/200 --connect-timeout 10 2>/dev/null)
[ "$code" = "200" ] && { echo "✓ HTTP 200 получен"; score=$((score+1)); }

json=$(curl -s https://httpbin.org/json --connect-timeout 10 2>/dev/null)
[ -n "$json" ] && echo "$json" | jq -r '.slideshow.title' 2>/dev/null | grep -qi "sample" && { echo "✓ JSON + jq работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: HTTP-отладка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Проверь HTTP-запросы (баллов: $score/2)"
exit 1

HINTS
Verbose: curl -v URL — полный вывод: DNS, TCP, TLS, заголовки
Headers only: curl -sI URL — только заголовки ответа (HEAD-запрос)
Timing: curl -o /dev/null -w "DNS:%{time_namelookup} Connect:%{time_connect} Total:%{time_total}\n" URL
POST data: curl -X POST -d 'data' -H 'Content-Type: application/json' URL
Follow redirects: curl -L URL — следовать за 301/302
Timeout: curl --connect-timeout 5 --max-time 10 URL — ограничить время
JSON + jq: curl -s URL | jq '.' — красивый JSON-ответ
Status codes: 200=OK, 301=redirect, 404=not found, 500=server error
