META
# Track: cicd
# Title: Развёртывание заклинаний
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #005: Развёртывание заклинаний

Архиканцлер указал на три двери:
«Ринсвинд! Staging — это тренировочный зал. Production — настоящий бой.
А Blue-Green — это когда оба зала работают одновременно,
и ты переключаешь посетителей мгновенно. Научись развёртывать!»

📋 **Задания**:

1. **Напиши `deploy.sh`** — скрипт деплоя:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   ENV="${1:-staging}"
   IMAGE_TAG="${2:-latest}"
   
   echo "═══ Deploying to $ENV ═══"
   echo "Image tag: $IMAGE_TAG"
   echo "Time: $(date)"
   
   if [[ "$ENV" == "production" ]]; then
     echo "⚠️ PRODUCTION DEPLOY!"
     read -p "Confirm? [y/N] " confirm
     [[ "$confirm" == "y" ]] || { echo "Aborted"; exit 1; }
   fi
   
   # Simulated deploy steps:
   echo "1. Pulling image: tower-app:$IMAGE_TAG"
   echo "2. Running health check..."
   echo "3. Switching traffic..."
   echo "✅ Deployed to $ENV!"
   ```

2. **Создай `.github/workflows/deploy.yml`**:
   ```yaml
   name: Deploy Spell
   on:
     push:
       branches: [main]
   
   jobs:
     deploy-staging:
       runs-on: ubuntu-latest
       environment: staging
       steps:
       - run: echo "🟡 Deploying to staging..."
     
     deploy-production:
       needs: deploy-staging
       runs-on: ubuntu-latest
       environment: production
       steps:
       - run: echo "🔴 Deploying to production!"
   ```

3. Запусти: `chmod +x deploy.sh && ./deploy.sh staging v1.0`

📂 Рабочий каталог: `~/.termtrainer/cicd_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_005"
score=0

if [ -f "$DIR/deploy.sh" ]; then
  chmod +x "$DIR/deploy.sh"
  out=$(echo "n" | bash "$DIR/deploy.sh" staging 2>&1)
  echo "$out" | grep -q "Deploy\|staging\|Image" && { echo "✓ deploy.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Деплой освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши deploy.sh (баллов: $score/1)"
exit 1

HINTS
Environments: staging → production — сначала тестовая среда, потом боевая
GitHub environments: environment: staging с approval для production
Blue-green: две версии одновременно, мгновенное переключение
Rolling update: постепенная замена подов без даунтайма
Canary: небольшая часть трафика на новую версию для проверки
Manual approval: в GitHub Environments можно требовать подтверждение
Tags for images: SHA хеш + semver тег для воспроизводимости
