META
# Track: docker
# Title: Тайны сосудов
# Number: 004
# Level: 1
# Type: practice
# Difficulty: medium
# TimeLimitMin: 20
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/docker_004"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"

TASK
⚗️ ПРАКТИКУМ #004: Тайны сосудов

Библиотекарь жестом указал на ряд сосудов:
«Ууук!» — это означало: «Каждый сосуд хранит тайну.
IP-адрес, переменные окружения, подключённые тома.
Всё это можно извлечь через inspect. Но вывод огромный.
Используй jq — как фильтр для магических знаний.»

📋 **Задания**:

ASSIGNMENT
1. **Запусти сосуд с секретами**:
   ```bash
   docker run -d --name secret_vault \
     -e MAGIC_WORD=palindrome \
     -e TOWER_FLOOR=7 \
     -p 9090:80 \
     nginx
   ```

2. **Извлеки IP-адрес через jq**:
   ```bash
   docker inspect secret_vault | jq '.[0].NetworkSettings.IPAddress'
   ```

3. **Извлеки переменные окружения**:
   ```bash
   docker inspect secret_vault | jq '.[0].Config.Env'
   ```

4. **Извлеки проброшенные порты**:
   ```bash
   docker inspect secret_vault | jq '.[0].NetworkSettings.Ports'
   ```

5. **Сохрини отчёт** в `$DIR/vault_report.txt`:
   ```bash
   {
     echo "=== Vault Report ==="
     echo "IP: $(docker inspect secret_vault | jq -r '.[0].NetworkSettings.IPAddress')"
     echo "Env: $(docker inspect secret_vault | jq -r '.[0].Config.Env[]')"
     echo "Ports: $(docker inspect secret_vault | jq -r '.[0].NetworkSettings.Ports | keys[]')"
   } > "$DIR/vault_report.txt"
   cat "$DIR/vault_report.txt"
   ```

6. Очистка: `docker stop secret_vault && docker rm secret_vault`

📂 Рабочий каталог: `~/.termtrainer/docker_004`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/docker_004"
score=0

docker run -d --name tower_inspect -e SECRET=magic -p 19090:80 nginx &>/dev/null && sleep 2

ip=$(docker inspect tower_inspect | jq -r '.[0].NetworkSettings.IPAddress' 2>/dev/null)
[ -n "$ip" ] && { echo "✓ IP извлечён: $ip"; score=$((score+1)); }

env=$(docker inspect tower_inspect | jq -r '.[0].Config.Env[]' 2>/dev/null | grep SECRET)
[ -n "$env" ] && { echo "✓ Env извлечён: $env"; score=$((score+1)); }

docker stop tower_inspect &>/dev/null; docker rm tower_inspect &>/dev/null

[ $score -ge 1 ] && { echo "✓ ok: Inspect+jq освоены! (баллов: $score/2)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/2)"
exit 1

HINTS
Inspect: docker inspect <name> — полная информация о сосуде в JSON
IP address: docker inspect X | jq '.[0].NetworkSettings.IPAddress'
Environment: docker inspect X | jq '.[0].Config.Env'
Ports: docker inspect X | jq '.[0].NetworkSettings.Ports'
Volumes: docker inspect X | jq '.[0].Mounts'
jq -r: вывести без кавычек (raw output)
jq keys[]: получить ключи объекта
Save report: перенаправить вывод > file.txt
