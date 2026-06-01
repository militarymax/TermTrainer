META
# Track: netdebug
# Title: Сетевой детектив
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 **Сетевой детектив** (БОСС)

Архиканцлер сообщил: «Что-то не так с сетью!» Расследуй проблему от начала до конца, используя все инструменты.

📋 **Боевые задания**:

1. **Определи свой IP и интерфейс**: `ip addr | grep "inet "`
   Запиши свой IP и маску подсети.

2. **Найди шлюз**: `ip route | grep default`
   Какой шлюз по умолчанию?

3. **Пинг шлюза**: `ping -c 4 <gateway>`

4. **Пинг внешний IP**: `ping -c 4 8.8.8.8`

5. **Пинг по имени**: `ping -c 4 google.com`
   Если IP пингуется, а имя нет — проблема в DNS!

6. **Проверь DNS через dig**: `dig google.com +short`

7. **Альтернативный DNS**: `dig @1.1.1.1 google.com +short`

8. **Трассировка**: `traceroute google.com` или `tracepath google.com`

9. **Проверь HTTPS-порт**: `nc -zv google.com 443 -w 3`

10. **HTTP-запрос с таймингом**:
    `curl -s -o /dev/null -w "DNS:%{time_namelookup}s Connect:%{time_connect}s TLS:%{time_appconnect}s Total:%{time_total}s HTTP:%{http_code}\n" https://google.com`

11. **Скрипт быстрой диагностики на bash**:
    ```bash
    #!/bin/bash
    echo "=== IP ==="
    ip addr | grep "inet " | grep -v 127.0.0.1
    echo "=== GATEWAY ==="
    ip route | grep default
    echo "=== PING GW ==="
    ping -c 2 $(ip route | grep default | awk '{print $3}') 2>&1 | tail -2
    echo "=== PING 8.8.8.8 ==="
    ping -c 2 8.8.8.8 2>&1 | tail -2
    echo "=== DNS ==="
    dig google.com +short 2>/dev/null || echo "FAIL"
    echo "=== HTTP ==="
    curl -sI -o /dev/null -w "%{http_code} %{time_total}s\n" https://google.com --connect-timeout 5
    ```

12. **Сохрани скрипт**: запиши его в `$HOME/.ninja_trainer/netdebug_006/diag.sh`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_006"
score=0

ip=$(ip addr 2>/dev/null | grep -c "inet ")
[ "$ip" -ge 1 ] && { echo "✓ IP определён"; score=$((score+1)); }

gw=$(ip route 2>/dev/null | grep -c default)
[ "$gw" -ge 1 ] && { echo "✓ Шлюз найден"; score=$((score+1)); }

dns=$(dig google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает"; score=$((score+1)); }

if [ -f "$DIR/diag.sh" ]; then
  chmod +x "$DIR/diag.sh"
  output=$(bash "$DIR/diag.sh" 2>&1 | head -20)
  [ -n "$output" ] && { echo "✓ Скрипт диагностики работает"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Ты — сетевой детектив! (баллов: $score/4)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/4)"
exit 1

HINTS
IP address: ip addr | grep "inet " — свой IP и маска
Gateway: ip route | grep default — шлюз по умолчанию
Ping gateway: ping -c 4 <gw_ip> — связность со шлюзом
Ping external: ping -c 4 8.8.8.8 — связность с интернетом
DNS check: dig domain +short — работает ли DNS
Alt DNS: dig @1.1.1.1 domain +short — попробовать другой DNS сервер
Traceroute: traceroute host или tracepath host — путь до хоста
Port check: nc -zv host port -w 3 — открыт ли порт
Curl timing: curl -o /dev/null -w "DNS:%{time_namelookup} Total:%{time_total}\n" URL
Diag script: собрать все проверки в один bash-скрипт
