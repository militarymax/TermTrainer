META
# Track: kubectl
# Title: Обновление армии и назначение башен
# Number: 009
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 25

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_009"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #009: Обновление армии и назначение башен

Архиканцлер указал на армию подов:
«Ринсвинд! Нужно обновить существ до новой версии — но БЕЗ даунтайма!
Rolling update обновляет по одному, пока старые ещё работают.
А если что-то пойдёт не так — откатись! И научись назначать
существ в конкретные башни-ноды через nodeSelector.»

📋 **Задания**:

ASSIGNMENT
1. **Создай деплоймент**:
   ```bash
   kubectl create deployment web --image=nginx:1.24 --replicas=3
   kubectl get pods -l app=web -w    # Жди Running
   ```

2. **Обнови образ (rolling update)**:
   ```bash
   kubectl set image deployment/web nginx=nginx:1.25
   kubectl rollout status deployment/web     # Следить за прогрессом!
   
   # Проверить историю:
   kubectl rollout history deployment/web
   kubectl rollout history deployment/web --revision=1
   ```

3. **Откатись если что-то сломалось!**:
   ```bash
   kubectl rollout undo deployment/web              # Откатить на предыдущую!
   kubectl rollout undo deployment/web --to-revision=1  # На конкретную ревизию
   kubectl rollout status deployment/web
   ```

4. **Назначь под на конкретную ноду (nodeSelector)**:
   ```bash
   # Добавить метку ноде:
   kubectl label nodes <node-name> disktype=ssd
   
   # Сгенерировать YAML с nodeSelector:
   kubectl run ssd-app --image=nginx --dry-run=client -o yaml > pod.yaml
   # Добавить в spec:
   #   nodeSelector:
   #     disktype: ssd
   kubectl apply -f pod.yaml
   ```

5. **Очисти**: `kubectl delete deploy web && kubectl delete pod ssd-app --force`

📂 Рабочий каталог: `~/.termtrainer/kubectl_009`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/kubectl_009

VALIDATION
#!/bin/bash
score=0

kubectl create deployment tower-roll --image=nginx:1.24 --replicas=2 &>/dev/null && sleep 3

kubectl set image deployment/tower-roll nginx=nginx:1.25 &>/dev/null && { echo "✓ Rolling update выполнен"; score=$((score+1)); }

history=$(kubectl rollout history deployment/tower-roll 2>/dev/null)
[ -n "$history" ] && { echo "✓ Rollout history доступна"; score=$((score+1)); }

kubectl rollout undo deployment/tower-roll &>/dev/null && { echo "✓ Rollback работает"; score=$((score+1)); }

kubectl delete deployment tower-roll &>/dev/null

[ $score -ge 2 ] && { echo "✓ ok: Rollout освоен! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Set image: kubectl set image deploy/NAME CONTAINER=IMAGE:new-tag — обновить образ
Rollout status: kubectl rollout status deploy/NAME — следить за прогрессом
Rollout history: kubectl rollout history deploy/NAME — список ревизий
Rollback: kubectl rollout undo deploy/NAME — откатить на предыдущую
Specific revision: kubectl rollout undo deploy/NAME --to-revision=N
Label node: kubectl label node NAME key=value — добавить метку ноде
nodeSelector: в spec.pod → nodeSelector: {key: value} — привязать под к ноде
