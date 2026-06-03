META
# Track: netdebug
# Title: Алгоритм расследования
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 20
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #003: Алгоритм расследования

Декан Чартер влетел в комнату:
«Ринсвинд! "У меня нет интернета!" — это НЕ диагноз!
Это СИМПТОМ! Нужно расследовать ПОШАГОВО:
от себя → до шлюза → до DNS → до сервера.
Каждый шаг — проверка. Где обрыв? Там и копай!»

📋 **Задания**:

ASSIGNMENT
1. **Шаг 1: Проверь себя**:
   ```bash
   ping -c 2 127.0.0.1       # Loopback работает?
   ip addr | grep "inet "    # Есть IP-адрес?
   ```

2. **Шаг 2: Проверь шлюз**:
   ```bash
   GW=$(ip route 2>/dev/null | grep default | awk '{print $3}' || netstat -rn 2>/dev/null | grep default | awk '{print $2}')
   echo "Gateway: $GW"
   ping -c 2 "$GW"
   ```

3. **Шаг 3: Проверь внешний IP**:
   ```bash
   ping -c 2 8.8.8.8         # Google DNS
   ```

4. **Шаг 4: Проверь DNS**:
   ```bash
   dig google.com +short     # Имя → IP?
   ping -c 2 google.com      # По имени?
   ```

5. **Напиши скрипт-диагностик** `$DIR/diagnose.sh`:
   ```bash
   #!/bin/bash
   echo "═══ Network Diagnosis ═══"
   
   echo -n "Loopback: "; ping -c 1 -W 2 127.0.0.1 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"
   echo -n "Gateway:  "; GW=$(ip route 2>/dev/null | grep default | awk '{print $3}'); [ -n "$GW" ] && ping -c 1 -W 2 "$GW" &>/dev/null && echo "✓ OK ($GW)" || echo "✗ FAIL"
   echo -n "Internet: "; ping -c 1 -W 2 8.8.8.8 &>/dev/null && echo "✓ OK" || echo "✗ FAIL"
   echo -n "DNS:      "; dig google.com +short &>/dev/null && echo "✓ OK" || echo "✗ FAIL"
   echo "═══ End of Diagnosis ═══"
   ```

6. Запусти: `chmod +x diagnose.sh && ./diagnose.sh`

📂 Рабочий каталог: `~/.termtrainer/netdebug_003`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_003

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_003"
score=0

if [ -f "$DIR/diagnose.sh" ]; then
  chmod +x "$DIR/diagnose.sh"
  out=$(bash "$DIR/diagnose.sh" 2>&1)
  echo "$out" | grep -q "OK\|FAIL\|Diagnosis" && { echo "✓ diagnose.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Алгоритм расследования освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши diagnose.sh (баллов: $score/1)"
exit 1

HINTS
Step 1: ping 127.0.0.1 — проверить что сетевой стек работает
Step 2: найти шлюз (ip route | grep default) и пингануть его
Step 3: ping 8.8.8.8 — доступен ли внешний мир по IP?
Step 4: dig/ping по имени — работает ли DNS?
Если IP ок но имя нет → DNS проблема
Если шлюз ок но внешний нет → провайдер проблема
Если loopback не ок → сломан сетевой стек
