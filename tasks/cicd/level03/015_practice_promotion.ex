META
# Track: cicd
# Title: Продвижение заклинаний по средам
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #015: Продвижение заклинаний по средам

Архиканцлер указал на три двери — dev, staging, production:
«Ринсвинд! Заклинание должно пройти ВСЕ стадии перед production!
Dev → автоматический деплой. Staging → автотесты.
Production → ручное подтверждение + canary release.
И откат при любой ошибке! Напиши полный pipeline продвижения.»

📋 **Задания**:

1. **Напиши `promote.sh`** — скрипт продвижения:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   IMAGE="${1:?Usage: promote.sh <image> <env>}"
   ENV="${2:-staging}"
   
   echo "═══ Promoting $IMAGE to $ENV ═══"
   
   case "$ENV" in
     dev)
       echo "🟢 Auto-deploying to dev..."
       echo "kubectl set image deploy/tower-app tower-app=$IMAGE -n tower-dev"
       ;;
     staging)
       echo "🟡 Deploying to staging with tests..."
       echo "kubectl set image deploy/tower-app tower-app=$IMAGE -n tower-staging"
       echo "Running integration tests..."
       # Simulated test:
       sleep 2
       echo "✓ Tests passed!"
       ;;
     production)
       echo "🔴 PRODUCTION DEPLOY!"
       read -p "Confirm promotion to production? [y/N] " confirm
       [[ "$confirm" == "y" ]] || { echo "Aborted"; exit 1; }
       echo "Canary: routing 10% traffic to new version..."
       echo "Monitoring for 5 minutes..."
       echo "Full rollout!"
       echo "kubectl set image deploy/tower-app tower-app=$IMAGE -n tower-production"
       ;;
     *)
       echo "Unknown environment: $ENV"
       exit 1
       ;;
   esac
   
   echo "✅ Promoted to $ENV!"
   ```

2. **Создай `.github/workflows/promotion.yml`**:
   ```yaml
   name: Spell Promotion
   on:
     workflow_dispatch:
       inputs:
         environment:
           description: 'Target environment'
           required: true
           type: choice
           options: [dev, staging, production]
         image_tag:
           description: 'Image tag to promote'
           required: true
   
   jobs:
     promote:
       runs-on: ubuntu-latest
       environment: ${{ github.event.inputs.environment }}
       steps:
       - run: |
           echo "Promoting ${{ github.event.inputs.image_tag }} to ${{ github.event.inputs.environment }}"
   ```

3. Запусти: `chmod +x promote.sh && ./promote.sh ghcr.io/tower:v1.0 staging`

📂 Рабочий каталог: `~/.termtrainer/cicd_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_015"
score=0

if [ -f "$DIR/promote.sh" ]; then
  chmod +x "$DIR/promote.sh"
  out=$(bash "$DIR/promote.sh" test-image:v1 staging 2>&1)
  echo "$out" | grep -q "Promoting\|staging\|Tests" && { echo "✓ promote.sh работает"; score=$((score+1)); }
fi

[ -f "$DIR/.github/workflows/promotion.yml" ] && grep -q "environment\|promote\|dispatch" "$DIR/.github/workflows/promotion.yml" && { echo "✓ promotion.yml создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: Продвижение по средам освоено! (баллов: $score/2)"; exit 0; }
echo "✗ Создай promote.sh и workflow (баллов: $score/2)"
exit 1

HINTS
Environment promotion: dev (auto) → staging (tests) → production (manual)
Canary release: направить часть трафика на новую версию для проверки
Blue-green: две версии одновременно, мгновенное переключение
workflow_dispatch: ручной запуск с параметрами (environment, tag)
GitHub environments: protection rules + approval для production
Rollback: kubectl rollout undo если canary показал ошибки
