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
DIR="$HOME/.ninja_trainer/netdebug_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 **tshark и расшифровка TLS**

tcpdump — только заголовки. tshark — командная строка Wireshark с пониманием протоколов. А TLS-расшифровка открывает зашифрованный трафик.

📖 **tshark — Wireshark в терминале**:
• `tshark -i any -c 20` — захватить 20 пакетов
• `tshark -i any -f "port 443"` — фильтр захвата (BPF)
• `tshark -i any -Y "http.request"` — фильтр отображения (Wireshark-style)
• `tshark -r file.pcap` — читать из pcap-файла
• `tshark -r file.pcap -Y "dns"` — фильтр при чтении

📖 **Извлечение полей**:
• `tshark -r file.pcap -T fields -e ip.src -e ip.dst -e tcp.dstport`
• `-T json` — вывод в JSON (для jq!)
• `-T fields -e frame.time -e ip.src -e tcp.srcport -e ip.dst -e tcp.dstport`

📖 **Статистика**:
• `tshark -r file.pcap -z conv,tcp` — TCP-конверсации
• `tshark -r file.pcap -z io,stat,1` — статистика по секундам
• `tshark -r file.pcap -z proto,colinfo,dns.qry.name,dns.qry.name` — DNS-запросы

📖 **Расшифровка TLS**:
• Логирование pre-master secret: `export SSLKEYLOGFILE=~/sslkeys.log`
• Запустить curl/Chrome с этой переменной → ключи пишутся в файл
• В Wireshark: Edit → Preferences → Protocols → TLS → (Pre)-Master-Secret log filename
• В tshark: `tshark -r file.pcap -o tls.keylog_file:~/sslkeys.log`
• После расшифровки видно HTTP/2 внутри TLS!

📖 **openssl s_client — проверка TLS**:
• `openssl s_client -connect google.com:443 -servername google.com`
• Показывает: версию протокола, шифр, сертификат, цепочку
• `openssl s_client -connect host:443 </dev/null 2>/dev/null | openssl x509 -noout -dates`
• Проверка срока сертификата!

📂 Рабочий каталог: `~/.ninja_trainer/netdebug_012`

📋 **Попробуй**:
1. TLS-информация: `openssl s_client -connect google.com:443 -servername google.com </dev/null 2>&1 | grep -E "Protocol|Cipher|Verify"`
2. Срок сертификата: `echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -dates`
3. JSON через SSLKEYLOGFILE: `SSLKEYLOGFILE=/tmp/ssl.log curl -s https://google.com && cat /tmp/ssl.log | head -5`

VALIDATION
#!/bin/bash
score=0

if command -v openssl &>/dev/null; then
  echo "✓ openssl установлен"; score=$((score+1))
fi

tls_proto=$(echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | grep "Protocol")
[ -n "$tls_proto" ] && { echo "✓ TLS подключение работает: $tls_proto"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: tshark и TLS освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Tshark capture: tshark -i any -c 20 — захват пакетов
Tshark filter: tshark -i any -Y "http.request" — фильтр отображения
Tshark fields: tshark -r file -T fields -e ip.src -e ip.dst -e tcp.dstport
Tshark JSON: tshark -r file -T json | jq '.' — парсинг через jq
TLS keylog: export SSLKEYLOGFILE=~/sslkeys.log → curl/write keys to file
Decrypt in tshark: tshark -r file -o tls.keylog_file:~/sslkeys.log
OpenSSL connect: openssl s_client -connect host:443 -servername host
Cert dates: echo | openssl s_client host:443 2>/dev/null | openssl x509 -noout -dates
