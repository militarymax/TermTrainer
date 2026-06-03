META
# Track: docker
# Title: Production-алхимия
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #015: Production-алхимия

Архиканцлер вызвал тебя в командный центр:
«Ринсвинд! Это PRODUCTION. Сосуды не просто работают —
они должны ЗДОРОВЫМИ быть. Healthchecks, cleanup, blue-green
deploy... Если сосуд упадёт — пользователи Башни останутся
без зелий. А без зелий они становятся... нервными. Очень.»

📋 **Задания**:

ASSIGNMENT
1. **Dockerfile с healthcheck**:
   ```dockerfile
   FROM nginx
   HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
     CMD curl -f http://localhost/ || exit 1
   ```
   ```bash
   docker build -t healthy-app .
   docker run -d --name healthy -p 9090:80 healthy-app
   
   # Проверить здоровье:
   docker inspect healthy | jq '.[0].State.Health.Status'
   docker inspect healthy | jq '.[0].State.Health.Log[-1]'
   ```

2. **Cleanup — уборка подвала**:
   ```bash
   docker system df                    # Сколько места жрут сосуды?
   docker system prune -f             # Удалить всё ненужное!
   docker image prune -a -f           # Удалить неиспользуемые образы
   docker volume prune -f             # Удалить пустые тома
   ```

3. **Blue-Green deploy** (через скрипт):
   Напиши `$DIR/deploy.sh`:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   CURRENT="${1:-blue}"
   
   if [[ "$CURRENT" == "blue" ]]; then
       NEW="green"
       PORT_OLD=9091; PORT_NEW=9092
   else
       NEW="blue"
       PORT_OLD=9092; PORT_NEW=9091
   fi
   
   echo "Deploying $NEW on port $PORT_NEW..."
   docker run -d --name "app_$NEW" -p "$PORT_NEW:80" nginx
   sleep 3
   
   if curl -sf "http://localhost:$PORT_NEW" >/dev/null; then
       echo "✅ $NEW is healthy! Switching traffic..."
       docker stop "app_$CURRENT" 2>/dev/null || true
       docker rm "app_$CURRENT" 2>/dev/null || true
       echo "$NEW" > "$DIR/current"
       echo "✅ Deployed: $NEW"
   else
       echo "❌ $NEW failed healthcheck! Rolling back..."
       docker stop "app_$NEW"; docker rm "app_$NEW"
       exit 1
   fi
   ```

4. **Запусти**: `chmod +x deploy.sh && ./deploy.sh blue`

📂 Рабочий каталог: `~/.termtrainer/docker_015`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/docker_015

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_015"
score=0

df_out=$(docker system df 2>&1 | head -5)
[ -n "$df_out" ] && { echo "✓ docker system df работает"; score=$((score+1)); }

if [ -f "$DIR/deploy.sh" ]; then
  head -1 "$DIR/deploy.sh" | grep -q '^#!' && { echo "✓ deploy.sh имеет шебанг"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Production-алхимия освоена! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
HEALTHCHECK: CMD curl -f http://localhost/ || exit 1 — проверка здоровья
Health status: docker inspect X | jq '.[0].State.Health.Status' — healthy/unhealthy
System df: docker system df — сколько места занимают образы/контейнеры/тома
Prune all: docker system prune -f — удалить всё ненужное
Image prune: docker image prune -a -f — удалить неиспользуемые образы
Volume prune: docker volume prune -f — удалить пустые тома
Blue-green: запустить новую версию → проверить → переключить трафик → убрать старую
Rollback: если новая версия не прошла healthcheck → удалить и оставить старую
