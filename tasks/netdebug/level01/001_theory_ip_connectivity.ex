META
# Track: netdebug
# Title: Карта сети
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Карта сети**

Прежде чем расследовать проблемы — нужно понимать карту: свой IP, шлюз, DNS. Это основа любого сетевого расследования.

📖 **IP-адреса и интерфейсы**:
• `ip addr` или `ifconfig` — все IP-адреса и интерфейсы
• `ip addr show eth0` — конкретный интерфейс
• IPv4 адрес: `192.168.1.5`, маска: `/24` (255.255.255.0)
• Loopback: `127.0.0.1` — локальный интерфейс

📖 **Маршрутизация**:
• `ip route` или `route -n` — таблица маршрутизации
• Шлюз по умолчанию (default gateway): куда идут пакеты за пределы сети
• `default via 192.168.1.1 dev eth0`

📖 **Проверка связности**:
• `ping -c 4 8.8.8.8` — проверить связь с внешним IP
• `ping -c 4 192.168.1.1` — проверить связь со шлюзом
• RTT = Round Trip Time (время туда-обратно)
• Потери пакетов = packet loss (%)

📖 **DNS**:
• `/etc/resolv.conf` — какие DNS-серверы используются
• `dig google.com` — запрос A-записи
• `nslookup google.com` — простой DNS-запрос
• `host google.com` — ещё один вариант

📖 **Порты TCP/UDP**:
• Общеизвестные порты: 22 (SSH), 80 (HTTP), 443 (HTTPS), 53 (DNS)
• `ss -tulpn` — слушающие порты на вашей машине
• `netstat -tulpn` — альтернатива (устаревшая)

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_001`

📋 **Попробуй**:
1. Свой IP: `ip addr | grep "inet "`
2. Шлюз: `ip route | grep default`
3. DNS: `cat /etc/resolv.conf`
4. Пинг шлюза: `ping -c 4 $(ip route | grep default | awk '{print $3}')`
5. Пинг внешнего: `ping -c 4 8.8.8.8`
6. DNS-запрос: `dig google.com +short`

VALIDATION
#!/bin/bash
score=0

ip_addr=$(ip addr 2>/dev/null | grep -c "inet ")
[ "$ip_addr" -ge 1 ] && { echo "✓ IP-адреса найдены"; score=$((score+1)); }

def_route=$(ip route 2>/dev/null | grep -c default)
[ "$def_route" -ge 1 ] && { echo "✓ Маршрут по умолчанию есть"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Карта сети освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
IP addresses: ip addr или ifconfig — все интерфейсы и IP
Default route: ip route | grep default — шлюз по умолчанию
Ping gateway: ping -c 4 <gateway_ip> — связность со шлюзом
Ping external: ping -c 4 8.8.8.8 — связность с интернетом
DNS servers: cat /etc/resolv.conf — какие DNS используются
DNS query: dig google.com или nslookup google.com
Listening ports: ss -tulpn — какие порты открыты на машине
