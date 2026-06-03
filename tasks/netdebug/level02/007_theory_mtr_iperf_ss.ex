META
# Track: netdebug
# Title: Глубокое зрение
# Number: 007
# Level: 2
# Type: theory
# Difficulty: medium
# TimeLimitMin: 15
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_007"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #007: Глубокое зрение

Астролог подвёл тебя к телескопу:
«Ринсвинд! Ping показывает только ДОСТУПНОСТЬ. Но где именно
теряются пакеты? Насколько быстрым должен быть канал?
Какие TCP-соединения живы? Для этого нужны другие инструменты —
mtr, iperf3 и ss. Это как телескоп, спектрограф и микроскоп.»

───────────────────────────────────────
🔹 MTR — КАРТА ПОТЕРЬ ПО ХОПАМ
───────────────────────────────────────

```bash
mtr -r -c 10 google.com       # Отчёт: 10 пакетов на каждый хоп
traceroute google.com          # Альтернатива (проще)
```

• Каждый хоп — маршрутизатор на пути пакета
• `Loss%` — процент потерь на хопе
• `Avg` — средняя задержка
• Если потери начинаются с хопа N → проблема между N-1 и N!

───────────────────────────────────────
🔹 IPERF3 — ИЗМЕРЕНИЕ ПРОПУСКНОЙ СПОСОБНОСТИ
───────────────────────────────────────

```bash
# На сервере:
iperf3 -s                      # Запустить сервер

# На клиенте:
iperf3 -c server_ip            # Тест скорости
iperf3 -c server_ip -u -b 100M # UDP тест с полосой 100 Мбит/с
```

• `-t 30` — длительность теста в секундах
• `-P 4` — 4 параллельных потока
• Показывает: bandwidth, jitter, packet loss

───────────────────────────────────────
🔹 SS — СОСТОЯНИЕ TCP-СОЕДИНЕНИЙ
───────────────────────────────────────

```bash
ss -t                         # Все TCP-соединения
ss -tl                        # Listening порты
ss -s                         # Статистика по состояниям
ss -ti                        # Детали: RTT, CWND, retransmits!
```

📖 **TCP-состояния**:
• `ESTAB` — активное соединение
• `TIME-WAIT` — закрытое, но ждёт очистки (много = проблема!)
• `CLOSE-WAIT` — удалённая сторона закрыла, локальная — нет (утечка!)
• `SYN-SENT` — пытаемся подключиться (если висит → firewall?)

📂 Рабочий каталог: `~/.termtrainer/netdebug_007`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_007
📋 **Попробуй**:
1. `traceroute google.com` или `mtr -r -c 5 google.com`
2. `ss -s` — статистика TCP
3. `ss -tl` — слушающие порты

VALIDATION
#!/bin/bash
score=0

trace=$(traceroute google.com 2>&1 | head -5 || mtr -r -c 1 google.com 2>&1 | head -5)
[ -n "$trace" ] && { echo "✓ Traceroute/mtr работает"; score=$((score+1)); }

ss_out=$(ss -s 2>/dev/null | head -3)
[ -n "$ss_out" ] && { echo "✓ ss работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Глубокое зрение освоено! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
MTR report: mtr -r -c 10 host — потери и задержка по каждому хопу
Traceroute: traceroute host — путь пакетов до хоста
Loss% in mtr: если потери начинаются с хопа N → проблема там!
iperf3 server: iperf3 -s — запустить сервер для теста скорости
iperf3 client: iperf3 -c host — измерить пропускную способность
SS connections: ss -t — все TCP-соединения
SS listening: ss -tl — какие порты слушают
SS states: ss -s — статистика по ESTAB/TIME-WAIT/CLOSE-WAIT
