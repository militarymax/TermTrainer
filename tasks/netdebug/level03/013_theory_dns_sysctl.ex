META
# Track: netdebug
# Title: Продвинутый DNS и тюнинг ядра
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Продвинутый DNS и тюнинг ядра**

DNS — не просто dig. А параметры ядра влияют на производительность TCP больше, чем вы думаете.

📖 **Продвинутые DNS-запросы**:
• `dig +trace google.com` — рекурсивный поиск от корневых серверов
• `dig +dnssec google.com` — проверить DNSSEC-подписи
• `dig AXFR domain.com @ns1.domain.com` — полная зона (если разрешено)
• `dig -x 8.8.8.8` — обратный DNS (IP → имя)
• `dig google.com ANY` — все записи (многие серверы не отвечают)

📖 **sysctl — параметры TCP/IP ядра** (Linux):
• `sysctl net.ipv4.tcp_congestion_control` — алгоритм контроля перегрузки
• `sysctl net.ipv4.tcp_rmem` — буфер приёма TCP (min/default/max)
• `sysctl net.ipv4.tcp_wmem` — буфер отправки TCP
• `sysctl net.core.somaxconn` — максимальная очередь listen
• `sysctl net.ipv4.tcp_max_syn_backlog` — очередь SYN
• `sysctl net.ipv4.tcp_tw_reuse` — переиспользование TIME-WAIT

📖 **netstat -s / nstat — глобальные счётчики**:
• `netstat -s | grep -i retrans` — повторные передачи
• `nstat -az | grep Tcp` — счётчики TCP (Linux)
• Смотрите на: retransmits, failed connections, reset connections

📖 **ethtool — статистика сетевой карты** (Linux):
• `ethtool -S eth0` — счётчики ошибок на интерфейсе
• `ethtool -g eth0` — размеры кольцевых буферов
• `ethtool -k eth0` — offloading настройки
• Важно: checksum offloading может показывать «битые» контрольные суммы в pcap!

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_013`

📋 **Попробуй**:
1. DNS trace: `dig +trace google.com | head -30`
2. Обратный DNS: `dig -x 8.8.8.8 +short`
3. DNSSEC: `dig +dnssec google.com | grep -E "RRSIG|flags"`
4. sysctl: `sysctl -a 2>/dev/null | grep tcp | head -20`

VALIDATION
#!/bin/bash
score=0

trace=$(dig +trace google.com +short 2>/dev/null | head -1)
[ -n "$trace" ] && { echo "✓ DNS trace работает"; score=$((score+1)); }

rdns=$(dig -x 8.8.8.8 +short 2>/dev/null | head -1)
[ -n "$rdns" ] && { echo "✓ Обратный DNS: $rdns"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Продвинутый DNS и тюнинг освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
DNS trace: dig +trace domain — рекурсивный путь от корневых серверов
Reverse DNS: dig -x IP +short — IP → доменное имя
DNSSEC: dig +dnssec domain — проверить цифровые подписи DNS
AXFR zone: dig AXFR domain @nameserver — полная зона (если разрешено)
sysctl TCP: sysctl net.ipv4.tcp_* — параметры TCP/IP ядра
TCP buffers: sysctl net.ipv4.tcp_rmem / tcp_wmem — размеры буферов
netstat counters: netstat -s | grep retrans — глобальные повторные передачи
ethtool stats: ethtool -S eth0 — ошибки на уровне сетевой карты
