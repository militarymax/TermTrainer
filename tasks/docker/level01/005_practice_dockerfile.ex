META
# Track: docker
# Title: Свой рецепт сосуда
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/app"
cat > "$DIR/app/hello.sh" << 'SCRIPT'
#!/bin/bash
echo "═══════════════════════════════"
echo "  Welcome to Unseen University!"
echo "  Tower: ${TOWER_NAME:-Unknown}"
echo "  Floor: ${TOWER_FLOOR:-1}"
echo "═══════════════════════════════"
SCRIPT

TASK
⚗️ ПРАКТИКУМ #005: Свой рецепт сосуда

Архиканцлер швырнул на стол пустой пергамент:
«Ринсвинд! Хватит пользоваться чужими рецептами!
Напиши СВОЙ Dockerfile! Создай сосуд с нуля,
засунь туда свой скрипт и запусти.
И чтобы USER nobody — мы не хотим чтобы демон
внутри сосуда получил права root. Помнишь прошлый раз?
Демон сбежал и три дня пил всё вино в подвале.»

📋 **Задания**:

1. **Создай `Dockerfile`**:
   ```dockerfile
   FROM alpine:3.19
   RUN apk add --no-cache bash
   WORKDIR /app
   COPY hello.sh .
   RUN chmod +x hello.sh && \
       adduser -D appuser
   USER appuser
   ENV TOWER_NAME="Unseen University"
   ENV TOWER_FLOOR="7"
   CMD ["./hello.sh"]
   ```

2. **Собери образ**:
   ```bash
   cd ~/.termtrainer/docker_005
   docker build -t university-app .
   ```

3. **Запусти**:
   ```bash
   docker run --rm university-app
   docker run --rm -e TOWER_FLOOR=42 university-app    # Переопределить!
   ```

4. **Проверь что работает не от root**:
   ```bash
   docker run --rm university-app whoami    # → appuser
   ```

📂 Рабочий каталог: `~/.termtrainer/docker_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_005"
score=0

if [ -f "$DIR/Dockerfile" ]; then
  grep -qi "FROM\|COPY\|CMD\|RUN" "$DIR/Dockerfile" && { echo "✓ Dockerfile создан"; score=$((score+1)); }
  
  cd "$DIR" && docker build -t tower_test_app . &>/dev/null && { echo "✓ Образ собран"; score=$((score+1)); }
  
  out=$(docker run --rm tower_test_app 2>&1)
  echo "$out" | grep -q "University\|Tower\|Floor" && { echo "✓ Приложение работает"; score=$((score+1)); }
fi

[ $score -ge 2 ] && { echo "✓ ok: Dockerfile освоен! (баллов: $score/3)"; exit 0; }
echo "✗ Создай Dockerfile (баллов: $score/3)"
exit 1

HINTS
FROM: базовый образ (alpine, ubuntu, nginx...)
RUN: выполнить команду при сборке (apk add, mkdir...)
COPY: скопировать файл с хоста в образ
WORKDIR: рабочий каталог внутри образа
USER: переключиться на непривилегированного пользователя!
ENV: переменные окружения по умолчанию
CMD: команда при запуске контейнера
Build: docker build -t name . — собрать образ (-t = тег)
