META
# Track: netdebug
# Title: Глубокие тайны DNS и ядра
# Number: 013
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #013: Глубокие тайны DNS и ядра

В Тайной Комнате Архиканцлер открыл потайную дверь:
«Ринсвинд! DNS — не просто dig. Можно отследить ВЕСЬ путь резолвинга,
проверить цифровые подписи, запросить полную зону.
А параметры ядра влияют на TCP больше, чем ты думаешь.
Последний, кто трогал tcp_tw_reuse без понимания...
ну, его до сих пор находят в логах.»

───────────────────────────────────────
🔹 ПРОДВИНУТЫЕ DNS-ЗАПРОСЫ
───────────────────────────────────────

```bash
dig +trace google.com          # Рекурсивный поиск от корневых серверов!
dig +dnssec google.com         # Проверить DNSSEC-подписи
dig AXFR domain.com @ns1      # Полная зона (если разрешено!)
dig -x 8.8.8.8                # Обратный DNS (IP → имя)
```

📖 **DNS trace** показывает весь путь:
`корневой → .com → google.com NS → google.com A`
Если обрывается на шаге N — проблема на том сервере!

───────────────────────────────────────
🔹 SYSCTL — ПАРАМЕТРЫ TCP/IP ЯДРА (Linux)
───────────────────────────────────────

```bash
sysctl net.ipv4.tcp_congestion_control   # Алгоритм контроля перегрузки
sysctl net.ipv4.tcp_rmem                 # Буфер приёма TCP (min/default/max)
sysctl net.ipv4.tcp_wmem                 # Буфер отправки TCP
sysctl net.core.somaxconn               # Максимальная очередь listen
sysctl net.ipv4.tcp_max_syn_backlog      # Очередь SYN
sysctl net.ipv4.tcp_tw_reuse             # Переиспользование TIME-WAIT
```

⚠️ На macOS вместо sysctl используется `sysctl` с другими ключами!

───────────────────────────────────────
🔹 СТАТИСТИКА И ОШИБКИ
───────────────────────────────────────

```bash
netstat -s | grep -i retrans     # Повторные передачи (Linux)
ss -ti                           # RTT/CWND/retransmits per socket
```

📂 Рабочий каталог: `~/.termtrainer/netdebug_013`

📋 **Попробуй**:
1. `dig +trace google.com | head -30`
2. `dig -x 8.8.8.8 +short`
3. `sysctl -a 2>/dev/null | grep tcp | head -10`

VALIDATION
#!/bin/bash
score=0

rdns=$(dig -x 8.8.8.8 +short 2>/dev/null | head -1)
[ -n "$rdns" ] && { echo "✓ Обратный DNS: $rdns"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Продвинутый DNS освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
DNS trace: dig +trace domain — рекурсивный путь от корневых серверов
Reverse DNS: dig -x IP +short — IP → доменное имя
DNSSEC: dig +dnssec domain — проверить цифровые подписи
AXFR zone: dig AXFR domain @nameserver — полная зона (если разрешено)
sysctl TCP: sysctl net.ipv4.tcp_* — параметры TCP/IP ядра Linux
TCP buffers: sysctl net.ipv4.tcp_rmem / tcp_wmem — размеры буферов
Retransmits: netstat -s | grep retrans или ss -ti — повторные передачи
