META
# Track: netdebug
# Title: Потери и задержки
# Number: 009
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📊 **Потери и задержки**

Сайт «тормозит» — но почему? Потеря пакетов? Высокий RTT? Проблема на каком-то хопе? Расследуй!

📋 **Задания**:

1. **Измерь RTT до разных точек**:
   `ping -c 10 google.com | tail -2`
   Обрати внимание на min/avg/max/stddev

2. **mtr — потери по хопам** (если установлен):
   `mtr -r -c 10 google.com`
   Ищи хопы с потерями >5%

3. **Проверь DNS-задержку через dig**:
   `dig @8.8.8.8 google.com | grep "Query time"`
   `dig @1.1.1.1 google.com | grep "Query time"`
   Сравни время ответа разных DNS

4. **HTTP-тайминг разбивка**:
   ```bash
   curl -s -o /dev/null -w "DNS:%{time_namelookup}s TCP:%{time_connect}s TLS:%{time_appconnect}s Start:%{time_starttransfer}s Total:%{time_total}s\n" https://google.com
   ```
   Какая фаза самая долгая?

5. **TCP-соединения и их состояние**:
   `ss -t -a | awk '{print $1}' | sort | uniq -c | sort -rn`
   Сколько ESTAB vs TIME-WAIT?

6. **Детали конкретного соединения**:
   Найди соединение с google:
   `ss -ti dst google.com`
   Посмотри: rtt, cwnd, retrans

7. **Скрипт мониторинга задержки на bash + jq**:
   ```bash
   #!/bin/bash
   for i in $(seq 1 10); do
     rtt=$(ping -c 1 google.com 2>/dev/null | grep "time=" | sed 's/.*time=\([0-9.]*\).*/\1/')
     ts=$(date +%H:%M:%S)
     echo "{\"time\":\"$ts\",\"rtt_ms\":$rtt}"
   done
   ```
   Запусти и перенаправь в файл, потом проанализируй через jq:
   `bash monitor.sh > results.jsonl`
   `cat results.jsonl | jq -s '[.[].rtt_ms] | {min: min, max: max, avg: (add/length)}'`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_009"
score=0

rtt=$(ping -c 3 google.com 2>/dev/null | tail -1)
[ -n "$rtt" ] && { echo "✓ Ping работает: $rtt"; score=$((score+1)); }

dns_time=$(dig @8.8.8.8 google.com 2>/dev/null | grep "Query time")
[ -n "$dns_time" ] && { echo "✓ DNS timing: $dns_time"; score=$((score+1)); }

http_timing=$(curl -s -o /dev/null -w "%{time_total}" https://google.com --connect-timeout 5 2>/dev/null)
[ -n "$http_timing" ] && { echo "✓ HTTP total time: ${http_timing}s"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Диагностика потерь и задержек освоена! (баллов: $score/3)"; exit 0; }
echo "✗ Проверь сетевую связность (баллов: $score/3)"
exit 1

HINTS
Ping stats: ping -c 10 host | tail -2 — min/avg/max/stddev RTT
MTR report: mtr -r -c 10 host — потери и RTT по каждому хопу
DNS timing: dig @server domain | grep Query time — скорость DNS-ответа
Curl timing: curl -o /dev/null -w "DNS:%{time_namelookup} Total:%{time_total}\n" URL
SS states: ss -t -a | awk '{print $1}' | sort | uniq -c — распределение состояний
SS detail: ss -ti dst host — RTT, CWND, retrans для конкретного соединения
Monitor script: цикл ping → JSON → анализ через jq
JQ stats: cat data.jsonl | jq -s '[.[].field] | {min,max,avg:(add/length)}'
