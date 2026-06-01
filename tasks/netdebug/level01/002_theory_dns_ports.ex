META
# Track: netdebug
# Title: DNS и порты
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 10
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/netdebug_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **DNS и порты**

«Нет интернета» — чаще всего проблема в DNS или закрытых портах. Научись проверять и то, и другое.

📖 **DNS-записи**:
• A-запись: `dig example.com A` — IPv4-адрес
• CNAME: `dig www.google.com CNAME` — алиас (псевдоним)
• MX: `dig gmail.com MX` — почтовые серверы
• NS: `dig google.com NS` — авторитетные DNS-серверы
• `dig +short google.com` — только IP без лишнего
• `dig +trace google.com` — полный путь от корневых серверов

📖 **Проверка открытых портов**:
• `nc -zv host port` — проверить TCP-порт (netcat)
• `nc -zv google.com 443` — открыт ли HTTPS?
• `nc -zv -u host port` — проверить UDP-порт
• `telnet host port` — классический способ (устаревший)

📖 **Слушающие порты на своей машине**:
• `ss -tulpn` — все слушающие TCP/UDP порты с процессами
• `ss -tlnp | grep :80` — кто слушает на порту 80?
• `lsof -i :8080` — какой процесс на порту 8080?

📖 **HTTP-запросы вручную**:
• `curl -v http://example.com` — подробный вывод с заголовками
• `curl -sI http://example.com` — только заголовки ответа
• `curl -o /dev/null -w "HTTP %{http_code}, Time: %{time_total}s\n"` — код + время

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_002`

📋 **Попробуй**:
1. DNS A-запись: `dig google.com +short`
2. MX-запись: `dig gmail.com MX +short`
3. Проверь порт: `nc -zv google.com 443 && echo "OPEN"`
4. Слушающие порты: `ss -tlnp | head -10`
5. HTTP-ответ: `curl -sI https://google.com | head -5`

VALIDATION
#!/bin/bash
score=0

dns=$(dig google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает: $dns"; score=$((score+1)); }

ports=$(ss -tlnp 2>/dev/null | wc -l)
[ "$ports" -ge 2 ] && { echo "✓ ss работает ($ports строк)"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: DNS и порты освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
A record: dig domain.com +short — IP-адрес домена
MX record: dig domain.com MX — почтовые серверы
CNAME: dig alias.domain.com CNAME — псевдоним
Check port: nc -zv host port — открыт ли TCP-порт
Listening ports: ss -tulpn — все слушающие порты
Who listens: ss -tlnp | grep :PORT или lsof -i :PORT
Curl verbose: curl -v URL — заголовки запроса и ответа
Curl headers only: curl -sI URL — только заголовки ответа
