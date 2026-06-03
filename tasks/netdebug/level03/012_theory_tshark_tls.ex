META
# Track: netdebug
# Title: tshark и расшифровка TLS
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/netdebug_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: tshark и расшифровка TLS

В Тайной Комнате Архиканцлер открыл сундук:
«Ринсвинд! tcpdump видит только заголовки. Но tshark — это Wireshark
в терминале, он понимает протоколы. А TLS-расшифровка открывает
зашифрованный трафик. Это как читать запечатанные письма.
Но НЕ ЧУЖИЕ! Только свои! Мы не варвары.»

───────────────────────────────────────
🔹 TSHARK — WIRESHARK В ТЕРМИНАЛЕ
───────────────────────────────────────

```bash
tshark -i any -c 20                    # Захватить 20 пакетов
tshark -i any -f "port 443"            # BPF фильтр захвата
tshark -i any -Y "http.request"        # Фильтр отображения
tshark -r file.pcap                    # Читать из pcap файла
```

📖 **Извлечение полей**:
```bash
tshark -r file.pcap -T fields -e ip.src -e ip.dst -e tcp.dstport
tshark -r file.pcap -T json            # Вывод в JSON!
```

📖 **Статистика**:
```bash
tshark -r file.pcap -z conv,tcp       # TCP-конверсации
tshark -r file.pcap -z io,stat,1       # Статистика по секундам
```

───────────────────────────────────────
🔹 РАСШИФРОВКА TLS
───────────────────────────────────────

```bash
# Логирование pre-master secret:
export SSLKEYLOGFILE=~/sslkeys.log

# Запустить curl/Chrome → ключи пишутся в файл
curl https://google.com

# Расшифровка в tshark:
tshark -r file.pcap -o tls.keylog_file:~/sslkeys.log
```

───────────────────────────────────────
🔹 OPENSSL S_CLIENT — ПРОВЕРКА TLS
───────────────────────────────────────

```bash
openssl s_client -connect google.com:443 -servername google.com
# Показывает: версию протокола, шифр, сертификат, цепочку

# Срок сертификата:
echo | openssl s_client -connect host:443 2>/dev/null | openssl x509 -noout -dates
```

📂 Рабочий каталог: `~/.termtrainer/netdebug_012`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/netdebug_012
📋 **Попробуй**:
1. `openssl s_client -connect google.com:443 -servername google.com </dev/null 2>&1 | grep -E "Protocol|Cipher"`
2. `echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -dates`

VALIDATION
#!/bin/bash
score=0

tls_proto=$(echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | grep "Protocol")
[ -n "$tls_proto" ] && { echo "✓ TLS подключение: $tls_proto"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: tshark и TLS освоены! (баллов: $score/1)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Tshark capture: tshark -i any -c N — захват N пакетов
Tshark filter: tshark -Y "http.request" — фильтр отображения
Tshark fields: tshark -T fields -e ip.src -e ip.dst — извлечь поля
Tshark JSON: tshark -T json | jq '.' — вывод в JSON для парсинга
SSLKEYLOGFILE: экспорт переменной → curl пишет ключи в файл
Decrypt in tshark: tshark -o tls.keylog_file:file — расшифровать трафик
OpenSSL connect: openssl s_client -connect host:443 — проверить TLS
Cert dates: openssl x509 -noout -dates — срок действия сертификата
