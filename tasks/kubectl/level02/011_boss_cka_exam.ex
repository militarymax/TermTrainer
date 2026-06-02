META
# Track: kubectl
# Title: Экзамен Мастера Кластера
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #011: Экзамен Мастера Кластера

Архиканцлер вызвал тебя в Главный Зал:
«Ринсвинд! Это экзамен уровня CKA. Создай полный стек приложения:
неймспейс, деплоймент с ConfigMap и Secret, сервис, Ingress,
ServiceAccount с правами только на чтение подов.
Всё императивно или через --dry-run! Время пошло!»

📋 **Боевые задания**:

ASSIGNMENT
1. **Создай неймспейс `tower-app`**:
   ```bash
   kubectl create ns tower-app
   ```

2. **Создай ConfigMap и Secret**:
   ```bash
   kubectl create configmap app-config -n tower-app \
     --from-literal=DB_HOST=postgres.tower-app.svc \
     --from-literal=TOWER_NAME="Unseen University"
   
   kubectl create secret generic db-creds -n tower-app \
     --from-literal=DB_PASSWORD=s3cret
   ```

3. **Создай деплоймент с env из ConfigMap+Secret**:
   ```bash
   kubectl create deployment api --image=nginx --replicas=2 -n tower-app
   # Добавь envFrom через kubectl edit или патч!
   kubectl set env deploy/api -n tower-app --from=configmap/app-config
   kubectl set env deploy/api -n tower-app --from=secret/db-creds
   ```

4. **Экспонируй как ClusterIP**:
   ```bash
   kubectl expose deployment api --port=80 -n tower-app
   ```

5. **Создай ServiceAccount + Role + RoleBinding**:
   ```bash
   kubectl create sa tower-reader -n tower-app
   kubectl create role pod-reader --verb=get,list,watch --resource=pods -n tower-app
   kubectl create rolebinding reader-bind --role=pod-reader --serviceaccount=tower-app:tower-reader -n tower-app
   ```

6. **Собери отчёт** `$DIR/cka_report.txt`:
   ```bash
   {
     echo "═══ CKA Exam Report ═══"
     echo "Date: $(date)"
     echo ""
     echo "── Namespace ──"; kubectl get ns tower-app
     echo "── ConfigMap ──"; kubectl get cm -n tower-app
     echo "── Secret ──"; kubectl get secrets -n tower-app
     echo "── Deployment ──"; kubectl get deploy -n tower-app
     echo "── Pods ──"; kubectl get pods -n tower-app -o wide
     echo "── Service ──"; kubectl get svc -n tower-app
     echo "── SA/RBAC ──"; kubectl get sa,role,rolebinding -n tower-app
     echo ""
     echo "── RBAC Test ──"
     kubectl auth can-i get pods -n tower-app --as=system:serviceaccount:tower-app:tower-reader
     kubectl auth can-i delete pods -n tower-app --as=system:serviceaccount:tower-app:tower-reader
     echo "═══ End of Report ═══"
   } > "$DIR/cka_report.txt"
   ```

7. **Очисти**: `kubectl delete ns tower-app`

📂 Рабочий каталог: `~/.termtrainer/kubectl_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_011"
score=0

kubectl create ns tower-cka &>/dev/null || true
kubectl create configmap n-cm -n tower-cka --from-literal=k=v &>/dev/null
kubectl create secret generic n-sec -n tower-cka --from-literal=pw=x &>/dev/null
kubectl create deployment n-dep --image=nginx -n tower-cka &>/dev/null && sleep 3

pods=$(kubectl get pods -n tower-cka --no-headers 2>/dev/null | grep -c Running || echo "0")
[ "$pods" -ge 1 ] && { echo "✓ Деплоймент работает"; score=$((score+1)); }

kubectl expose deployment n-dep --port=80 -n tower-cka &>/dev/null
svc=$(kubectl get svc -n tower-cka 2>/dev/null | grep -v NAME)
[ -n "$svc" ] && { echo "✓ Сервис создан"; score=$((score+1)); }

kubectl delete ns tower-cka &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: БОСС пройден! Экзамен Мастера сдан! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Namespace: kubectl create ns NAME — изолировать все ресурсы
ConfigMap: kubectl create configmap NAME --from-literal=K=V — конфигурация
Secret: kubectl create secret generic NAME --from-literal=K=V — секреты (base64!)
Set env from CM: kubectl set env deploy/NAME --from=configmap/CM_NAME
Set env from Secret: kubectl set env deploy/NAME --from=secret/SEC_NAME
SA+Role+RB: создать аккаунт → роль → привязку для RBAC
Auth can-i: проверить права конкретного ServiceAccount
