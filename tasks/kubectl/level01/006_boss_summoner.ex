META
# Track: kubectl
# Title: Экзамен Призывателя
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
🐉 БОСС #006: Экзамен Призывателя

Архиканцлер встал во весь рост:
«Ринсвинд! ФИНАЛЬНЫЙ экзамен первого уровня!
Создай неймспейс, разверни деплоймент, экспонируй сервис,
проверь связность и собери отчёт. Всё императивными командами!
Без YAML-файлов! Как на экзамене CKA — время ограничено!»

📋 **Боевые задания**:

1. **Создай пространство `tower-production`**:
   ```bash
   kubectl create ns tower-production
   kubectl config set-context --current --namespace=tower-production
   ```

2. **Разверни деплоймент**:
   ```bash
   kubectl create deployment api-server --image=nginx --replicas=3
   kubectl get pods -w    # Жди пока все станут Running
   ```

3. **Экспонируй как NodePort**:
   ```bash
   kubectl expose deployment api-server --port=80 --type=NodePort --name=api-server-np
   kubectl get svc api-server-np
   ```

4. **Масштабируй до 5 реплик**:
   ```bash
   kubectl scale deployment api-server --replicas=5
   kubectl get pods -l app=api-server
   ```

5. **Собери отчёт** `$DIR/boss_report.txt`:
   ```bash
   {
     echo "═══ Summoner Exam Report ═══"
     echo "Date: $(date)"
     echo ""
     echo "── Namespace ──"
     kubectl get ns tower-production
     echo ""
     echo "── Deployment ──"
     kubectl get deploy api-server -o wide
     echo ""
     echo "── Pods ──"
     kubectl get pods -l app=api-server -o wide
     echo ""
     echo "── Service ──"
     kubectl get svc api-server-np
     echo ""
     echo "── Endpoints ──"
     kubectl get endpoints api-server-np
     echo ""
     echo "═══ End of Report ═══"
   } > "$DIR/boss_report.txt"
   cat "$DIR/boss_report.txt"
   ```

6. **Очисти**: 
   ```bash
   kubectl delete deploy api-server
   kubectl delete svc api-server-np
   kubectl config set-context --current --namespace=default
   kubectl delete ns tower-production
   ```

📂 Рабочий каталог: `~/.termtrainer/kubectl_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_006"
score=0

kubectl create ns tower-boss &>/dev/null || true
kubectl create deployment tower-boss-dep --image=nginx --replicas=2 -n tower-boss &>/dev/null && sleep 5

pods=$(kubectl get pods -n tower-boss --no-headers 2>/dev/null | grep -c Running || echo "0")
[ "$pods" -ge 1 ] && { echo "✓ Деплоймент работает"; score=$((score+1)); }

kubectl expose deployment tower-boss-dep --port=80 --type=NodePort -n tower-boss &>/dev/null
svc=$(kubectl get svc -n tower-boss 2>/dev/null | grep -v NAME)
[ -n "$svc" ] && { echo "✓ Сервис создан"; score=$((score+1)); }

if [ -f "$DIR/boss_report.txt" ]; then
  grep -q "Report\|Namespace\|Deployment\|Pods\|Service" "$DIR/boss_report.txt" && { echo "✓ Отчёт создан"; score=$((score+1)); }
fi

kubectl delete deploy tower-boss-dep -n tower-boss &>/dev/null
kubectl delete svc tower-boss-dep -n tower-boss &>/dev/null
kubectl delete ns tower-boss &>/dev/null

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Экзамен Призывателя сдан! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Create NS: kubectl create ns NAME — создать пространство
Set default NS: kubectl config set-context --current --namespace=NAME
Create deploy: kubectl create deployment NAME --image=IMG --replicas=N
Expose NodePort: kubectl expose deploy NAME --port=80 --type=NodePort
Scale: kubectl scale deployment NAME --replicas=N
Get endpoints: kubectl get endpoints SVC_NAME — куда идёт трафик
Report: собрать все данные в один файл через перенаправление >
Cleanup: удалить все ресурсы и неймспейс после экзамена
