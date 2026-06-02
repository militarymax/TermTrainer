META
# Track: netdebug
# Title: Сетевой детектив
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #006: Сетевой детектив

Архиканцлер вызвал тебя в кабинет:
«Ринсвинд! Студенты жалуются — "всё сломалось".
Но ЧТО именно? Не знают. Ты должен провести ПОЛНОЕ расследование:
от IP-адреса до HTTP-ответа. Собери ВСЮ информацию в один отчёт.
Если пропустишь хоть один шаг — демон ускользнёт.
А демоны в сети... они хитрые.»

📋 **Боевые задания**:

Напиши `$DIR/full_diagnose.sh` который проверяет ВСЁ:

```bash
#!/bin/bash
echo "═══════════════════════════════════"
echo "   Network Detective Report"
echo "═══════════════════════════════════"
echo "Date: $(date)"
echo ""

echo "── Step 1: Interfaces ──"
ip addr 2>/dev/null | grep "inet " | grep -v 127.0.0.1 || ifconfig 2>/dev/null | grep "inet " | grep -v 127.0.0.1

echo ""
echo "── Step 2: Gateway ──"
GW=$(ip route 2>/dev/null | grep default | awk '{print $3}' || netstat -rn 2>/dev/null | grep default | awk '{print $2}' | head -1)
echo "Gateway: ${GW:-NOT FOUND}"

echo ""
echo "── Step 3: Connectivity ──"
echo -n "Loopback: "; ping -c 1 -W 2 127.0.0.1 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"
echo -n "Gateway:  "; [ -n "$GW" ] && ping -c 1 -W 2 "$GW" &>/dev/null && echo "✓ OK" || echo "✗ FAIL/N/A"
echo -n "Internet: "; ping -c 1 -W 2 8.8.8.8 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"

echo ""
echo "── Step 4: DNS ──"
DNS_IP=$(dig google.com +short 2>/dev/null | head -1)
echo "google.com → ${DNS_IP:-FAILED}"
echo -n "By name:  "; ping -c 1 -W 2 google.com &>/dev/null && echo "✓ OK" || echo "✗ FAIL"

echo ""
echo "── Step 5: HTTP ──"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://google.com --connect-timeout 5 2>/dev/null)
HTTP_TIME=$(curl -s -o /dev/null -w "%{time_total}" https://google.com --connect-timeout 5 2>/dev/null)
echo "HTTPS google.com: code=${HTTP_CODE:-N/A} time=${HTTP_TIME:-N/A}s"

echo ""
echo "═══════════════════════════════════"
```

Запусти и сохрани: `chmod +x full_diagnose.sh && ./full_diagnose.sh > $DIR/report.txt`

📂 Рабочий каталог: `~/.termtrainer/netdebug_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_006"
score=0

if [ -f "$DIR/full_diagnose.sh" ]; then
  chmod +x "$DIR/full_diagnose.sh"
  out=$(bash "$DIR/full_diagnose.sh" 2>&1)
  echo "$out" | grep -q "Step\|Interface\|Gateway\|Connectivity\|DNS\|HTTP" && { echo "✓ full_diagnose.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: БОСС пройден! Сетевой детектив готов! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши full_diagnose.sh (баллов: $score/1)"
exit 1

HINTS
Interfaces: ip addr или ifconfig — свои адреса
Gateway: ip route | grep default — шлюз по умолчанию
Ping loopback → gateway → internet — пошаговая проверка связности
DNS: dig domain +short — разрешение имён
HTTP: curl -w "%{http_code}" URL — код ответа сервера
Report: собрать все шаги в один скрипт, перенаправить вывод > report.txt
