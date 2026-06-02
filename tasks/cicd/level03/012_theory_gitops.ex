META
# Track: cicd
# Title: GitOps — Магия, которая сама себя пишет
# Number: 012
# Level: 3
# Type: theory
# Difficulty: hard
# TimeLimitMin: 15
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_012"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #012: GitOps — Магия, которая сама себя пишет

В Тайной Комнате Архиканцлер открыл последний свиток:
«Ринсвинд! GitOps — это когда Книга Заклинаний (Git) становится
ЕДИНСТВЕННЫМ источником правды. Кластер САМ читает книгу и
применяет изменения. Не ты деплоишь — кластер подтягивает!
ArgoCD — это демон, который следит за книгой и применяет заклинания.
FluxCD — другой демон, делает то же самое.»

───────────────────────────────────────
🔹 GITOPS ПРИНЦИПЫ
───────────────────────────────────────

📖 **Декларативное описание**: всё состояние в Git (YAML)
📖 **Автоматическая синхронизация**: кластер → git pull → apply
📖 **Наблюдаемость**: diff между желаемым и реальным состоянием
📖 **Откат**: git revert → кластер откатится сам!

```
Push model (традиционный CI/CD):
  CI → kubectl apply → кластер

Pull model (GitOps):
  CI → push to git → ArgoCD/Flux detects change → applies to cluster
```

───────────────────────────────────────
🔹 ARGOCD — ДЕМОН СИНХРОНИЗАЦИИ
───────────────────────────────────────

ASSIGNMENT
```bash
# Установка ArgoCD:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# CLI:
brew install argocd
argocd login argocd.example.com

# Приложение из Git:
argocd app create tower-app \
  --repo https://github.com/org/tower-manifests.git \
  --path k8s/ \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace tower-production
```

```yaml
# Application CRD:
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: tower-app
spec:
  project: default
  source:
    repoURL: https://github.com/org/tower-manifests.git
    targetRevision: main
    path: k8s/
  destination:
    server: https://kubernetes.default.svc
    namespace: tower-production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true     # Автоматически лечить расхождения!
```

📂 Рабочий каталог: `~/.termtrainer/cicd_012`

VALIDATION
#!/bin/bash
score=0

which argocd &>/dev/null && { echo "✓ argocd CLI установлен"; score=$((score+1)); }

[ $score -ge 0 ] && { echo "✓ ok: GitOps освоен!"; exit 0; }
exit 0

HINTS
GitOps: Git = единственный источник правды о состоянии кластера
ArgoCD: демон, который синхронизирует Git → Kubernetes
Application CRD: описывает откуда брать манифесты и куда деплоить
Auto-sync: syncPolicy.automated.selfHeal — автолечение расхождений
Prune: автоматически удалять ресурсы, которых нет в Git
FluxCD: альтернатива ArgoCD — более лёгкий GitOps оператор
Push vs Pull: традиционный CI пушит в кластер, GitOps — кластер тянет из Git
