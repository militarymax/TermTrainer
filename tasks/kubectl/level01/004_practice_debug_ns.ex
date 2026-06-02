META
# Track: kubectl
# Title: Бешеные существа и пространства
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #004: Бешеные существа и пространства

Архиканцлер указал на под, который мигал красным:
«Ринсвинд! Это CrashLoopBackOff — существо падает и возрождается,
падает и возрождается... бесконечно! Нужно понять ПОЧЕМУ.
И ещё — в кластере есть ПРОСТРАНСТВА (namespaces).
Каждый факультет живёт в своём. Не перепутай!»

📋 **Задания**:

ASSIGNMENT
1. **Создай пространство факультета**:
   ```bash
   kubectl create ns tower-alchemy
   kubectl get ns
   ```

2. **Призови существо в пространстве**:
   ```bash
   kubectl run web -n tower-alchemy --image=nginx
   kubectl get pods -n tower-alchemy
   ```

3. **Переключи контекст по умолчанию**:
   ```bash
   # Чтобы не писать -n каждый раз!
   kubectl config set-context --current --namespace=tower-alchemy
   kubectl get pods    # Теперь по умолчанию tower-alchemy!
   
   # Вернуть обратно:
   kubectl config set-context --current --namespace=default
   ```

4. **Вызови CrashLoopBackOff** (намеренно!):
   ```bash
   # Под с несуществующей командой → упадёт!
   kubectl run crasher --image=busybox --command -- sh -c "echo 'FAIL!' && exit 1"
   
   # Наблюдай за циклом:
   kubectl get pods -w    # CrashLoopBackOff → Running → CrashLoopBackOff...
   ```

5. **Расследуй причину**:
   ```bash
   kubectl describe pod crasher | tail -10     # Events → Back-off
   kubectl logs crasher                        # Последний лог перед крашем
   kubectl logs crasher --previous             # Лог ПРЕДЫДУЩЕГО запуска!
   ```

6. **Очисти**: `kubectl delete pod crasher --force && kubectl delete ns tower-alchemy`

📂 Рабочий каталог: `~/.termtrainer/kubectl_004`

VALIDATION
#!/bin/bash
score=0

kubectl create ns tower-test-ns &>/dev/null || true
kubectl run tower-crash -n tower-test-ns --image=busybox --command -- sh -c "exit 1" &>/dev/null
sleep 8

status=$(kubectl get pod tower-crash -n tower-test-ns -o jsonpath='{.status.containerStatuses[0].state}' 2>/dev/null)
[ -n "$status" ] && { echo "✓ Pod создан и отслеживается"; score=$((score+1)); }

prev=$(kubectl logs tower-crash -n tower-test-ns --previous 2>&1)
[ -n "$prev" ] && { echo "✓ --previous работает"; score=$((score+1)); }

kubectl delete pod tower-crash -n tower-test-ns --force &>/dev/null
kubectl delete ns tower-test-ns &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Дебаг и неймспейсы освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Create NS: kubectl create ns NAME — создать пространство имён
Pod in NS: kubectl run NAME -n NAMESPACE — под в конкретном NS
Set default NS: kubectl config set-context --current --namespace=NAME
Get all NS: kubectl get ns — список всех пространств
CrashLoopBackOff: pod падает → перезапускается → падает снова
Describe events: kubectl describe pod NAME | tail -15 — последние события
Logs previous: kubectl logs NAME --previous — лог ДО перезапуска!
ImagePullBackOff: опечатка в имени образа → не может скачать
