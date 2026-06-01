META
# Track: netdebug
# Title: Продвинутые инструменты
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 10
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **Продвинутые инструменты**

ping и traceroute — хорошо, но mtr лучше. iperf3 измеряет скорость. ss показывает детали TCP.

📖 **mtr — ping + traceroute вместе**:
• `mtr google.com` — интерактивный вид (обновляется в реальном времени)
• `mtr -r -c 10 google.com` — отчёт за 10 циклов (для скриптов!)
• `mtr -rw -c 10 google.com` — широкий отчёт
• Показывает потери и RTT на каждом хопе

📖 **iperf3 — измерение пропускной способности**:
• Сервер: `iperf3 -s` (на одной машине)
• Клиент: `iperf3 -c server_ip` (на другой)
• `-P 4` — 4 параллельных потока
• `-R` — обратное направление (сервер → клиент)
• `-u -b 100M` — UDP-тест со скоростью 100 Мбит/с

📖 **ss — продвинутый netstat**:
• `ss -t -a` — все TCP-соединения
• `ss -t state established` — установленные соединения
• `ss -t state time-wait` — TIME_WAIT сокеты
• `ss -t -o` — с таймерами (keepalive, retransmit)
• `ss -ti` — детальная статистика: rtt, cwnd, retrans
• `ss -s` — сводка по состояниям

📖 **TCP-состояния**:
• SYN-SENT — пытаемся подключиться
• ESTABLISHED — соединение активно
• FIN-WAIT — закрываем соединение
• TIME-WAIT — ждём после закрытия
• CLOSE-WAIT — удалённая сторона закрыла, мы ещё нет

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_007`

📋 **Попробуй**:
1. mtr отчёт: `mtr -r -c 5 google.com`
2. TCP-соединения: `ss -t -a | head -20`
3. Сводка: `ss -s`

VALIDATION
#!/bin/bash
score=0

if command -v mtr &>/dev/null || command -v mtr-packet &>/dev/null; then
  echo "✓ mtr установлен"; score=$((score+1))
else
  echo "ℹ mtr не установлен (brew install mtr)"
fi

ss_out=$(ss -s 2>/dev/null)
[ -n "$ss_out" ] && { echo "✓ ss работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Продвинутые инструменты освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Установи mtr или используй ss"
exit 1

HINTS
MTR report: mtr -r -c 10 host — отчёт за N циклов
MTR interactive: mtr host — обновляется в реальном времени
iperf3 server: iperf3 -s — запустить сервер
iperf3 client: iperf3 -c server_ip — тест скорости
iperf3 parallel: iperf3 -c server -P 4 — 4 параллельных потока
SS all TCP: ss -t -a — все TCP-соединения
SS with timers: ss -t -o — таймеры keepalive/retransmit
SS detail: ss -ti — RTT, CWND, retransmissions per socket
