META
# Track: netdebug
# Title: Карта магических потоков
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #001: Карта магических потоков

Архиканцлер развернул на столе карту Башни:
«Ринсвинд! Магические потоки пронизывают весь Плоский мир.
Ты должен знать СВОЙ адрес, свой шлюз, свой путь к остальному миру.
Иначе как ты отправишь заклинание? Как получишь ответ?
Последний студент, который не знал свой IP, три дня звал на помощь.
Помощь пришла. Из другого измерения.»

───────────────────────────────────────
🔹 IP-АДРЕСА И ИНТЕРФЕЙСЫ
───────────────────────────────────────

```bash
ip addr                    # Все IP-адреса и интерфейсы (Linux)
ifconfig                   # То же самое на macOS/BSD
ip addr show en0           # Конкретный интерфейс
```

• IPv4 адрес: `192.168.1.5` — твой уникальный адрес в сети
• Маска подсети: `/24` = `255.255.255.0` — кто «рядом» с тобой
• Loopback: `127.0.0.1` — ты сам! Всегда доступен.

───────────────────────────────────────
🔹 МАРШРУТИЗАЦИЯ — КУДА ИДУТ ЗАКЛИНАНИЯ
───────────────────────────────────────

```bash
ip route                   # Таблица маршрутизации (Linux)
netstat -rn                # Альтернатива (macOS/Linux)
```

• Шлюз по умолчанию (default gateway): куда идут пакеты за пределы твоей сети
• Если шлюз недоступен — ВНЕШНИЙ мир недоступен!

───────────────────────────────────────
🔹 PING — ПРОВЕРКА СВЯЗИ
───────────────────────────────────────

```bash
ping -c 4 127.0.0.1       # Себя (всегда должно работать!)
ping -c 4 192.168.1.1     # Шлюз (роутер)
ping -c 4 8.8.8.8         # Внешний мир (Google DNS)
ping -c 4 google.com      # По имени (проверка DNS!)
```

• `ping` работает на ICMP — если заблокирован, хост может быть доступен через HTTP!
• `time=XX ms` — задержка (RTT). Чем меньше — тем быстрее.

📂 Рабочий каталог: `~/.termtrainer/netdebug_001`

ASSIGNMENT
📋 **Попробуй**:
1. `ip addr | grep "inet "` или `ifconfig | grep "inet "` — свои IP
2. `netstat -rn | grep default` — шлюз
3. `ping -c 3 google.com` — проверить связь с миром

VALIDATION
#!/bin/bash
score=0

ips=$(ip addr 2>/dev/null | grep -c "inet " || ifconfig 2>/dev/null | grep -c "inet ")
[ "$ips" -ge 1 ] && { echo "✓ IP-адреса найдены"; score=$((score+1)); }

gw=$(netstat -rn 2>/dev/null | grep default | head -1 || ip route 2>/dev/null | grep default | head -1)
[ -n "$gw" ] && { echo "✓ Шлюз определён"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Карта потоков освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
IP addresses: ip addr (Linux) или ifconfig (macOS) — свои адреса
Default gateway: ip route | grep default или netstat -rn | grep default
Ping self: ping 127.0.0.1 — всегда должно работать!
Ping gateway: ping <gateway_IP> — доступен ли роутер?
Ping external: ping 8.8.8.8 — доступен ли внешний мир?
Ping by name: ping google.com — работает ли DNS?
ICMP blocked: если ping не отвечает — может быть firewall, а не обрыв
