META
# Track: cicd
# Title: Экзамен Конвейерщика
# Number: 006
# Level: 1
# Type: boss
# Difficulty: medium
# TimeLimitMin: 25
# XP: 30

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_006"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR/.github/workflows"

TASK
🐉 БОСС #006: Экзамен Конвейерщика

Архиканцлер вызвал тебя в кабинет:
«Ринсвинд! Создай полный CI/CD конвейер: тест → сборка → деплой.
С Dockerfile, с секретами, с environment protection.
Если что-то упущено — заклинание взорвётся при деплое!»

📋 **Боевые задания**:

1. **Dockerfile** для приложения:
   ```dockerfile
   FROM alpine:3.19
   RUN adduser -D appuser
   WORKDIR /app
   COPY app.sh .
   RUN chmod +x app.sh
   USER appuser
   CMD ["./app.sh"]
   ```

2. **app.sh**:
   ```bash
   #!/bin/sh
   echo "Tower App ${VERSION:-v1.0} — ${ENV:-staging}"
   ```

3. **`.github/workflows/pipeline.yml`**:
   ```yaml
   name: Tower Pipeline
   on:
     push:
       branches: [main]
     pull_request:
   
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - run: echo "🧪 Tests passed!"
     
     build:
       needs: test
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - run: docker build -t tower-app:test .
     
     deploy-staging:
       needs: build
       runs-on: ubuntu-latest
       if: github.ref == 'refs/heads/main'
       environment: staging
       steps:
       - run: echo "🟡 Deployed to staging!"
     
     deploy-production:
       needs: deploy-staging
       runs-on: ubuntu-latest
       environment: production
       steps:
       - run: echo "🔴 Deployed to production!"
   ```

📂 Рабочий каталог: `~/.termtrainer/cicd_006`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/cicd_006"
score=0

[ -f "$DIR/Dockerfile" ] && grep -q "FROM\|CMD\|USER" "$DIR/Dockerfile" && { echo "✓ Dockerfile создан"; score=$((score+1)); }
[ -f "$DIR/app.sh" ] && { echo "✓ app.sh создан"; score=$((score+1)); }
[ -f "$DIR/.github/workflows/pipeline.yml" ] && grep -q "test:\|build:\|deploy" "$DIR/.github/workflows/pipeline.yml" && { echo "✓ Pipeline создан"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: БОСС пройден! Конвейер работает! (баллов: $score/3)"; exit 0; }
echo "✗ Создай полный pipeline (баллов: $score/3)"
exit 1

HINTS
Full pipeline: test → build → deploy-staging → deploy-production
Dockerfile: FROM + COPY + USER + CMD — безопасный образ
Environment protection: staging auto, production с approval
Needs: зависимость между jobs — последовательное выполнение
If condition: if: github.ref == 'refs/heads/main' — только для main
Secrets: ${{ secrets.KEY }} — не хранить пароли в коде!
