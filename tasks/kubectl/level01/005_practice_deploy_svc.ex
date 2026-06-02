META
# Track: kubectl
# Title: Армия существ и порталы
# Number: 005
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_005"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #005: Армия существ и порталы

Архиканцлер указал на одинокий под:
«Ринсвинд! Один под — это один маг. А что если он упадёт?
Нужна АРМИЯ — Deployment! Он поддерживает нужное количество
существ. И ПОРТАЛ — Service — чтобы другие могли найти армию.
Без сервиса существо невидимо для остальных!»

📋 **Задания**:

1. **Создай Deployment (армию)**:
   ```bash
   kubectl create deployment web-army --image=nginx --replicas=3
   kubectl get deployments
   kubectl get pods -l app=web-army    # Фильтр по метке!
   ```

2. **Масштабируй**:
   ```bash
   kubectl scale deployment web-army --replicas=5
   kubectl get pods -w    # Новые поды появляются!
   
   kubectl scale deployment web-army --replicas=2
   # Лишние поды исчезают!
   ```

3. **Создай Service (портал)**:
   ```bash
   # ClusterIP — доступен только внутри кластера
   kubectl expose deployment web-army --port=80 --type=ClusterIP
   
   # NodePort — доступен снаружи!
   kubectl expose deployment web-army --port=80 --type=NodePort --name=web-army-ext
   
   kubectl get svc
   kubectl describe svc web-army | grep -E "Endpoints|Port"
   ```

4. **Проверь связность**:
   ```bash
   # Запусти временный под для проверки
   kubectl run tmp --image=busybox --rm -it --restart=Never -- wget -qO- web-army:80
   # Должен вернуть HTML nginx!
   ```

5. **Сохрани YAML деплоймента**:
   ```bash
   kubectl get deployment web-army -o yaml > $DIR/deploy.yaml
   ```

6. **Очисти**: `kubectl delete deployment web-army && kubectl delete svc web-army web-army-ext`

📂 Рабочий каталог: `~/.termtrainer/kubectl_005`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_005"
score=0

kubectl create deployment tower-deploy --image=nginx --replicas=2 &>/dev/null && sleep 3

pods=$(kubectl get pods -l app=tower-deploy --no-headers 2>/dev/null | grep -c Running || echo "0")
[ "$pods" -ge 1 ] && { echo "✓ Deployment работает ($pods pods)"; score=$((score+1)); }

kubectl expose deployment tower-deploy --port=80 --type=ClusterIP &>/dev/null
svc=$(kubectl get svc tower-deploy -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
[ -n "$svc" ] && { echo "✓ Service создан: $svc"; score=$((score+1)); }

kubectl delete deployment tower-deploy &>/dev/null; kubectl delete svc tower-deploy &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Deployments и Services освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Create deploy: kubectl create deployment NAME --image=IMG --replicas=N
Scale: kubectl scale deployment NAME --replicas=N — изменить количество подов
Labels filter: kubectl get pods -l app=NAME — фильтр по меткам
Expose ClusterIP: kubectl expose deploy NAME --port=80 — сервис внутри кластера
Expose NodePort: kubectl expose deploy NAME --port=80 --type=NodePort — доступен снаружи
Get svc: kubectl get svc — список сервисов и их IP/порты
Describe endpoints: kubectl describe svc NAME | grep Endpoints — куда идёт трафик
Test connectivity: kubectl run tmp --rm -it -- wget -qO- SVC:PORT
