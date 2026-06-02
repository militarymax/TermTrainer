META
# Track: netdebug
# Title: Охота на потери
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #009: Охота на потери

Декан Чартер вызвал тебя в лабораторию:
«Ринсвинд! Заклинания доходят с задержкой. Некоторые теряются.
Нужно ТОЧНО измерить: где потери, какая задержка, сколько TIME-WAIT.
Напиши скрипт мониторинга — и чтобы с jq для анализа!»

📋 **Задания**:

1. **Измерь RTT до нескольких хостов**:
   ```bash
   for host in google.com github.com cloudflare.com; do
     rtt=$(ping -c 5 "$host" 2>/dev/null | tail -1 | awk -F/ '{print $5}')
     echo "{\"host\":\"$host\",\"rtt_ms\":\"$rtt\"}"
   done | jq -s '.'
   ```

2. **Подсчитай TCP-состояния**:
   ```bash
   ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn
   ```

3. **Напиши `net_monitor.sh`**:
   ```bash
   #!/bin/bash
   echo "═══ Network Monitor ═══"
   
   # TCP states
   echo ""
   echo "── TCP States ──"
   ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn
   
   # Listening ports
   echo ""
   echo "── Listening Ports ──"
   ss -tlnp 2>/dev/null | head -10
   
   # RTT check
   echo ""
   echo "── Latency Check ──"
   for host in google.com github.com; do
     rtt=$(ping -c 3 "$host" 2>/dev/null | tail -1 | awk -F/ '{print $5}')
     printf "%-20s %s ms\n" "$host" "${rtt:-N/A}"
   done
   
   echo ""
   echo "═══ End of Monitor ═══"
   ```

4. Запусти и сохрани: `chmod +x net_monitor.sh && ./net_monitor.sh > $DIR/report.txt`

📂 Рабочий каталог: `~/.termtrainer/netdebug_009`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_009"
score=0

if [ -f "$DIR/net_monitor.sh" ]; then
  chmod +x "$DIR/net_monitor.sh"
  out=$(bash "$DIR/net_monitor.sh" 2>&1)
  echo "$out" | grep -q "TCP\|Latency\|google\|github" && { echo "✓ net_monitor.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Мониторинг освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши net_monitor.sh (баллов: $score/1)"
exit 1

HINTS
Ping stats: ping -c N host | tail -1 — мин/сред/макс RTT
RTT extract: awk -F/ '{print $5}' — вырезать среднее из строки rtt min/avg/max
TCP states: ss -t -a | awk '{print $1}' | sort | uniq -c — подсчёт состояний
Listening ports: ss -tlnp — кто слушает на каких портах
JSON output: echo '{"key":"val"}' | jq -s '.' — собрать в JSON массив
Monitor script: объединить несколько проверок в один отчёт
