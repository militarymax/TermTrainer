META
# Track: cicd
# Title: Наблюдение за конвейером
# Number: 014
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 35

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/cicd_014"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #014: Наблюдение за конвейером

Архиканцлер указал на панель с мигающими огнями:
«Ринсвинд! Конвейер без мониторинга — как Башня без окон!
Нужно знать: сколько длится сборка? Какие шаги падают?
Какой процент успешных деплоев? Напиши скрипт-наблюдатель!»

📋 **Задания**:

1. **Напиши `pipeline_monitor.sh`**:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   echo "═══ Pipeline Monitor ═══"
   echo "Date: $(date)"
   
   # GitHub Actions status via gh CLI:
   if command -v gh &>/dev/null; then
     echo ""
     echo "── Recent Workflow Runs ──"
     gh run list --limit=10 2>/dev/null || echo "(gh not authenticated)"
     
     echo ""
     echo "── Failed Runs ──"
     gh run list --status=failure --limit=5 2>/dev/null || echo "(no failures)"
   fi
   
   echo ""
   echo "── Git Status ──"
   git log --oneline -10 2>/dev/null || echo "(not a git repo)"
   
   echo ""
   echo "── Branches ──"
   git branch -a 2>/dev/null | head -10
   
   echo ""
   echo "── Docker Images (local) ──"
   docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" 2>/dev/null | head -10 || echo "(docker not running)"
   
   echo ""
   echo "═══ End of Monitor Report ═══"
   ```

2. **Создай `.github/workflows/monitor.yml`** для регулярной проверки:
   ```yaml
   name: Pipeline Health Check
   on:
     schedule:
       - cron: '0 9 * * 1-5'    # Рабочие дни в 9:00
     workflow_dispatch:
   
   jobs:
     health-check:
       runs-on: ubuntu-latest
       steps:
       - run: |
           echo "Checking pipeline health..."
           gh run list --limit=20
           gh run list --status=failure --limit=10
         env:
           GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
   ```

3. Запусти: `chmod +x pipeline_monitor.sh && ./pipeline_monitor.sh`

📂 Рабочий каталог: `~/.ninja_trainer/cicd_014`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/cicd_014"
score=0

if [ -f "$DIR/pipeline_monitor.sh" ]; then
  chmod +x "$DIR/pipeline_monitor.sh"
  out=$(bash "$DIR/pipeline_monitor.sh" 2>&1)
  echo "$out" | grep -q "Monitor\|Git\|Docker\|Workflow" && { echo "✓ pipeline_monitor.sh работает"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Мониторинг конвейера освоен! (баллов: $score/1)"; exit 0; }
echo "✗ Напиши pipeline_monitor.sh (баллов: $score/1)"
exit 1

HINTS
gh CLI: gh run list — список запусков workflow
gh run list --status=failure — только упавшие запуски
Schedule cron: '0 9 * * 1-5' — рабочие дни в 9:00
workflow_dispatch: ручной запуск через UI
Docker images: локальный аудит собранных образов
Git log: последние коммиты для контекста
