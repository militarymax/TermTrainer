META
# Track: netdebug
# Title: Искусство фильтрации
# Number: 008
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_008"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #008: Искусство фильтрации

Библиотекарь положил перед тобой огромный свиток:
«Ууук!» — это означало: «В сыром потоке пакетов — тысячи строк.
Нужен фильтр. BPF — это язык, который отсекает лишнее.
Оставляет только то, что важно. Как поиск в Архивах.»

───────────────────────────────────────
🔹 BPF-ФИЛЬРЫ ДЛЯ TCPDUMP
───────────────────────────────────────

```bash
# По хосту
sudo tcpdump host 192.168.1.1              # К/от конкретного IP
sudo tcpdump src host 10.0.0.1             # Только ОТ
sudo tcpdump dst host 10.0.0.2             # Только К

# По порту
sudo tcpdump port 443                       # Только HTTPS
sudo tcpdump port 80 or port 443            # HTTP или HTTPS
sudo tcpdump dst port 22                    # Только входящий SSH

# По протоколу
sudo tcpdump icmp                           # Только ping
sudo tcpdump tcp                            # Только TCP
sudo tcpdump udp                            # Только UDP

# Комбинации (AND/OR/NOT)
sudo tcpdump "host 10.0.0.1 and port 443"
sudo tcpdump "port 80 or port 443"
sudo tcpdump "not port 22"

# Флаги TCP (мощно!)
sudo tcpdump 'tcp[tcpflags] & tcp-syn != 0'    # Только SYN (новые соединения)
sudo tcpdump 'tcp[tcpflags] & tcp-rst != 0'    # Только RST (жёсткий разрыв)
sudo tcpdump 'tcp[tcpflags] == tcp-syn|tcp-ack' # SYN+ACK (ответ сервера)
```

───────────────────────────────────────
🔹 WIRESHARK — ВИЗУАЛЬНЫЙ АНАЛИЗ
───────────────────────────────────────

• Открой `.pcap` файл в Wireshark для визуального анализа
• Фильтры отображения: `http.request`, `dns`, `tcp.flags.syn==1`
• Follow TCP Stream — увидеть весь разговор целиком!
• Statistics → Conversations — кто с кем общается

📂 Рабочий каталог: `~/.termtrainer/netdebug_008`

📋 **Попробуй**:
1. `sudo tcpdump -c 20 -nn port 443` — только HTTPS пакеты
2. `sudo tcpdump -c 10 'tcp[tcpflags] & tcp-syn != 0'` — только новые соединения

VALIDATION
#!/bin/bash
score=0

which tcpdump &>/dev/null && { echo "✓ tcpdump установлен"; score=$((score+1)); }

which wireshark &>/dev/null || which tshark &>/dev/null && { echo "✓ Wireshark/tshark установлен"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Фильтрация освоена! (баллов: $score/2)"; exit 0; }
echo "⚠ Установите tcpdump/wireshark для практики"
exit 1

HINTS
BPF host: tcpdump host X.X.X.X — фильтр по IP адресу
BPF port: tcpdump port N — фильтр по номеру порта
BPF protocol: tcpdump icmp/tcp/udp — по протоколу
BPF AND/OR: tcpdump "host X and port Y" — комбинация условий
TCP flags: tcpdump 'tcp[tcpflags] & tcp-syn != 0' — только SYN пакеты
Save pcap: tcpdump -w file.pcap — сохранить захват в файл
Wireshark: открыть pcap файл для визуального анализа
Follow stream: Wireshark → Follow TCP Stream — весь диалог целиком
