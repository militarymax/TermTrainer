META
# Track: cicd
# Title: Шаблоны заклинаний: Helm и Kustomize
# Number: 013
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 35

SETUP
#!/bin/bash
DIR="$HOME/.ninja_trainer/cicd_013"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #013: Шаблоны заклинаний — Helm и Kustomize

Архиканцлер показал два подхода к шаблонизации:
«Ринсвинд! Helm — это как книга заклинаний с параметрами:
один шаблон, разные значения для staging/production.
Kustomize — это накладывание патчей на существующие заклинания.
Оба подхода используются в CI для генерации манифестов!»

📋 **Задания**:

1. **Создай структуру Helm chart**:
   ```bash
   mkdir -p tower-chart/templates
   ```
   
   `tower-chart/Chart.yaml`:
   ```yaml
   apiVersion: v2
   name: tower-app
   version: 1.0.0
   description: Tower Application Spell
   ```
   
   `tower-chart/values.yaml`:
   ```yaml
   replicaCount: 2
   image:
     repository: ghcr.io/org/tower-app
     tag: latest
   service:
     type: ClusterIP
     port: 80
   resources:
     requests:
       cpu: 100m
       memory: 128Mi
   ```

2. **Создай Kustomize overlay**:
   ```bash
   mkdir -p k8s/base k8s/overlays/staging k8s/overlays/production
   ```
   
   `k8s/base/kustomization.yaml`:
   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization
   resources:
   - deployment.yaml
   - service.yaml
   ```
   
   `k8s/overlays/staging/kustomization.yaml`:
   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization
   bases:
   - ../../base
   patchesStrategicMerge:
   - patch-replicas.yaml
   ```
   
   `k8s/overlays/production/kustomization.yaml`:
   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization
   bases:
   - ../../base
   patchesStrategicMerge:
   - patch-replicas.yaml
   - patch-resources.yaml
   ```

3. **Проверь**: 
   ```bash
   helm template tower-chart/ | head -30
   kubectl kustomize k8s/overlays/staging/ | head -20
   ```

📂 Рабочий каталог: `~/.ninja_trainer/cicd_013`

VALIDATION
#!/bin/bash
DIR="$HOME/.ninja_trainer/cicd_013"
score=0

[ -f "$DIR/tower-chart/Chart.yaml" ] && { echo "✓ Helm Chart создан"; score=$((score+1)); }
[ -f "$DIR/tower-chart/values.yaml" ] && { echo "✓ values.yaml создан"; score=$((score+1)); }
[ -f "$DIR/k8s/base/kustomization.yaml" ] && { echo "✓ Kustomize base создан"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Helm и Kustomize освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Создай Helm chart и Kustomize overlays (баллов: $score/3)"
exit 1

HINTS
Helm chart: Chart.yaml + values.yaml + templates/ — параметризованные манифесты
Helm template: helm template CHART/ — рендерить YAML без деплоя
Kustomize base: общие ресурсы (deployment.yaml, service.yaml)
Kustomize overlays: патчи для разных сред (staging/production)
Patches: patchesStrategicMerge — изменить replicas/resources для среды
CI integration: helm template | kubectl apply -f - или kubectl kustomize | kubectl apply -f -
