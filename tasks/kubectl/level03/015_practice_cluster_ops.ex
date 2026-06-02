META
# Track: kubectl
# Title: Ритуал обновления Башни
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 30
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #015: Ритуал обновления Башни

Архиканцлер вызвал тебя в серверную:
«Ринсвинд! Кластер нужно обновить. Это как перестраивать Башню,
пока в ней живут маги — осторожно, по одной комнате за раз!
kubeadm upgrade — это ритуал обновления. Сначала control-plane,
потом worker-ноды. И НЕ ЗАБУДЬ про etcd backup перед этим!»

📋 **Задания**:

ASSIGNMENT
1. **Подготовка — etcd backup!** (на control-plane):
   ```bash
   ETCDCTL_API=3 etcdctl snapshot save /tmp/pre-upgrade.db \
     --endpoints=https://127.0.0.1:2379 \
     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt \
     --key=/etc/kubernetes/pki/etcd/server.key
   
   # Проверить:
   ETCDCTL_API=3 etcdctl snapshot status /tmp/pre-upgrade.db --write-table
   ```

2. **Обновление control-plane** (на control-plane ноде):
   ```bash
   # Шаг 1: Обновить kubeadm
   apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.XX.X-00 && apt-mark hold kubeadm
   
   # Шаг 2: Проверить план
   kubeadm upgrade plan
   
   # Шаг 3: Применить!
   kubeadm upgrade apply v1.XX.X
   
   # Шаг 4: Обновить kubelet и kubectl
   apt-mark unhold kubelet kubectl && apt-get install -y kubelet=1.XX.X-00 kubectl=1.XX.X-00 && apt-mark hold kubelet kubectl
   systemctl restart kubelet
   ```

3. **Обновление worker-нод** (по одной!):
   ```bash
   # На control-plane: сначала выселить поды с ноды
   kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
   
   # На worker-ноде: обновить пакеты
   apt-mark unhold kubeadm kubelet kubectl
   apt-get update && apt-get install -y kubeadm=1.XX.X-00 kubelet=1.XX.X-00 kubectl=1.XX.X-00
   apt-mark hold kubeadm kubelet kubectl
   
   kubeadm upgrade node
   systemctl restart kubelet
   
   # Вернуть ноду в строй:
   kubectl uncordon <node>
   ```

4. **Напиши чеклист обновления** `$DIR/upgrade_checklist.md`:
   ```markdown
   # Cluster Upgrade Checklist
   
   ## Pre-flight
   - [ ] etcd backup completed
   - [ ] kubeadm upgrade plan checked
   - [ ] Version compatibility verified
   
   ## Control Plane
   - [ ] Upgrade kubeadm on CP node
   - [ ] kubeadm upgrade apply
   - [ ] Upgrade kubelet + kubectl on CP
   - [ ] Verify CP pods running
   
   ## Worker Nodes (one by one)
   - [ ] kubectl drain worker-N
   - [ ] Upgrade kubeadm/kubelet/kubectl
   - [ ] kubeadm upgrade node
   - [ ] kubectl uncordon worker-N
   - [ ] Verify pods rescheduled
   
   ## Post-upgrade
   - [ ] All nodes Ready
   - [ ] All system pods running
   - [ ] Applications healthy
   ```

📂 Рабочий каталог: `~/.termtrainer/kubectl_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/kubectl_015"
score=0

version=$(kubectl version --short 2>/dev/null || kubectl version 2>/dev/null | head -5)
[ -n "$version" ] && { echo "✓ kubectl version работает"; score=$((score+1)); }

if [ -f "$DIR/upgrade_checklist.md" ]; then
  grep -q "etcd\|drain\|uncordon\|upgrade" "$DIR/upgrade_checklist.md" && { echo "✓ Чеклист создан"; score=$((score+1)); }
fi

[ $score -ge 1 ] && { echo "✓ ok: Обновление кластера освоено! (баллов: $score/2)"; exit 0; }
echo "✗ Создай upgrade_checklist.md (баллов: $score/2)"
exit 1

HINTS
Etcd backup: ETCDCTL_API=3 etcdctl snapshot save — ОБЯЗАТЕЛЬНО перед обновлением!
Upgrade plan: kubeadm upgrade plan — проверить доступные версии
Upgrade apply: kubeadm upgrade apply vX.YY.Z — обновить control-plane
Drain node: kubectl drain NODE --ignore-daemonsets --delete-emptydir-data — выселить поды
Uncordon: kubectl uncordon NODE — вернуть ноду в строй после обновления
Worker upgrade: kubeadm upgrade node — на каждой worker-ноде
Order: CP first → workers one by one → verify all running
