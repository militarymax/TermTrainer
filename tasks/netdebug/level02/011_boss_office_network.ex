META
# Track: netdebug
# Title: Проблемы в офисной сети
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 **Проблемы в офисной сети** (БОСС)

Коллеги жалуются: «Сайт грузится минутами!» Расследуй проблему от начала до конца, используя mtr, ss, tcpdump, dig, curl.

📋 **Боевые задания**:

1. **Базовая связность**: `ping -c 10 google.com`
   Запиши min/avg/max RTT и потери.

2. **mtr — где потери?**: `mtr -r -c 10 google.com` (или traceroute если нет mtr)
   На каком хопе начинаются проблемы?

3. **DNS — медленный резолвинг?**:
   ```bash
   for dns in 8.8.8.8 1.1.1.1 $(grep nameserver /etc/resolv.conf | head -1 | awk '{print $2}'); do
     time=$(dig @$dns google.com +stats 2>/dev/null | grep "Query time" | awk '{print $4}')
     echo "$dns: ${time}ms"
   done
   ```

4. **HTTP-тайминг разбивка**:
   ```bash
   curl -s -o /dev/null -w "DNS:%{time_namelookup}s TCP:%{time_connect}s TLS:%{time_appconnect}s TTFB:%{time_starttransfer}s Total:%{time_total}s\n" https://google.com
   ```
   Какая фаза занимает больше всего времени?

5. **TCP-состояния — есть ли аномалии?**:
   `ss -t -a | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn`

6. **Захвати трафик для анализа**:
   `sudo tcpdump -i any -c 100 -nn -w "$DIR/capture.pcap"`
   (В другом терминале сгенерируй трафик: curl, ping)

7. **Проверь MTU**:
   `ping -c 3 -s 1472 -M do google.com` (Linux)
   `ping -c 3 -D -s 1472 google.com` (macOS)

8. **Скрипт полного отчёта на bash + jq**:
   Напиши `report.sh` который собирает:
   - IP и шлюз
   - Ping статистику (RTT, loss)
   - DNS timing
   - HTTP timing breakdown
   - TCP state summary
   И выводит всё как JSON через jq

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_011"
score=0

rtt=$(ping -c 3 google.com 2>/dev/null | tail -1)
[ -n "$rtt" ] && { echo "✓ Ping работает"; score=$((score+1)); }

dns=$(dig @8.8.8.8 google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает"; score=$((score+1)); }

timing=$(curl -s -o /dev/null -w "%{time_total}" https://google.com --connect-timeout 5 2>/dev/null)
[ -n "$timing" ] && { echo "✓ HTTP timing: ${timing}s"; score=$((score+1)); }

if [ -f "$DIR/report.sh" ]; then
  chmod +x "$DIR/report.sh"
  out=$(bash "$DIR/report.sh" 2>&1 | head -10)
  [ -n "$out" ] && { echo "✓ Скрипт отчёта работает"; score=$((score+1)); }
fi

[ $score -ge 3 ] && { echo "✓ ok: БОСС пройден! Офисная сеть расследована! (баллов: $score/4)"; exit 0; }
echo "✗ Проведи полное расследование (баллов: $score/4)"
exit 1

HINTS
Ping stats: ping -c 10 host | tail -2 — RTT и потери
MTR report: mtr -r -c 10 host — потери по хопам
DNS compare: for d in 8.8.8.8 1.1.1.1; do dig @$d domain | grep Query; done
Curl timing: curl -o /dev/null -w "DNS:%{time_namelookup} TCP:%{time_connect} TLS:%{time_appconnect} TTFB:%{time_starttransfer} Total:%{time_total}\n" URL
TCP states: ss -t -a | awk 'NR>1{print $1}' | sort | uniq -c
tcpdump save: sudo tcpdump -i any -c 100 -nn -w file.pcap
MTU test: ping -s 1472 -M do host (Linux) или ping -D -s 1472 host (macOS)
Report script: собрать все проверки → JSON → jq для анализа
