META
# Track: text-fu
# Title: Дешифровка древних текстов
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cat > "$DIR/логи_сервера.txt" << 'EOF'
2024-01-15 10:23:45 INFO Server started
2024-01-15 10:24:12 ERROR Connection refused: port 8080
2024-01-15 10:25:01 WARNING Memory usage: 85%
2024-01-15 10:26:33 ERROR Disk full: /dev/sda1
2024-01-15 10:27:00 INFO User login: rincewind
2024-01-15 10:28:15 ERROR Permission denied: /etc/shadow
2024-01-15 10:29:42 WARNING CPU temperature: 92°C
2024-01-15 10:30:00 INFO Backup completed
2024-01-15 10:31:11 ERROR Segmentation fault in process 4521
2024-01-15 10:32:05 INFO User logout: rincewind
EOF
cat > "$DIR/контакты.txt" << 'EOF'
Ринсвинд: rincewind@unseen.university
Библиотекарь: librarian@unseen.university (НЕ ПИСАТЬ!)
Декан: dean@unseen.university
Коэн: conan@barbarian.org
Маграт: magrat@lancre.gov
Служба поддержки: support@university.help
Спам: viagra@cheap.pills (ИГНОРИРОВАТЬ)
Спам: winmoney@scam.net (ИГНОРИРОВАТЬ)
EOF
cat > "$DIR/пароли.txt" << 'EOF'
user1:MyPass123
user2:WeakPass
user3:Str0ng!Pass
user4:12345
user5:CorrectHorseBatteryStaple
user6:qwerty
user7:P@ssw0rd!
user8:admin
EOF
cat > "$DIR/стихи.txt" << 'EOF'
Ветер воет в башне старой
Дождь стучит в окно
Маг колдует над отваром
Всё предрешено

Огонь пылает в кузне
Вода бежит с небес
Земля дрожит от гула
И Хаос interest
EOF

TASK
🔐 **Дешифровка древних текстов** — практика regex

В твои руки попали зашифрованные свитки. Обычный grep не справляется — нужна мощь регулярных выражений для извлечения смысла из хаоса.

📋 **Задания**:
1. Создай `только_ошибки.txt`: выведи строки только с ERROR из `логи_сервера.txt`
2. Создай `ошибки_и_предупреждения.txt`: строки с ERROR **ИЛИ** WARNING
3. Создай `email_университета.txt`: найди все email, оканчивающиеся на `@unseen.university`
4. Создай `не_спам.txt`: все строки из `контакты.txt`, **НЕ** содержащие `Спам:` или `ИГНОРИРОВАТЬ`
5. Создай `сложные_пароли.txt`: найди пароли, содержащие **хотя бы одну заглавную букву, одну строчную и одну цифру** (одним regex!)
6. Создай `временные_метки.txt`: вырежи только дату и время (первые 19 символов) из `логи_сервера.txt` с помощью `cut -c1-19`
7. Найди все строки в `стихи.txt`, начинающиеся с заглавной буквы — сохрани в `заглавные_строки.txt`

📂 Рабочий каталог: `~/.termtrainer/textfu_014`

⚡ Подсказки по regex:
• `ERROR|WARNING` — ИЛИ
• `\.university$` — заканчивается на .university
• `[A-ZА-Я]` — любая заглавная буква
• `[a-zа-я]` — любая строчная
• `[0-9]` — цифра
• Для сложного пароля: `grep -E '[A-ZА-Я]' | grep -E '[a-zа-я]' | grep -E '[0-9]'`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/textfu_014"
score=0

if [ ! -f "$DIR/логи_сервера.txt" ]; then
  echo "✗ fail: логи_сервера.txt не найден"
  exit 1
fi

# 1. Только ошибки
if [ -f "$DIR/только_ошибки.txt" ]; then
  if ! grep -q "INFO\|WARNING" "$DIR/только_ошибки.txt" 2>/dev/null; then
    echo "✓ только_ошибки.txt: только ERROR"
    score=$((score + 1))
  fi
fi

# 2. Ошибки и предупреждения
if [ -f "$DIR/ошибки_и_предупреждения.txt" ]; then
  if grep -q "ERROR\|WARNING" "$DIR/ошибки_и_предупреждения.txt" 2>/dev/null; then
    echo "✓ ошибки_и_предупреждения.txt созданы"
    score=$((score + 1))
  fi
fi

# 3. Email университета
if [ -f "$DIR/email_университета.txt" ]; then
  echo "✓ email_университета.txt создан"
  score=$((score + 1))
fi

# 4. Не спам
if [ -f "$DIR/не_спам.txt" ]; then
  if ! grep -qi "спам\|игнорировать" "$DIR/не_спам.txt" 2>/dev/null; then
    echo "✓ не_спам.txt: без спама"
    score=$((score + 1))
  fi
fi

# 5. Сложные пароли
if [ -f "$DIR/сложные_пароли.txt" ]; then
  echo "✓ сложные_пароли.txt создан"
  score=$((score + 1))
fi

echo "✓ ok: Дешифровка завершена (баллов: $score/5)"
exit 0

HINTS
Только ERROR: grep 'ERROR' логи_сервера.txt > только_ошибки.txt
ERROR или WARNING: grep -E 'ERROR|WARNING' логи_сервера.txt > ошибки_и_предупреждения.txt
Email университета: grep -E '@unseen\.university$' контакты.txt > email_университета.txt
Не спам: grep -vE 'Спам:|ИГНОРИРОВАТЬ' контакты.txt > не_спам.txt
Сложные пароли: grep -E '[A-ZА-Я]' пароли.txt | grep -E '[a-zа-я]' | grep -E '[0-9]' > сложные_пароли.txt
Временные метки: cut -c1-19 логи_сервера.txt > временные_метки.txt
Заглавные строки: grep -E '^[A-ZА-Я]' стихи.txt > заглавные_строки.txt