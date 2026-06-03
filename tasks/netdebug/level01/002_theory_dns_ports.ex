META
# Track: netdebug
# Title: Имена и порталы
# Number: 002
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_002"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #002: Имена и порталы

Библиотекарь положил перед тобой два свитка:
один с именами, другой с номерами порталов.
«Ууук!» — это означало: «DNS превращает имена в адреса.
Порты — это номера комнат в Башне.
Не знаешь имени — не найдёшь адрес.
Не знаешь порт — не попадёшь в нужную дверь.»

───────────────────────────────────────
🔹 DNS — КНИГА ИМЁН
───────────────────────────────────────

```bash
dig google.com +short       # → 142.250.XX.XX (только IP)
dig google.com ANY          # Все записи
nslookup google.com         # Альтернатива (проще)
host google.com             # Ещё альтернатива

dig @8.8.8.8 google.com     # Спросить конкретный DNS-сервер
```

📖 **Типы записей**:
• `A` — IPv4 адрес (google.com → 142.250.XX.XX)
• `AAAA` — IPv6 адрес
• `CNAME` — псевдоним (www.google.com → google.com)
• `MX` — почтовый сервер
• `NS` — DNS-сервер домена

───────────────────────────────────────
🔹 ПОРТЫ — НОМЕРА КОМНАТ
───────────────────────────────────────

```bash
nc -zv google.com 443       # Открыт ли порт? (timeout -W 3)
nc -zv google.com 80        # HTTP
nc -zv google.com 22        # SSH
```

📖 **Стандартные порты**:
• `22` — SSH (удалённый доступ)
• `80` — HTTP (веб без шифрования)
• `443` — HTTPS (веб с шифрованием)
• `53` — DNS (разрешение имён)
• `3306` — MySQL, `5432` — PostgreSQL
• `6379` — Redis, `8080` — часто для приложений

📂 Рабочий каталог: `~/.termtrainer/netdebug_002`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_002
📋 **Попробуй**:
1. `dig google.com +short` — IP по имени
2. `nslookup github.com` — ещё один способ
3. `nc -zv google.com 443` — открыт ли HTTPS?

VALIDATION
#!/bin/bash
score=0

dns=$(dig google.com +short 2>/dev/null | head -1)
[ -n "$dns" ] && { echo "✓ DNS работает: $dns"; score=$((score+1)); }

ns=$(nslookup google.com 2>/dev/null | grep "Address" | tail -1)
[ -n "$ns" ] && { echo "✓ nslookup работает"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: DNS и порты освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Dig short: dig domain +short — только IP-адрес
Dig any: dig domain ANY — все типы записей
Nslookup: nslookup domain — простой запрос DNS
Specific DNS: dig @8.8.8.8 domain — спросить конкретный сервер
Netcat check: nc -zv host port — открыт ли порт?
Common ports: 22=SSH, 80=HTTP, 443=HTTPS, 53=DNS
A record: IPv4 адрес домена
CNAME: псевдоним (алиас) для другого домена
