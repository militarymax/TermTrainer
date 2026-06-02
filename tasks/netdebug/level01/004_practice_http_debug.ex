META
# Track: netdebug
# Title: HTTP-заклинания
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #004: HTTP-заклинания

Астролог Университета вызвал тебя в обсерваторию:
«Ринсвинд! Когда магический портал не открывается, нужно понять ПОЧЕМУ.
Какой код ответа? Сколько времени? Какой заголовок?
curl — это твой телескоп для HTTP. Научись читать звёзды ответов!»

📋 **Задания**:

ASSIGNMENT
1. **Базовый HTTP-запрос**:
   ```bash
   curl -v https://google.com 2>&1 | head -30    # Verbose — все детали!
   ```

2. **Только код ответа**:
   ```bash
   curl -s -o /dev/null -w "%{http_code}\n" https://google.com    # → 301/200
   ```

3. **Полный тайминг как JSON**:
   ```bash
   curl -s -o /dev/null -w '{"dns":%{time_namelookup},"tcp":%{time_connect},"tls":%{time_appconnect},"ttfb":%{time_starttransfer},"total":%{time_total},"code":%{http_code}}\n' https://google.com | jq '.'
   ```

4. **Заголовки ответа**:
   ```bash
   curl -sI https://google.com     # Только заголовки (HEAD запрос)
   ```

5. **POST-запрос с данными**:
   ```bash
   curl -X POST -d "spell=fireball&power=42" https://httpbin.org/post
   ```

6. **Напиши `http_check.sh`**:
   ```bash
   #!/bin/bash
   URL="${1:-https://google.com}"
   echo "═══ HTTP Check: $URL ═══"
   
   code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
   time=$(curl -s -o /dev/null -w "%{time_total}" "$URL")
   
   echo "Status: $code"
   echo "Time: ${time}s"
   [[ "$code" =~ ^2 ]] && echo "✅ Healthy!" || echo "❌ Problem!"
   ```

📂 Рабочий каталог: `~/.termtrainer/netdebug_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_004"
score=0

code=$(curl -s -o /dev/null -w "%{http_code}" https://google.com 2>/dev/null)
[ -n "$code" ] && { echo "✓ HTTP-запрос работает: $code"; score=$((score+1)); }

if [ -f "$DIR/http_check.sh" ]; then
  chmod +x "$DIR/http_check.sh"
  out=$(bash "$DIR/http_check.sh" https://google.com 2>&1)
  echo "$out" | grep -q "Status\|Healthy\|Problem" && { echo "✓ http_check.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: HTTP-отладка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Verbose: curl -v URL — все детали запроса и ответа
Status code: curl -w "%{http_code}" — только код (200/301/404/500...)
Timing JSON: curl -w json_format URL | jq '.' — полный профиль запроса
Headers only: curl -I URL или curl -sI — HEAD запрос (только заголовки)
POST data: curl -X POST -d "key=val" URL — отправить данные
Redirect follow: curl -L URL — следовать за перенаправлениями
Timeout: curl --connect-timeout 5 — ограничить время ожидания
