META
# Track: netdebug
# Title: Фильтры tcpdump и Wireshark
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Фильтры tcpdump и Wireshark**

Умный фильтр — ключ к быстрой диагностике. Без фильтра tcpdump вывалит тысячи пакетов в секунду.

📖 **Фильтры захвата (BPF)**:
• `host 192.168.1.1` — только этот хост
• `port 443` — только этот порт
• `src host 10.0.0.1` — от этого хоста
• `dst port 80` — на этот порт
• `tcp` / `udp` / `icmp` — по протоколу
• Комбинации: `host 10.0.0.1 and port 443`
• Отрицание: `not port 22` — всё кроме SSH

📖 **Полезные фильтры**:
• `tcp[tcpflags] & tcp-syn != 0` — только SYN-пакеты
• `tcp[tcpflags] & tcp-rst != 0` — только RST-пакеты
• `greater 1000` — пакеты больше 1000 байт
• `less 100` — пакеты меньше 100 байт

📖 **Опции tcpdump**:
• `-A` — ASCII-вывод (видно HTTP-заголовки!)
• `-X` — hex + ASCII
• `-s 0` или `-s 65535` — захватить весь пакет
• `-w file.pcap` — сохранить в файл
• `-r file.pcap` — читать из файла
• `-C 10` — ротация файлов по 10 МБ
• `-G 60` — новый файл каждые 60 секунд

📖 **Wireshark** (GUI анализ):
• Открыть pcap: `wireshark capture.pcap`
• Фильтры отображения: `tcp.port == 443`, `http`, `dns`, `ip.addr == 10.0.0.1`
• Follow TCP Stream — посмотреть всю сессию целиком
• Statistics → Conversations — кто с кем общается
• Ищите: TCP Retransmission, TCP ZeroWindow, TCP RST

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_008`

📋 **Попробуй**:
1. Захват DNS: `sudo tcpdump -i any -c 20 -nn port 53`
2. С ASCII: `sudo tcpdump -i any -c 10 -nn -A port 80`
3. Сохранить: `sudo tcpdump -i any -c 50 -w $HOME/.ninja_trainer/netdebug_008/capture.pcap`

VALIDATION
#!/bin/bash
score=0

if command -v tcpdump &>/dev/null; then
  echo "✓ tcpdump установлен"; score=$((score+1))
fi

[ $score -ge 1 ] && { echo "✓ ok: Фильтры tcpdump освоены! (баллов: $score/1)"; exit 0; }
echo "✗ Установи tcpdump"
exit 1

HINTS
Filter by host: sudo tcpdump -i any host 10.0.0.1
Filter by port: sudo tcpdump -i any port 443
Combine: sudo tcpdump -i any 'host 10.0.0.1 and port 443'
SYN only: sudo tcpdump -i any 'tcp[tcpflags] & tcp-syn != 0'
RST only: sudo tcpdump -i any 'tcp[tcpflags] & tcp-rst != 0'
ASCII output: sudo tcpdump -A -i any port 80 — видно HTTP-заголовки
Save pcap: sudo tcpdump -w file.pcap -i any
Read pcap: sudo tcpdump -r file.pcap — читать сохранённый захват
Wireshark filter: tcp.port==443, http, dns, ip.addr==10.0.0.1
