META
# Track: netdebug
# Title: Прослушивание сети и MTU
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📡 **Прослушивание сети и MTU**

tcpdump — «рентген» сети. Видит каждый пакет. А MTU-проблемы — частая причина загадочных тормозов.

📖 **tcpdump — основы**:
• `sudo tcpdump -i en0 -c 10` — захватить 10 пакетов на интерфейсе en0
• `-i any` — все интерфейсы
• `-c N` — только N пакетов
• `-nn` — не резолвить IP и порты (быстрее)
• `host 8.8.8.8` — фильтр по хосту
• `port 443` — фильтр по порту
• `tcpdump -i en0 -c 5 -w capture.pcap` — сохранить в файл (для Wireshark)

📋 **Задания**:

1. **Определи свой интерфейс**: `ip addr | grep -E "^[0-9]" | awk -F: '{print $2}'`
   На macOS обычно `en0`, на Linux — `eth0`

2. **Захвати несколько пакетов** (нужен sudo):
   `sudo tcpdump -i any -c 10 -nn`

3. **Сгенерируй трафик в другом терминале**:
   `ping -c 4 google.com` или `curl https://google.com`

4. **Фильтр по порту DNS**:
   `sudo tcpdump -i any -c 5 -nn port 53`

5. **Фильтр по HTTP**:
   `sudo tcpdump -i any -c 5 -nn port 80`

6. **Проверь MTU**:
   `ping -c 4 -s 1472 -M do google.com` (Linux)
   `ping -c 4 -D -s 1472 google.com` (macOS)
   Если не проходит — уменьшай размер до работающего

7. **Найди путь MTU**:
   `tracepath google.com` (Linux, показывает MTU каждого хопа)

8. **Сохраняй в pcap для Wireshark**:
   `sudo tcpdump -i any -c 50 -w "$HOME/.ninja_trainer/netdebug_005/capture.pcap"`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_005`

VALIDATION
#!/bin/bash
score=0

if command -v tcpdump &>/dev/null; then
  echo "✓ tcpdump установлен"; score=$((score+1))
else
  echo "✗ tcpdump не найден"
fi

iface=$(ip addr 2>/dev/null | grep -E "^[0-9]+" | grep -v lo | head -1 | awk -F: '{print $2}' | tr -d ' ')
[ -n "$iface" ] && { echo "✓ Интерфейс найден: $iface"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Основы tcpdump освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Установи tcpdump"
exit 1

HINTS
Capture packets: sudo tcpdump -i any -c 10 -nn
Specific interface: sudo tcpdump -i en0 -c 10 (macOS) или eth0 (Linux)
No resolve: -nn — не резолвить IP и порты (быстрее)
Filter by port: sudo tcpdump -i any port 53 (DNS) или port 80 (HTTP)
Filter by host: sudo tcpdump -i any host 8.8.8.8
Save to file: sudo tcpdump -i any -c 50 -w file.pcap
MTU test Linux: ping -c 4 -s 1472 -M do host (DF bit set)
MTU test macOS: ping -D -s 1472 host
tracepath: tracepath host — показывает MTU пути
