META
# Track: netdebug
# Title: Архимаг Сетей
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
👑 **Архимаг Сетей** (UBERBOSS)

Production-инцидент: «Всё сломалось!» — задержки скачут до секунд, часть пользователей не может подключиться. Расследуй от OSI Layer 1 до Layer 7, используя все инструменты.

📋 **БЛОК 1 — Layer 1-3: Связность и маршрутизация**:
1. Проверь интерфейсы: `ip addr | grep "inet "`
2. Проверь маршруты: `ip route | grep default`
3. Пинг шлюза: `ping -c 5 <gateway>`
4. Пинг внешний IP: `ping -c 5 8.8.8.8`
5. mtr отчёт: `mtr -r -c 10 google.com` (или traceroute)
6. Проверь MTU: `ping -c 3 -s 1472 -M do google.com`

📋 **БЛОК 2 — Layer 4: TCP и порты**:
7. TCP-состояния: `ss -t -a | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn`
8. Детали соединений: `ss -ti | head -30` (ищи retrans, rtt, cwnd)
9. Слушающие порты: `ss -tlnp | head -20`
10. Проверь конкретный порт: `nc -zv google.com 443 -w 3`

📋 **БЛОК 3 — Layer 7: DNS, HTTP, TLS**:
11. DNS-запросы: `dig google.com +short`, `dig @8.8.8.8 google.com +short`
12. DNS trace: `dig +trace google.com | tail -20`
13. HTTP-профайлинг:
    ```bash
    curl -s -o /dev/null -w "{\"dns\":%{time_namelookup},\"tcp\":%{time_connect},\"tls\":%{time_appconnect},\"ttfb\":%{time_starttransfer},\"total\":%{time_total},\"code\":%{http_code}}\n" https://google.com | jq '.'
    ```
14. TLS-анализ: `echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | openssl x509 -noout -subject -dates`
15. Обратный DNS: `dig -x $(dig google.com +short | head -1) +short`

📋 **БЛОК 4 — Захват трафика**:
16. Захвати трафик: `sudo tcpdump -i any -c 50 -nn -w "$DIR/incident.pcap"`
17. Прочитай pcap: `sudo tcpdump -r "$DIR/incident.pcap" -nn | head -20`
18. Фильтр SYN/RST: `sudo tcpdump -i any -c 20 'tcp[tcpflags] & (tcp-syn|tcp-rst) != 0' -nn`

📋 **БЛОК 5 — Автоматизация**:
19. Напиши полный скрипт диагностики `$DIR/full_diag.sh` который собирает ВСЁ в JSON:
    ```bash
    #!/bin/bash
    set -euo pipefail
    
    report=$(jq -n '{}')
    
    # IP addresses
    ips=$(ip addr 2>/dev/null | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}')
    report=$(echo "$report" | jq --arg ips "$ips" '.ips = ($ips | split("\n"))')
    
    # Gateway
    gw=$(ip route 2>/dev/null | grep default | awk '{print $3}')
    report=$(echo "$report" | jq --arg gw "$gw" '.gateway = $gw')
    
    # Ping stats
    ping_stats=$(ping -c 5 google.com 2>/dev/null | tail -1)
    report=$(echo "$report" | jq --arg ps "$ping_stats" '.ping_stats = $ps')
    
    # DNS
    dns_ip=$(dig google.com +short 2>/dev/null | head -1)
    report=$(echo "$report" | jq --arg dns "$dns_ip" '.dns_google = $dns')
    
    # HTTP timing
    http_json=$(curl -s -o /dev/null -w "{\"dns\":%{time_namelookup},\"tcp\":%{time_connect},\"tls\":%{time_appconnect},\"ttfb\":%{time_starttransfer},\"total\":%{time_total},\"code\":%{http_code}}" https://google.com --connect-timeout 10 2>/dev/null)
    report=$(echo "$report" | jq --argjson hj "$http_json" '.http_timing = $hj')
    
    # TCP states
    tcp_states=$(ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn | head -5)
    report=$(echo "$report" | jq --arg ts "$tcp_states" '.tcp_states = ($ts | split("\n"))')
    
    echo "$report" | jq '.'
    ```
    Сохрани и запусти!

20. Проанализируй результат через jq — какая фаза самая долгая?

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_016"
score=0
max=6

ip=$(ip addr 2>/dev/null | grep -c "inet ")
[ "$ip" -ge 1 ] && { echo "✓ IP определён"; score=$((score+1)); }

dns=$(dig google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает"; score=$((score+1)); }

timing=$(curl -s -o /dev/null -w "%{time_total}" https://google.com --connect-timeout 5 2>/dev/null)
[ -n "$timing" ] && { echo "✓ HTTP timing: ${timing}s"; score=$((score+1)); }

cert=$(echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null)
[ -n "$cert" ] && { echo "✓ TLS-анализ работает"; score=$((score+1)); }

if [ -f "$DIR/full_diag.sh" ]; then
  chmod +x "$DIR/full_diag.sh"
  out=$(bash "$DIR/full_diag.sh" 2>&1 | head -20)
  echo "$out" | grep -q "ips\|dns\|http\|tcp" && { echo "✓ full_diag.sh работает"; score=$((score+1)); }
fi

rdns=$(dig -x 8.8.8.8 +short 2>/dev/null)
[ -n "$rdns" ] && { echo "✓ Обратный DNS"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 4 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
IP/interfaces: ip addr — свои адреса
Gateway: ip route | grep default — шлюз по умолчанию
Ping gateway → ping external → если IP ок но имя нет → DNS проблема
MTR: mtr -r -c 10 host — потери по хопам
MTU: ping -s 1472 -M do host — проверить фрагментацию

=== БЛОК 2 ===
TCP states: ss -t -a | awk → sort | uniq -c — распределение состояний
SS detail: ss -ti — RTT, CWND, retransmissions per socket
Listening ports: ss -tlnp — кто слушает на каких портах
Port check: nc -zv host port -w 3 — открыт ли порт

=== БЛОК 3 ===
DNS: dig domain +short / dig @server domain / dig +trace / dig -x IP
HTTP profiling: curl -w json_format URL | jq '.' — полный тайминг как JSON
TLS cert: openssl s_client | openssl x509 -noout -dates — срок сертификата

=== БЛОК 4 ===
tcpdump capture: sudo tcpdump -i any -c N -nn -w file.pcap
Read pcap: sudo tcpdump -r file.pcap -nn
SYN/RST filter: tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-rst) != 0'

=== БЛОК 5 ===
Full diag script: collect IP/gateway/DNS/ping/TCP/TLS into one JSON via jq
JQ merge: jq -n '{}' | jq --arg key val '.field = $key' to build JSON incrementally
