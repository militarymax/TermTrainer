META
# Track: netdebug
# Title: Архимаг Сетевой Магии
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/reports"

TASK
👑 UBERBOSS #016: Архимаг Сетевой Магии

Архиканцлер стоял на вершине Башни, ветер развевал его мантию:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Напиши систему мониторинга,
которая проверяет ВСЁ: от IP до TLS-сертификатов.
С JSON-выводом через jq. С отчётами. С фильтрами.
Используй ВСЁ: ping, dig, curl, ss, openssl, nc, jq.
Если справишься — ты Архимаг Сетей.
Если нет... знаешь того кактуса? Он до сих пор колется.»

📋 **БЛОК 1 — Полная диагностика сети**:

Напиши `$DIR/net_audit.sh`:
```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════"
echo "   Tower Network Audit"
echo "═══════════════════════════════════"
echo "Date: $(date)"
echo ""

# Interfaces
echo "── 1. Interfaces ──"
ip addr 2>/dev/null | grep "inet " | grep -v 127.0.0.1 || ifconfig 2>/dev/null | grep "inet " | grep -v 127.0.0.1

# Gateway
echo ""
echo "── 2. Gateway ──"
GW=$(ip route 2>/dev/null | grep default | awk '{print $3}' || netstat -rn 2>/dev/null | grep default | awk '{print $2}' | head -1)
echo "Gateway: ${GW:-NOT FOUND}"

# Connectivity chain
echo ""
echo "── 3. Connectivity Chain ──"
echo -n "Loopback: "; ping -c 1 -W 2 127.0.0.1 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"
echo -n "Gateway:  "; [ -n "$GW" ] && ping -c 1 -W 2 "$GW" &>/dev/null && echo "✓ OK ($GW)" || echo "✗ FAIL/N/A"
echo -n "Internet: "; ping -c 1 -W 2 8.8.8.8 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"

# DNS resolution
echo ""
echo "── 4. DNS Resolution ──"
for domain in google.com github.com cloudflare.com; do
  ip=$(dig "$domain" +short 2>/dev/null | head -1)
  printf "%-20s → %s\n" "$domain" "${ip:-FAILED}"
done

# HTTP profiling as JSON
echo ""
echo "── 5. HTTP Profiling ──"
for url in https://google.com https://github.com; do
  curl -s -o /dev/null -w "{\"url\":\"$url\",\"dns\":%{time_namelookup},\"tcp\":%{time_connect},\"tls\":%{time_appconnect},\"ttfb\":%{time_starttransfer},\"total\":%{time_total},\"code\":%{http_code}}\n" "$url" --connect-timeout 5 2>/dev/null | jq '.' 2>/dev/null || echo "(failed)"
done

# TCP states
echo ""
echo "── 6. TCP States ──"
ss -t -a 2>/dev/null | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn

# Listening ports
echo ""
echo "── 7. Listening Ports ──"
ss -tlnp 2>/dev/null | head -10

# NAT check
echo ""
echo "── 8. NAT Check ──"
EXT=$(curl -s --connect-timeout 5 https://ifconfig.me 2>/dev/null)
echo "External IP: ${EXT:-UNREACHABLE}"

# TLS certificates
echo ""
echo "── 9. TLS Certificates ──"
for site in google.com github.com; do
  expiry=$(echo | openssl s_client -connect "$site:443" -servername "$site" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null)
  proto=$(echo | openssl s_client -connect "$site:443" -servername "$site" 2>/dev/null | grep "Protocol" | head -1)
  printf "%-20s %s %s\n" "$site" "${expiry:-ERROR}" "${proto:-}"
done

echo ""
echo "═══════════════════════════════════"
```

📋 **БЛОК 2 — Запуск и сохранение**:
```bash
chmod +x net_audit.sh
./net_audit.sh > reports/full_report.txt
./net_audit.sh 2>&1 | tee reports/audit_$(date +%Y%m%d_%H%M%S).log
```

📋 **БЛОК 3 — JSON-отчёт**:

Напиши `$DIR/json_report.sh` который выводит JSON:
```bash
#!/bin/bash
set -euo pipefail

# Собрать данные в JSON
GW=$(ip route 2>/dev/null | grep default | awk '{print $3}' || echo "")
DNS_OK=$(dig google.com +short 2>/dev/null | head -1)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://google.com --connect-timeout 5 2>/dev/null || echo "000")
HTTP_TIME=$(curl -s -o /dev/null -w "%{time_total}" https://google.com --connect-timeout 5 2>/dev/null || echo "0")
EXT_IP=$(curl -s --connect-timeout 5 https://ifconfig.me 2>/dev/null || echo "")

jq -n \
  --arg gw "$GW" \
  --arg dns "$DNS_OK" \
  --argjson http_code "${HTTP_CODE:-0}" \
  --arg http_time "${HTTP_TIME:-0}" \
  --arg ext_ip "$EXT_IP" \
  --arg date "$(date -Iseconds)" \
  '{date:$date, gateway:$gw, dns_resolves:($dns!=""), external_ip:$ext_ip, http:{code:$http_code,time_seconds:$http_time}}'
```

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_016"
score=0
max=5

[ -f "$DIR/net_audit.sh" ] && head -1 "$DIR/net_audit.sh" | grep -q '^#!' && { echo "✓ net_audit.sh создан"; score=$((score+1)); }

[ -f "$DIR/json_report.sh" ] && head -1 "$DIR/json_report.sh" | grep -q '^#!' && { echo "✓ json_report.sh создан"; score=$((score+1)); }

if [ -f "$DIR/net_audit.sh" ]; then
  chmod +x "$DIR/net_audit.sh"
  out=$(bash "$DIR/net_audit.sh" 2>&1)
  echo "$out" | grep -q "Interface\|Gateway\|Connectivity\|DNS\|HTTP\|TCP\|TLS" && { echo "✓ net_audit работает"; score=$((score+1)); }
fi

if [ -f "$DIR/json_report.sh" ]; then
  chmod +x "$DIR/json_report.sh"
  out=$(bash "$DIR/json_report.sh" 2>&1)
  echo "$out" | grep -q "gateway\|dns\|http\|external" && { echo "✓ JSON-отчёт работает"; score=$((score+1)); }
fi

[ -d "$DIR/reports" ] && { echo "✓ Каталог reports есть"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 3 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Full audit script: interfaces → gateway → connectivity → DNS → HTTP → TCP → ports → NAT → TLS
Each section: header + data + status check
Curl profiling: curl -w json_format URL | jq '.' — полный тайминг как JSON

=== БЛОК 2 ===
chmod +x: сделать скрипты исполняемыми
tee: ./script.sh 2>&1 | tee report.log — и показать и сохранить
Date stamp: $(date +%Y%m%d) в имени файла для версионности

=== БЛОК 3 ===
jq -n: создать JSON с нуля из shell-переменных
--arg/--argjson: передать строковые/числовые переменные в jq
Boolean check: ($dns != "") — true если DNS резолвит
Nested objects: {http:{code:X,time:Y}} — вложенные объекты в JSON
