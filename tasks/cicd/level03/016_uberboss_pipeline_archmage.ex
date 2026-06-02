META
# Track: cicd
# Title: Архимаг Конвейера
# Number: 016
# Level: 3
# Type: uberboss
# Difficulty: expert
# TimeLimitMin: 45
# XP: 100

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_016"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
👑 UBERBOSS #016: Архимаг Конвейера

Архиканцлер стоял на вершине Башни, ветер развевал его мантию:
«Ринсвинд. Это ФИНАЛЬНЫЙ экзамен. Создай полный production-ready
CI/CD конвейер с нуля: Dockerfile, multi-stage build, GitHub Actions
с matrix-тестами, security scanning, Helm chart, Kustomize overlays,
deploy script с canary, и скрипт мониторинга.
Если справишься — ты Архимаг Конвейера.
Если нет... знаешь того кактуса?»

📋 **БЛОК 1 — Приложение**:

`Dockerfile` (multi-stage):
```dockerfile
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o tower-app .

FROM alpine:3.19
RUN adduser -D appuser
COPY --from=builder /app/tower-app /tower-app
USER appuser
HEALTHCHECK CMD wget -qO- http://localhost:8080/health || exit 1
CMD ["/tower-app"]
```

📋 **БЛОК 2 — Полный Pipeline**:

ASSIGNMENT
`.github/workflows/full-pipeline.yml`:
- Matrix test (Go 1.21 + 1.22)
- Cache Go modules
- Build + upload artifact
- Docker build + push to GHCR
- Trivy security scan
- Deploy staging (auto)
- Deploy production (manual approval)

📋 **БЛОК 3 — Helm Chart**:

Создай `tower-chart/` с:
- `Chart.yaml`, `values.yaml`, `templates/deployment.yaml`, `templates/service.yaml`

📋 **БЛОК 4 — Deploy Script**:

Напиши `$DIR/deploy.sh` с поддержкой dev/staging/production + canary

📋 **БЛОК 5 — Monitor Script**:

Напиши `$DIR/pipeline_monitor.sh` для аудита конвейера

📂 Рабочий каталог: `~/.termtrainer/cicd_016`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_016"
score=0
max=5

[ -f "$DIR/Dockerfile" ] && grep -q "AS builder\|COPY --from" "$DIR/Dockerfile" && { echo "✓ Multi-stage Dockerfile"; score=$((score+1)); }

[ -f "$DIR/.github/workflows/full-pipeline.yml" ] && grep -q "matrix\|cache\|artifact\|trivy\|staging\|production" "$DIR/.github/workflows/full-pipeline.yml" && { echo "✓ Full pipeline создан"; score=$((score+1)); }

[ -f "$DIR/tower-chart/Chart.yaml" ] && { echo "✓ Helm Chart создан"; score=$((score+1)); }

[ -f "$DIR/deploy.sh" ] && grep -q "staging\|production\|canary" "$DIR/deploy.sh" && { echo "✓ deploy.sh создан"; score=$((score+1)); }

[ -f "$DIR/pipeline_monitor.sh" ] && grep -q "gh\|docker\|git" "$DIR/pipeline_monitor.sh" && { echo "✓ monitor script создан"; score=$((score+1)); }

echo "✓ ok: UBERBOSS результат (баллов: $score/$max)"
[ $score -ge 3 ] && exit 0 || exit 1

HINTS
=== БЛОК 1 ===
Multi-stage Docker: FROM golang AS builder → FROM alpine → COPY --from=builder

=== БЛОК 2 ===
Full pipeline: matrix test → cache → build → artifact → docker push → trivy → deploy

=== БЛОК 3 ===
Helm chart: Chart.yaml + values.yaml + templates/ — параметризованные манифесты

=== БЛОК 4 ===
Deploy script: case по environment, canary для production, rollback при ошибке

=== БЛОК 5 ===
Monitor script: gh run list + docker images + git log — аудит конвейера
