META
# Track: kubectl
# Title: Первые призывы
# Number: 003
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 20
# XP: 15

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_003"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #003: Первые призывы

Архиканцлер поставил перед тобой Командный Кристалл:
«Ринсвинд! Призови три разных существа, проверь их состояние,
прочитай записи и проникни внутрь. Если хоть одно сбежит —
будешь ловить его по всему кластеру. Как в прошлый раз.
Тогда мы нашли его только на 42-й ноде.»

📋 **Задания**:

ASSIGNMENT
1. **Призови nginx-под**:
   ```bash
   kubectl run web --image=nginx
   kubectl get pods -w    # Жди пока станет Running (Ctrl+C)
   ```

2. **Призови busybox-под** (с командой):
   ```bash
   kubectl run box --image=busybox --command -- sh -c "echo 'Hello from the Tower!' && sleep 3600"
   ```

3. **Призови под с меткой**:
   ```bash
   kubectl run api --image=nginx --labels="app=tower,tier=api"
   ```

4. **Проверь всех**:
   ```bash
   kubectl get pods -o wide              # С IP и нодой
   kubectl describe pod web | grep -A5 "Events"   # События!
   kubectl logs web                      # Записи nginx
   kubectl logs box                      # Наше сообщение!
   ```

5. **Проникни внутрь**:
   ```bash
   kubectl exec -it web -- /bin/sh      # Внутри nginx
   # Попробуй: cat /etc/hostname, ls /usr/share/nginx/html
   # exit для возврата
   ```

6. **Очисти всё**: `kubectl delete pod web box api --force`

📂 Рабочий каталог: `~/.termtrainer/kubectl_003`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/kubectl_003

VALIDATION
#!/bin/bash
score=0

kubectl run tower-web --image=nginx &>/dev/null && sleep 5
kubectl get pod tower-web &>/dev/null && { echo "✓ Pod создан"; score=$((score+1)); }

logs=$(kubectl logs tower-web 2>/dev/null | head -1)
[ -n "$logs" ] && { echo "✓ Logs прочитаны"; score=$((score+1)); }

kubectl delete pod tower-web --force &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Призыв существ освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Run pod: kubectl run NAME --image=IMAGE — создать под
Run with command: kubectl run NAME --image=IMG --command -- sh -c "CMD"
Labels: kubectl run NAME --image=IMG --labels="key=val,key2=val2"
Get wide: kubectl get pods -o wide — IP и нода каждого пода
Describe events: kubectl describe pod NAME | grep -A10 Events — что произошло
Logs: kubectl logs NAME — прочитать stdout/stderr контейнера
Exec: kubectl exec -it NAME -- /bin/sh — войти в контейнер
Delete all: kubectl delete pod NAME1 NAME2 --force — удалить несколько
