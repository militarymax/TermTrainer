META
# Track: cicd
# Title: Развёртывание в Кластер из Конвейера
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
⚗️ ПРАКТИКУМ #010: Развёртывание в Кластер из Конвейера

Архиканцлер указал на кристалл связи с кластером:
«Ринсвинд! После сборки образа нужно автоматически развернуть его
в Kubernetes! kubeconfig — это ключ от кластера. Храни его в Secrets!
А kubectl set image обновит деплоймент без ручного вмешательства.»

📋 **Задания**:

ASSIGNMENT
1. **Создай `.github/workflows/k8s-deploy.yml`**:
   ```yaml
   name: Deploy to Tower Cluster
   on:
     push:
       branches: [main]
   
   jobs:
     deploy:
       runs-on: ubuntu-latest
       environment: production
       steps:
       - uses: actions/checkout@v4
       
       - name: Configure kubectl
         run: |
           mkdir -p $HOME/.kube
           echo "${{ secrets.KUBE_CONFIG }}" | base64 -d > $HOME/.kube/config
       
       - name: Deploy to cluster
         run: |
           kubectl set image deployment/api-server \
             api-server=ghcr.io/${{ github.repository }}:${{ github.sha }} \
             -n tower-production
           kubectl rollout status deployment/api-server -n tower-production --timeout=120s
       
       - name: Verify deployment
         run: |
           kubectl get pods -n tower-production -l app=api-server
           kubectl get svc -n tower-production
   ```

2. **Напиши `deploy_check.sh`** для проверки здоровья:
   ```bash
   #!/bin/bash
   set -euo pipefail
   NS="${1:-tower-production}"
   DEPLOY="${2:-api-server}"
   
   echo "Checking $DEPLOY in $NS..."
   kubectl rollout status "deploy/$DEPLOY" -n "$NS" --timeout=120s
   pods=$(kubectl get pods -n "$NS" -l "app=$DEPLOY" --no-headers | grep -c Running || echo "0")
   echo "Running pods: $pods"
   [ "$pods" -ge 1 ] && echo "✅ Healthy!" || { echo "❌ Unhealthy!"; exit 1; }
   ```

📂 Рабочий каталог: `~/.termtrainer/cicd_010`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_010"
score=0

[ -f "$DIR/.github/workflows/k8s-deploy.yml" ] && grep -q "kubectl\|deploy\|kube" "$DIR/.github/workflows/k8s-deploy.yml" && { echo "✓ k8s-deploy.yml создан"; score=$((score+1)); }

[ -f "$DIR/deploy_check.sh" ] && grep -q "rollout\|kubectl\|Healthy" "$DIR/deploy_check.sh" && { echo "✓ deploy_check.sh создан"; score=$((score+1)); }

[ $score -ge 1 ] && { echo "✓ ok: K8s деплой из CI освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Создай workflow и скрипт проверки (баллов: $score/2)"
exit 1

HINTS
Kubeconfig in secrets: base64 encode → store as GitHub Secret → decode in CI
Set image: kubectl set image deploy/NAME CONTAINER=IMAGE:TAG — обновить образ
Rollout status: kubectl rollout status deploy/NAME — следить за прогрессом
Environment protection: approval перед деплоем на production
Helm upgrade: helm upgrade --install RELEASE CHART — альтернатива через Helm
ArgoCD: GitOps подход — кластер сам подтягивает изменения из git
