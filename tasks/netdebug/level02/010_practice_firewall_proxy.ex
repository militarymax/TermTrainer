META
# Track: netdebug
# Title: Стены и привратники
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #010: Стены и привратники

Архиканцлер указал на массивную дверь:
«Ринсвинд! За этой стеной — firewall. Он решает, какие заклинания
проходят, а какие — нет. NAT подменяет адреса отправителей.
Proxy притворяется тобой. Нужно уметь отличать обрыв от блокировки!»

📋 **Задания**:

1. **Отличить обрыв от блокировки**:
   ```bash
   # Обрыв: timeout (никто не отвечает)
   nc -zv -w 3 10.255.255.1 80    # Несуществующий IP → timeout
   
   # Блокировка: connection refused (порт закрыт!)
   nc -zv -w 3 localhost 9999     # Никто не слушает → refused
   
   # Открытый порт: succeeded!
   nc -zv -w 3 google.com 443    # → succeeded!
   ```

2. **Проверь NAT**:
   ```bash
   # Внутренний IP vs внешний IP
   ip addr | grep "inet " | grep -v 127.0.0.1    # Внутренний
   curl -s https://ifconfig.me                     # Внешний!
   # Если они разные — ты за NAT!
   ```

3. **Напиши `port_scan.sh`** — быстрый сканер портов:
   ```bash
   #!/bin/bash
   HOST="${1:-google.com}"
   echo "═══ Port Scan: $HOST ═══"
   for PORT in 22 80 443 3306 5432 6379 8080 8443; do
     if nc -zv -w 2 "$HOST" "$PORT" 2>/dev/null; then
       echo "✓ $PORT OPEN"
     else
       echo "✗ $PORT closed/filtered"
     fi
   done
   echo "═══ Scan Complete ═══"
   ```

4. **HTTP через proxy** (если есть):
   ```bash
   curl -x http://proxy:8080 https://google.com    # Через HTTP proxy
   curl --socks5 host:1080 https://google.com       # Через SOCKS5
   ```

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_010"
score=0

ext_ip=$(curl -s --connect-timeout 5 https://ifconfig.me 2>/dev/null)
[ -n "$ext_ip" ] && { echo "✓ Внешний IP: $ext_ip"; score=$((score+1)); }

if [ -f "$DIR/port_scan.sh" ]; then
  chmod +x "$DIR/port_scan.sh"
  out=$(bash "$DIR/port_scan.sh" google.com 2>&1)
  echo "$out" | grep -q "443\|OPEN\|Scan" && { echo "✓ port_scan.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Firewall и NAT освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Timeout vs Refused: timeout = обрыв/фильтр, refused = порт закрыт но хост доступен
NAT detection: внутренний IP ≠ внешний IP = ты за NAT
External IP: curl ifconfig.me — узнать свой внешний адрес
Port scan: nc -zv -w N host port — проверить открыт ли порт
Common ports: 22=SSH, 80=HTTP, 443=HTTPS, 3306=MySQL, 5432=PostgreSQL
HTTP proxy: curl -x http://proxy:port URL — запрос через прокси
SOCKS5 proxy: curl --socks5 host:port URL — через SOCKS прокси
