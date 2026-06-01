META
# Track: netdebug
# Title: Нет интернета!
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🔌 **Нет интернета!**

Классический сценарий: «у меня нет интернета». Расследуй шаг за шагом, используя правильный порядок диагностики.

📋 **Задания** (выполняй по порядку!):

1. **Проверь свой IP**: `ip addr | grep "inet "`
   Есть ли IP-адрес? Если нет — проблема на уровне интерфейса.

2. **Проверь маршрут**: `ip route | grep default`
   Есть ли шлюз по умолчанию?

3. **Пинг шлюза**: `ping -c 4 <gateway_ip>`
   Шлюз доступен? Если нет — проблема в локальной сети.

4. **Пинг внешнего IP**: `ping -c 4 8.8.8.8`
   Внешний IP доступен? Если да, но DNS не работает — проблема в DNS.

5. **Проверь DNS**: `dig google.com +short`
   DNS резолвится? Если нет — попробуй другой DNS:
   `dig @8.8.8.8 google.com +short`

6. **Проверь HTTP**: `curl -sI https://google.com | head -3`
   HTTP работает? Какой код ответа?

7. **Трассировка маршрута**: `traceroute google.com` или `tracepath google.com`
   Где обрывается путь?

8. **Проверь порт через nc**: `nc -zv google.com 443 -w 3`

💡 **Алгоритм «нет интернета»**:
```
IP есть? → Шлюз пингуется? → Внешний IP пингуется?
→ DNS работает? → HTTP/HTTPS доступен?
```

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_003`

VALIDATION
#!/bin/bash
score=0

ip=$(ip addr 2>/dev/null | grep -c "inet ")
[ "$ip" -ge 1 ] && { echo "✓ IP-адрес есть"; score=$((score+1)); }

gw=$(ip route 2>/dev/null | grep -c default)
[ "$gw" -ge 1 ] && { echo "✓ Шлюз по умолчанию есть"; score=$((score+1)); }

dns=$(dig google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает"; score=$((score+1)); }

http_code=$(curl -sI -o /dev/null -w "%{http_code}" https://google.com 2>/dev/null)
[ "$http_code" = "200" ] || [ "$http_code" = "301" ] || [ "$http_code" = "302" ] && { echo "✓ HTTP работает ($http_code)"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Диагностика связности освоена! (баллов: $score/4)"; exit 0; }
echo "✗ Проверь сетевую связность (баллов: $score/4)"
exit 1

HINTS
Step 1 — IP: ip addr — если нет IP, проблема в интерфейсе/DHCP
Step 2 — Gateway: ip route | grep default — если нет шлюза, никуда не уйдёшь
Step 3 — Ping gateway: ping <gateway> — если шлюз не отвечает, проблема в LAN
Step 4 — Ping external: ping 8.8.8.8 — если внешний IP доступен, но сайты нет → DNS
Step 5 — DNS: dig domain +short или dig @8.8.8.8 domain +short (альтернативный DNS)
Step 6 — HTTP: curl -I URL — проверить код ответа и заголовки
Step 7 — Traceroute: traceroute host или tracepath host — где обрывается путь
Step 8 — Port check: nc -zv host port -w 3 — открыт ли конкретный порт
