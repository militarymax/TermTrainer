META
# Track: netdebug
# Title: Офисная сеть Башни
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #011: Офисная сеть Башни

Архиканцлер вызвал тебя в кабинет:
«Ринсвинд! В офисе Башни — ЧП. Кто-то не может зайти на сервер,
у кого-то тормозит интернет, а у кого-то вообще ничего не работает.
Проведи ПОЛНОЕ расследование и напиши отчёт.
Используй ВСЁ: ping, dig, curl, ss, nc, traceroute.»

📋 **Боевые задания**:

Напиши `$DIR/office_report.sh`:

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════"
echo "   Tower Office Network Report"
echo "═══════════════════════════════════"
echo "Date: $(date)"
echo ""

echo "── 1. Interfaces ──"
ip addr 2>/dev/null | grep "inet " | grep -v 127.0.0.1 || ifconfig 2>/dev/null | grep "inet " | grep -v 127.0.0.1

echo ""
echo "── 2. Gateway & Route ──"
GW=$(ip route 2>/dev/null | grep default | awk '{print $3}' || netstat -rn 2>/dev/null | grep default | awk '{print $2}' | head -1)
echo "Gateway: ${GW:-NOT FOUND}"
traceroute -m 5 google.com 2>&1 | head -8 || echo "(traceroute unavailable)"

echo ""
echo "── 3. DNS ──"
for domain in google.com github.com; do
  ip=$(dig "$domain" +short 2>/dev/null | head -1)
  echo "$domain → ${ip:-FAILED}"
done

echo ""
echo "── 4. HTTP Health ──"
for url in https://google.com https://github.com; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --connect-timeout 5 2>/dev/null)
  time=$(curl -s -o /dev/null -w "%{time_total}" "$url" --connect-timeout 5 2>/dev/null)
  printf "%-25s code=%-5s time=%ss\n" "$url" "${code:-N/A}" "${time:-N/A}"
done

echo ""
echo "── 5. TCP States ──"
ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn | head -5

echo ""
echo "── 6. Listening Ports ──"
ss -tlnp 2>/dev/null | head -10

echo ""
echo "── 7. External IP (NAT check) ──"
EXT=$(curl -s --connect-timeout 5 https://ifconfig.me 2>/dev/null)
echo "External IP: ${EXT:-UNREACHABLE}"

echo ""
echo "═══════════════════════════════════"
```

Запусти: `chmod +x office_report.sh && ./office_report.sh > $DIR/report.txt`

📂 Рабочий каталог: `~/.termtrainer/netdebug_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_011"
score=0

if [ -f "$DIR/office_report.sh" ]; then
  chmod +x "$DIR/office_report.sh"
  out=$(bash "$DIR/office_report.sh" 2>&1)
  echo "$out" | grep -q "Interface\|Gateway\|DNS\|HTTP\|TCP\|Report" && { echo "✓ office_report.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: БОСС пройден! Офисная сеть обследована! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши office_report.sh (баллов: $score/1)"
exit 1

HINTS
Interfaces: ip addr или ifconfig — свои адреса
Gateway+Route: ip route + traceroute — путь до внешнего мира
DNS: dig domain +short для каждого проверяемого домена
HTTP health: curl -w "%{http_code} %{time_total}" URL — код + время
TCP states: ss -t -a | awk | sort | uniq -c — подсчёт состояний
Listening ports: ss -tlnp — кто слушает
NAT check: curl ifconfig.me vs ip addr — внутренний vs внешний IP
