META
# Track: netdebug
# Title: Подслушивание потоков
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #005: Подслушивание потоков

Библиотекарь жестом подозвал тебя к стене:
«Ууук!» — и приложил палец к камню. Через стену были слышны голоса.
«tcpdump — это уши Башни. Ты слышишь ВСЕ пакеты, что проходят мимо.
Каждый крик, каждый шёпот. Но будь осторожен — в потоке данных
легко утонуть. Научись фильтровать.»

📋 **Задания**:

ASSIGNMENT
1. **Базовый захват пакетов** (нужен sudo):
   ```bash
   sudo tcpdump -c 10              # Захватить 10 пакетов
   sudo tcpdump -c 10 -nn          # Без резолва имён (быстрее!)
   sudo tcpdump -c 10 -i any       # Все интерфейсы
   ```

2. **Фильтры захвата** (BPF):
   ```bash
   sudo tcpdump -c 10 port 443           # Только HTTPS
   sudo tcpdump -c 10 host google.com    # Только к/от google.com
   sudo tcpdump -c 10 icmp               # Только ping!
   ```

3. **Сохранение в файл**:
   ```bash
   sudo tcpdump -c 50 -w "$DIR/capture.pcap"    # Записать в pcap
   sudo tcpdump -r "$DIR/capture.pcap" -nn       # Прочитать из файла
   ```

4. **MTU — размер заклинания**:
   ```bash
   # Проверить MTU (максимальный размер пакета)
   ping -c 3 -s 1472 -M do google.com     # 1472+28=1500 (стандартный MTU)
   # Если не проходит → проблема с MTU!
   ```

📂 Рабочий каталог: `~/.termtrainer/netdebug_005`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_005

VALIDATION
#!/bin/bash
score=0

which tcpdump &>/dev/null && { echo "✓ tcpdump установлен"; score=$((score+1)); }

mtu=$(ping -c 1 -s 1472 -M do google.com 2>&1 | grep "time=")
[ -n "$mtu" ] && { echo "✓ MTU проверка работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: tcpdump и MTU освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
tcpdump basic: sudo tcpdump -c N -nn — захватить N пакетов без резолва
Filter port: sudo tcpdump port 443 — только HTTPS трафик
Filter host: sudo tcpdump host X.X.X.X — только к/от конкретного хоста
Save pcap: sudo tcpdump -w file.pcap — записать в файл для анализа
Read pcap: sudo tcpdump -r file.pcap -nn — прочитать сохранённый файл
ICMP only: sudo tcpdump icmp — только ping пакеты
MTU test: ping -s 1472 -M do host — проверить что большие пакеты проходят
