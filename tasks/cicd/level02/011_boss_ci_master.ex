META
# Track: cicd
# Title: Экзамен Мастера Конвейера
# Number: 011
# Level: 2
# Type: boss
# Difficulty: hard
# TimeLimitMin: 30
# XP: 50

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_011"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
🐉 БОСС #011: Экзамен Мастера Конвейера

Архиканцлер вызвал тебя в Главный Зал:
«Ринсвинд! Создай полный production-ready конвейер:
тесты на матрице, сборка Docker, сканирование безопасности,
деплой в staging с ручным подтверждением для production.
И всё это с кэшированием и артефактами!»

📋 **Боевые задания**:

ASSIGNMENT
1. **`.github/workflows/full-pipeline.yml`** — полный pipeline:
   - Matrix test (Go 1.21 + 1.22)
   - Cache Go modules
   - Build + upload artifact
   - Security scan (Trivy)
   - Deploy staging (auto)
   - Deploy production (manual approval)

2. **`Dockerfile`** — multi-stage build:
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
   CMD ["/tower-app"]
   ```

3. **`.gitignore`** — защита секретов

4. **`deploy_check.sh`** — проверка здоровья деплоя

📂 Рабочий каталог: `~/.termtrainer/cicd_011`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_011"
score=0

[ -f "$DIR/.github/workflows/full-pipeline.yml" ] && grep -q "matrix\|cache\|artifact\|deploy\|security\|staging\|production" "$DIR/.github/workflows/full-pipeline.yml" && { echo "✓ full-pipeline.yml создан"; score=$((score+1)); }

[ -f "$DIR/Dockerfile" ] && grep -q "FROM.*AS builder\|COPY --from" "$DIR/Dockerfile" && { echo "✓ Multi-stage Dockerfile создан"; score=$((score+1)); }

[ -f "$DIR/.gitignore" ] && { echo "✓ .gitignore создан"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Мастер Конвейера! (баллов: $score/3)"; exit 0; }
echo "✗ Создай полный pipeline (баллов: $score/3)"
exit 1

HINTS
Full pipeline: matrix test → cache → build → artifact → security → deploy
Multi-stage Docker: FROM golang AS builder → FROM alpine → COPY --from=builder
Environment protection: staging auto, production manual approval
Cache: actions/cache для Go modules по hashFiles('**/go.sum')
Security scan: Trivy action для проверки уязвимостей
Deploy verification: kubectl rollout status после деплоя
