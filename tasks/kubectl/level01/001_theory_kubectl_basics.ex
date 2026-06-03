META
# Track: kubectl
# Title: Призыв существ
# Number: 001
# Level: 1
# Type: theory
# Difficulty: easy
# TimeLimitMin: 15
# XP: 10

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_001"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
📜 СВИТОК ЗНАНИЙ #001: Призыв существ

Архиканцлер подвёл тебя к массивному кристаллу в центре Башни:
«Ринсвинд! Это — Командный Кристалл Кластера. Через него мы управляем
всеми призванными существами — подами. Каждый под — это магическое
существо, живущее в своей башне-ноде. Научись призывать, проверять
и отпускать их. Иначе они разбегутся по всему Плоскому миру.
Как в прошлый раз. Когда ты случайно призвал 42 демона.»

───────────────────────────────────────
🔹 KUBECTL — КОМАНДНЫЙ КРИСТАЛЛ
───────────────────────────────────────

```bash
# Алиас для скорости (ОБЯЗАТЕЛЬНО на экзамене!)
alias k=kubectl
source <(kubectl completion bash)        # Автодополнение!
complete -o default -F __start_kubectl k # Для алиаса тоже

# Базовые команды обзора
kubectl get nodes                        # Башни кластера
kubectl get pods -A                      # ВСЕ поды во ВСЕХ пространствах
kubectl get pods -o wide                 # С IP и нодой
kubectl get all                          # Все ресурсы в текущем NS
```

───────────────────────────────────────
🔹 ПРИЗЫВАЕМ ПЕРВОЕ СУЩЕСТВО
───────────────────────────────────────

```bash
# Призвать под одной командой!
kubectl run nginx --image=nginx          # Под с nginx

# Наблюдать за появлением
kubectl get pods -w                      # Watch mode!

# Описать существо — полная информация
kubectl describe pod nginx               # События, IP, нода, состояние...

# Прочитать записи существа
kubectl logs nginx                       # stdout/stderr
kubectl logs nginx -f                    # Следить в реальном времени

# Проникнуть внутрь существа!
kubectl exec -it nginx -- /bin/sh        # Открыть оболочку внутри

# Отпустить существо
kubectl delete pod nginx                 # Уничтожить под
```

⚠️ `kubectl run` создаёт ПОД, не деплоймент! Для деплоймента → `kubectl create deployment`

───────────────────────────────────────
🔹 ПОНИМАНИЕ СОСТОЯНИЙ ПОДА
───────────────────────────────────────

• `Running` ✅ — работает нормально
• `Pending` ⏳ — ждёт ресурсов (нет места на нодах?)
• `ContainerCreating` 🔧 — скачивает образ...
• `CrashLoopBackOff` 💀 — падает и перезапускается! Смотри логи!
• `ImagePullBackOff` ❌ — не может скачать образ (опечатка? приватный?)

📂 Рабочий каталог: `~/.termtrainer/kubectl_001`

ASSIGNMENT

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/kubectl_001
📋 **Попробуй**:
1. `kubectl get nodes`
2. `kubectl run hello --image=nginx && kubectl get pods -w` (Ctrl+C через 10 сек)
3. `kubectl describe pod hello`

VALIDATION
#!/bin/bash
score=0

nodes=$(kubectl get nodes 2>/dev/null | grep -c "Ready\|control-plane\|worker" || echo "0")
[ "$nodes" -ge 1 ] && { echo "✓ Кластер доступен ($nodes нод)"; score=$((score+1)); }

kubectl run tower-test --image=nginx &>/dev/null && sleep 3
kubectl get pod tower-test &>/dev/null && { echo "✓ Pod создан"; score=$((score+1)); }
kubectl delete pod tower-test --force &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Основы kubectl освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Убедитесь что kubectl подключён к кластеру"
exit 1

HINTS
Alias: alias k=kubectl — экономит время на экзамене!
Autocomplete: source <(kubectl completion bash) — автодополнение команд
Get pods: kubectl get pods -A — все поды во всех неймспейсах
Describe: kubectl describe pod NAME — события, состояние, IP
Logs: kubectl logs NAME -f — следить за логами в реальном времени
Exec: kubectl exec -it NAME -- /bin/sh — войти в контейнер
Run: kubectl run NAME --image=IMAGE — создать под одной командой
States: Running/Pending/CrashLoopBackOff/ImagePullBackOff — основные состояния
