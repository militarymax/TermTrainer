META
# Track: netdebug
# Title: Сетевая криминалистика
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #015: Сетевая криминалистика

Архиканцлер вызвал тебя в Тайную Комнату:
«Ринсвинд! Кто-то общается с подозрительными серверами.
Нужно собрать ВСЮ информацию: какие соединения активны,
кто с кем говорит, какие DNS-запросы уходят, сколько TIME-WAIT.
Напиши скрипт-криминалист — полный допрос сети.»

📋 **Задания**:

ASSIGNMENT
1. **Активные соединения с процессами**:
   ```bash
   ss -tnp 2>/dev/null | head -20    # Кто подключён и какой процесс!
   ```

2. **Подсчёт по удалённым IP**:
   ```bash
   ss -tn 2>/dev/null | awk 'NR>1{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
   ```

3. **DNS-запросы из кэша** (macOS):
   ```bash
   dscacheutil -q host -a name google.com    # DNS cache macOS
   ```

4. **Напиши `net_forensics.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   echo "═══ Network Forensics Report ═══"
   echo "Date: $(date)"
   
   echo ""
   echo "── Active Connections ──"
   ss -tnp 2>/dev/null | head -15 || netstat -tn 2>/dev/null | head -15
   
   echo ""
   echo "── Top Remote IPs ──"
   ss -tn 2>/dev/null | awk 'NR>1{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
   
   echo ""
   echo "── TCP State Summary ──"
   ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn
   
   echo ""
   echo "── Listening Services ──"
   ss -tlnp 2>/dev/null | head -10
   
   echo ""
   echo "── DNS Check ──"
   for domain in google.com github.com; do
     ip=$(dig "$domain" +short 2>/dev/null | head -1)
     printf "%-20s → %s\n" "$domain" "${ip:-FAILED}"
   done
   
   echo ""
   echo "── TLS Certificate Status ──"
   for site in google.com github.com; do
     expiry=$(echo | openssl s_client -connect "$site:443" -servername "$site" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null)
     printf "%-20s %s\n" "$site" "${expiry:-ERROR}"
   done
   
   echo ""
   echo "═══ End of Forensics ═══"
   ```

5. Запусти: `chmod +x net_forensics.sh && ./net_forensics.sh > $DIR/report.txt`

📂 Рабочий каталог: `~/.termtrainer/netdebug_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_015"
score=0

if [ -f "$DIR/net_forensics.sh" ]; then
  chmod +x "$DIR/net_forensics.sh"
  out=$(bash "$DIR/net_forensics.sh" 2>&1)
  echo "$out" | grep -q "Active\|Remote\|TCP\|DNS\|TLS\|Forensics" && { echo "✓ net_forensics.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Криминалистика освоена! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши net_forensics.sh (баллов: $score/1)"
exit 1

HINTS
Active connections: ss -tnp — все TCP-соединения с PID процессов
Top remote IPs: ss -tn | awk '{print $5}' | cut -d: -f1 | sort | uniq -c
TCP states: ss -t -a | awk '{print $1}' | sort | uniq -c — подсчёт состояний
Listening services: ss -tlnp — кто слушает на каких портах
DNS check: dig domain +short для каждого проверяемого домена
TLS cert dates: openssl s_client + openssl x509 -noout -enddate
Report: объединить все проверки в один скрипт → перенаправить > report.txt
