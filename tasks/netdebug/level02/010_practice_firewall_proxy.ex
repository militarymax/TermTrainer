META
# Track: netdebug
# Title: Файрволы и прокси
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🛡️ **Файрволы и прокси**

«Порт закрыт» — но на сервере всё работает! Часто проблема в файрволе или прокси.

📋 **Задания**:

1. **Проверь локальный файрвол** (Linux):
   `sudo iptables -L -v -n` — правила iptables
   `sudo ufw status verbose` — если используется UFW
   На macOS: `sudo pfctl -s all` (pf firewall)

2. **Счётчики правил**:
   `sudo iptables -L -v -n | grep DROP`
   Сколько пакетов было отброшено каждым правилом?

3. **Проверь NAT/проброс портов**:
   `sudo iptables -t nat -L -v -n`

4. **conntrack — таблица соединений** (Linux):
   `sudo conntrack -L | head -20`
   `sudo conntrack -C` — количество активных соединений

5. **HTTP через прокси**:
   `curl -x http://proxy.example.com:8080 https://google.com -v`
   Если прокси требует аутентификацию:
   `curl -x http://user:pass@proxy:8080 URL`

6. **Проверь что блокирует конкретный порт**:
   ```bash
   # Снаружи — открыт ли порт?
   nc -zv target_host 443 -w 3
   
   # Локально — слушает ли сервис?
   ss -tlnp | grep :443
   
   # Если слушает но не доступен снаружи → файрвол!
   ```

7. **Скрипт проверки портов на bash + jq**:
   ```bash
   #!/bin/bash
   HOST="$1"
   for PORT in 22 80 443 3306 5432 8080; do
     timeout 3 bash -c "echo >/dev/tcp/$HOST/$PORT" 2>/dev/null && \
       echo "{\"port\":$PORT,\"status\":\"open\"}" || \
       echo "{\"port\":$PORT,\"status\":\"closed\"}"
   done
   ```
   Запусти: `bash portscan.sh google.com | jq -s '.'`

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_010`

VALIDATION
#!/bin/bash
score=0

ss_out=$(ss -tlnp 2>/dev/null | wc -l)
[ "$ss_out" -ge 1 ] && { echo "✓ ss работает"; score=$((score+1)); }

nc_test=$(echo "test" | nc -w 2 google.com 443 2>&1; echo $?)
[ -n "$nc_test" ] && { echo "✓ nc доступен"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Файрволы и прокси освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
iptables list: sudo iptables -L -v -n — все правила с счётчиками
UFW status: sudo ufw status verbose — если UFW включён
macOS pf: sudo pfctl -s all — правила pf firewall
NAT rules: sudo iptables -t nat -L -v -n — правила NAT
conntrack: sudo conntrack -L — таблица активных соединений
Proxy curl: curl -x http://proxy:port URL — через HTTP-прокси
Port check flow: ss -tlnp (local) → nc -zv (remote) → if local=yes remote=no → firewall
Port scan script: loop ports → /dev/tcp or nc → JSON output → jq analysis
