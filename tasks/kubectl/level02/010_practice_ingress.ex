META
# Track: kubectl
# Title: Врата Башни и стража коридоров
# Number: 010
# Level: 2
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_010"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #010: Врата Башни и стража коридоров

Архиканцлер указал на главные врата:
«Ринсвинд! Service — это внутренний портал. Но как попасть СНАРУЖИ?
Ingress — это Главные Врата Башни! Они направляют посетителей
по имени хоста и пути. А NetworkPolicy — это стража коридоров,
которая решает, кто может общаться с кем. Без стражи — все со всеми!»

📋 **Задания**:

ASSIGNMENT
1. **Создай два деплоймента**:
   ```bash
   kubectl create deployment api --image=nginx --replicas=2
   kubectl create deployment web --image=httpd --replicas=2
   
   kubectl expose deployment api --port=80 --type=ClusterIP
   kubectl expose deployment web --port=80 --type=ClusterIP
   ```

2. **Создай Ingress (Главные Врата)**:
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: tower-gate
   spec:
     rules:
     - host: tower.unseen.edu
       http:
         paths:
         - path: /api
           pathType: Prefix
           backend:
             service:
               name: api
               port:
                 number: 80
         - path: /
           pathType: Prefix
           backend:
             service:
               name: web
               port:
                 number: 80
   EOF
   
   kubectl get ingress
   ```

3. **NetworkPolicy — Deny All** (закрыть все коридоры):
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: deny-all
   spec:
     podSelector: {}    # Все поды!
     policyTypes:
     - Ingress           # Запретить входящий
     - Egress            # Запретить исходящий
   EOF
   ```

4. **NetworkPolicy — Allow Specific** (открыть только нужное):
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-api-to-web
   spec:
     podSelector:
       matchLabels:
         app: web        # К кому применяется
     policyTypes:
     - Ingress
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: api   # От кого разрешено
       ports:
       - port: 80
   EOF
   ```

5. **Очисти**: `kubectl delete deploy api web && kubectl delete svc api web && kubectl delete ingress tower-gate && kubectl delete networkpolicy deny-all allow-api-to-web`

📂 Рабочий каталог: `~/.termtrainer/kubectl_010`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/kubectl_010

VALIDATION
#!/bin/bash
score=0

kubectl create deployment tower-api --image=nginx &>/dev/null && sleep 3
kubectl expose deployment tower-api --port=80 &>/dev/null && { echo "✓ Deployment+Service созданы"; score=$((score+1)); }

cat <<YAML | kubectl apply -f - &>/dev/null
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tower-ingress
spec:
  rules:
  - host: test.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: tower-api
            port:
              number: 80
YAML

ing=$(kubectl get ingress tower-ingress -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
[ "$ing" = "test.local" ] && { echo "✓ Ingress создан"; score=$((score+1)); }

kubectl delete deploy tower-api &>/dev/null; kubectl delete svc tower-api &>/dev/null; kubectl delete ingress tower-ingress &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Ingress освоен! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики"
exit 1

HINTS
Ingress: маршрутизация по host/path к сервисам внутри кластера
Ingress path: /api → api-svc, / → web-svc — разные пути к разным сервисам
NetworkPolicy deny-all: закрыть весь трафик (podSelector: {}, policyTypes: Ingress+Egress)
NetworkPolicy allow: открыть только конкретный трафик (from.podSelector + ports)
CNI required: NetworkPolicy работает ТОЛЬКО если CNI-плагин поддерживает их!
Ingress controller: нужен ingress-controller (nginx/traefik) для работы Ingress
Host routing: разные домены → разные сервисы через один IP
