META
# Track: docker
# Title: Многоступенчатая алхимия
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #010: Многоступенчатая алхимия

Архиканцлер указал на огромный сосуд:
«Ринсвинд! Этот сосуд весит ПОЛГИГАБАЙТА! Там и компилятор,
и исходники, и временные файлы... Нам нужен только результат!
Научись многоступенчатой сборке — сначала варим в большом котле,
потом переливаем ТОЛЬКО готовое зелье в маленький сосуд.
И ограничь ресурсы — демон не должен сожрать всю память!»

📋 **Задания**:

ASSIGNMENT
1. **Многоступенчатый Dockerfile** — создай `$DIR/Dockerfile`:
   ```dockerfile
   # === Stage 1: Builder (большой котёл) ===
   FROM alpine:3.19 AS builder
   RUN echo '#!/bin/sh' > /app/greet.sh && \
       echo 'echo "Welcome to the Tower, ${NAME:-Apprentice}!"' >> /app/greet.sh && \
       chmod +x /app/greet.sh
   
   # === Stage 2: Runtime (маленький сосуд) ===
   FROM alpine:3.19
   RUN adduser -D appuser
   COPY --from=builder /app/greet.sh /home/appuser/
   USER appuser
   WORKDIR /home/appuser
   CMD ["./greet.sh"]
   ```

2. **Собери и запусти**:
   ```bash
   cd ~/.termtrainer/docker_010
   docker build -t tower-greet .
   docker run --rm tower-greet
   docker run --rm -e NAME=Rincewind tower-greet
   ```

3. **Ограничение ресурсов**:
   ```bash
   # Ограничить память и CPU
   docker run --rm -m 128m --cpus=1 tower-greet
   
   # Проверить лимиты через inspect+jq
   docker inspect <id> | jq '.[0].HostConfig.Memory'
   ```

4. **Сравни размеры образов**:
   ```bash
   docker images | grep tower-greet    # Маленький!
   ```

📂 Рабочий каталог: `~/.termtrainer/docker_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_010"
score=0

if [ -f "$DIR/Dockerfile" ]; then
  grep -qi "FROM.*AS\|COPY --from" "$DIR/Dockerfile" && { echo "✓ Многоступенчатый Dockerfile"; score=$((score+1)); }
  
  cd "$DIR" && docker build -t tower_multi . &>/dev/null && { echo "✓ Образ собран"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Многоступенчатая сборка освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Создай многоступенчатый Dockerfile (баллов: $score/2)"
exit 1

HINTS
Multi-stage: FROM image AS builder → COPY --from=builder — два этапа сборки
Builder stage: компиляция/подготовка (не попадает в финальный образ)
Runtime stage: только результат + минимальный базовый образ
COPY --from: скопировать файл из предыдущего этапа
USER appuser: запускать от непривилегированного пользователя!
Memory limit: docker run -m 128m — ограничить память
CPU limit: docker run --cpus=1 — ограничить CPU
Image size: docker images — сравнить размер образов
