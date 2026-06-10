# 🏰 TermTrainer — Незримый Университет Терминала

Интерактивный CLI-тренажёр командной строки в стиле **Плоского Мира** Терри Пратчетта.

Стань студентом Незримого Университета, читай магические свитки, выполняй лабораторные
в Магическом Терминале и сдавай экзамены Совету Магов.

*«In terminale veritas»*

## 🧙 Персонажи

| Персонаж | Роль |
|----------|------|
| **Ринсвинд** (ты) | Студент Незримого Университета, беглец и неудачник |
| **Архиканцлер Чудакулли** | Главный экзаменатор, даёт задания и боссы |
| **Декан Чартер** | Преподаёт шорткаты и императивные команды |
| **Библиотекарь** (Ууук!) | Хранитель свитков, эксперт по jq/awk/data sources |
| **Астрономер** | Эксперт по HTTP и сетевым запросам |

Прогресс сохраняется в `progress.json`:
- **XP** — магическая сила (очки опыта)
- **Звания**: Студент-маг → Студент 2-го курса → Маг-практикант → Старший Маг → Верховный Маг → Архиканцлер
- **Подсказки** — обращения к Магическому Шару

## 🚀 Установка и запуск

```bash
# Требования: Go 1.21+, bash

git clone https://github.com/militarymax/TermTrainer.git
cd TermTrainer
make build          # или: go build -o termtrainer .
./termtrainer
```

### Кросс-компиляция

```bash
make cross-compile  # соберёт termtrainer-darwin-arm64 и termtrainer-linux-amd64
```

## 🎮 Как пользоваться

1. **Выбери свиток (задание)** — введи номер `[1-N]` из главного меню
2. **Прочитай свиток** — [N] / [P] листай страницы если свиток длинный
3. **Нажми [R]** — призови Магический Терминал (интерактивный bash)
4. **Выполни заклинания** — работай в bash, произнеси `exit` чтобы закрыть круг
5. **Нажми [V]** — Совет Магов проверит твоё решение
6. **Если застрял** — спроси Магический Шар [H]

### Управление

| Клавиша | Главное меню | Экран свитка |
|---------|-------------|--------------|
| `1-N`   | Выбрать свиток | — |
| `R`     | — | Открыть Магический Терминал |
| `V`     | — | Проверка Совета Магов |
| `H`     | — | Магический Шар (подсказка) |
| `N`     | — | Следующая страница свитка |
| `P`     | — | Предыдущая страница свитка |
| `P` (меню) | Журнал Мага (прогресс) | — |
| `G`     | Каталог Свитков (инструкция) | — |
| `A`     | **Obliviate** — стереть память | — |
| `M`     | — | Вернуться в Университет |
| `Q`     | Выход | Выход |

## 📂 Структура проекта

```
TermTrainer/
├── main.go              # Приложение на Go (stdlib only, single file)
├── main_test.go         # Тесты парсера и утилит
├── go.mod               # module termtrainer, go 1.21
├── Makefile             # build, test, lint, cross-compile
├── README.md            # Этот свиток
├── CONTRIBUTING.md      # Для контрибьюторов
├── progress.json        # Автосоздаётся — журнал Мага
└── tasks/               # Свитки с заданиями (.ex файлы)
    ├── TEMPLATE.ex.example
    ├── cli-basics/       # 1. 🏰 Основы Магии Терминала (16 заданий)
    │   ├── level01/     #    Первокурсник: cd, ls, cp, find
    │   ├── level02/     #    Практикант: chmod, ps, kill
    │   └── level03/     #    Старший курс: grep, sort, pipes
    ├── text-fu/          # 2. ⚗️ Алхимия Текста (16 заданий)
    │   ├── level01/     #    cat, echo, sort, uniq, redirect
    │   ├── level02/     #    sed, awk, трансмутация текста
    │   └── level03/     #    cut, xargs, regex, find, дешифровка
    ├── scripting/        # 3. 📜 Ритуальные Заклинания (16 заданий)
    │   ├── level01/     #    Базовые скрипты: шебанг, переменные, if/for
    │   ├── level02/     #    Средние: функции, массивы, set -euo, trap
    │   └── level03/     #    Экспертные: ассоциативные массивы, coproc, модульность
    ├── git/             # 4. ⏳ Темпоральная Магия (16 заданий)
    │   ├── level01/     #    init/clone, add/commit, branches, remote
    │   ├── level02/     #    log/blame, rebase/amend, conflicts/stash
    │   └── level03/     #    object model, reflog, hooks, optimization
    ├── jq-yq/           # 5. 🔎 Дешифровка Свитков (16 заданий)
    │   ├── level01/     #    jq basics, raw output, YAML, pipes/arrays
    │   ├── level02/     #    map/select, sort/group_by, mutations
    │   └── level03/     #    reduce/functions, advanced yq, complex pipelines
    ├── netdebug/        # 6. 🌐 Магическая Связь (16 заданий)
    │   ├── level01/     #    Следопыт: ip, ping, dig, nc, curl, tcpdump
    │   ├── level02/     #    Инквизитор: mtr, ss, BPF, RTT, firewall
    │   └── level03/     #    Архимаг Сетей: tshark, TLS, DNS trace, forensics
    ├── docker/          # 7. 🧪 Магические Сосуды (16 заданий)
    │   ├── level01/     #    Подмастерье: run, logs, exec, inspect, Dockerfile
    │   ├── level02/     #    Мастер: compose, stats, debug, multi-stage
    │   └── level03/     #    Архимаг: entrypoint, swarm, security, production
    ├── kubectl/         # 8. 🔮 Призыв Существ (16 заданий)
    │   ├── level01/     #    Призыватель: get, describe, run, logs, exec, NS
    │   ├── level02/     #    Мастер Кластера: CM/Secrets, RBAC, rollout, Ingress
    │   └── level03/     #    Архимаг Кластера: taints, quotas, etcd, upgrade
    ├── cicd/            # 9. ⚙️ Автоматические Чудеса (16 заданий)
    │   ├── level01/     #    Конвейерщик: Git, Actions, Docker CI, deploy
    │   ├── level02/     #    Мастер Конвейера: matrix, artifacts, security, K8s deploy
    │   └── level03/     #    Архимаг Конвейера: GitOps, Helm/Kustomize, monitoring, promotion
    └── terraform/       # 10. 🌍 Создание Миров (16 заданий)
        ├── level01/     #    Архитектор: HCL, variables, Docker provider, modules
        ├── level02/     #    Инженер: workspaces, for_each, dynamic blocks, tfsec
        └── level03/     #    Архимаг Инфраструктуры: moved/import, CI, Terragrunt, Atlantis
```

## 📖 Факультеты (треки)

Факультеты выстроены от фундаментальных (только терминал) к прикладным (требуют внешних инструментов).
Каждый факультет содержит **16 заданий**: по 5-6 на каждом уровне + финальный босс/убербосс.

### ✅ Готовые факультеты (160 заданий)

| # | Факультет | Папка | Заданий | Требования | Лор Плоского Мира |
|---|-----------|-------|---------|------------|-------------------|
| 1 | 🏰 Основы Магии Терминала | `cli-basics` | 16 | bash | Навигация по Башне, файлы-свитки, инструменты мага |
| 2 | ⚗️ Алхимия Текста | `text-fu` | 16 | bash | Алхимическая трансмутация текста, зелья сортировки |
| 3 | 📜 Ритуальные Заклинания | `scripting` | 16 | bash | Написание заклинаний-скриптов, от простых до архимагических |
| 4 | ⏳ Темпоральная Магия | `git` | 16 | git | Ветки = временные линии, коммиты = точки сохранения, rebase = переписывание истории |
| 5 | 🔎 Дешифровка Свитков | `jq-yq` | 16 | jq, yq | JSON/YAML = древние свитки, jq = лупа дешифровщика, yq = переводчик YAML |
| 6 | 🌐 Магическая Связь | `netdebug` | 16 | curl, nc, dig | Карта магических потоков, Книга Имён, уши Башни |
| 7 | 🧪 Магические Сосуды | `docker` | 16 | Docker | Сосуды для демонов, рецепты образов, оркестр сосудов |
| 8 | 🔮 Призыв Существ | `kubectl` | 16 | kubectl + кластер | Призыв подов-существ, армии деплойментов, порталы сервисов |
| 9 | ⚙️ Автоматические Чудеса | `cicd` | 16 | Git + CI/CD | Книга Заклинаний (Git), конвейеры, артефакты, GitOps |
| 10 | 🌍 Создание Миров | `terraform` | 16 | terraform | Чертёж Башни, параллельные миры, мета-чертежи |

### Подробности по факультетам

<details>
<summary>🏰 1. Основы Магии Терминала <code>cli-basics</code></summary>

**Метафора**: Башня = файловая система, комнаты = директории, свитки = файлы

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Первокурсник | Навигация (cd/ls), файлы (cp/mv/rm), инструменты (cat/head/tail) |
| 🟡 2 | Практикант | Права доступа (chmod/chown), процессы (ps/kill), сигналы |
| 🔴 3 | Старший курс | Поиск (find/grep), обработка текста (sort/uniq/pipes), конвейеры |

</details>

<details>
<summary>⚗️ 2. Алхимия Текста <code>text-fu</code></summary>

**Метафора**: Текст = сырьё для алхимической трансмутации, конвейеры = перегонные кубы

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Подмастерье Алхимии | cat/echo, sort/uniq, перенаправление, boss-зелье |
| 🟡 2 | Мастер Трансмутации | sed (потоковый редактор), awk (язык заклинаний), практика sed/awk, сломанный сосуд |
| 🔴 3 | Архимаг Дешифровки | cut/xargs, regex/find, дешифровка древних свитков |

</details>

<details>
<summary>📜 3. Ритуальные Заклинания <code>scripting</code></summary>

**Метафора**: Скрипты = заклинания, от простых заговоров до сложных ритуалов

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Базовые заклинания | Шебанг, переменные, if/for, параметры, коды возврата |
| 🟡 2 | Средние ритуалы | Функции, массивы, set -euo pipefail, trap, mktemp, regex |
| 🔴 3 | Архимагические ритуалы | Ассоциативные массивы, coproc, безопасный параллелизм, модульность |

</details>

<details>
<summary>⏳ 4. Темпоральная Магия <code>git</code></summary>

**Метафора**: Ветки = временные линии, коммиты = точки сохранения, merge = слияние реальностей, rebase = переписывание истории

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Путешественник во времени | init/clone, add/commit/status, branches, remote/.gitignore |
| 🟡 2 | Хранитель Времени | log/blame/restore, amend/rebase -i, conflicts/stash, fetch/tags |
| 🔴 3 | Архимаг Времени | Object model/reflog, advanced rebase/merge, hooks, optimization/security |

</details>

<details>
<summary>🔎 5. Дешифровка Свитков <code>jq-yq</code></summary>

**Метафора**: JSON/YAML = древние свитки, jq = лупа дешифровщика, yq = переводчик YAML-свитков

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Младший дешифровщик | jq install/basics, raw output/pretty print, extract values, YAML basics, pipes/arrays |
| 🟡 2 | Старший дешифровщик | map/select/unique, sort/group_by, YAML mutations, conditional expressions |
| 🔴 3 | Архимаг Дешифровки | reduce/functions, advanced yq, complex pipelines, modules/debug |

</details>

<details>
<summary>🌐 6. Магическая Связь <code>netdebug</code></summary>

**Метафора**: IP = магический адрес, DNS = Книга Имён, порты = номера комнат, TLS = запечатанные письма

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Следопыт | IP/ifconfig, ping, dig/nslookup, nc, curl, tcpdump |
| 🟡 2 | Инквизитор | mtr/traceroute, ss, BPF фильтры, RTT измерения, firewall/NAT |
| 🔴 3 | Архимаг Сетей | tshark+TLS, DNS trace/sysctl, production debugging, network forensics |

</details>

<details>
<summary>🧪 7. Магические Сосуды <code>docker</code></summary>

**Метафора**: Контейнеры = сосуды для демонов, образы = рецепты, compose = партитура оркестра

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Подмастерье Алхимии | run/ps/stop, logs/exec, multi-container, inspect+jq, Dockerfile |
| 🟡 2 | Мастер Сосудов | compose, stats/networks, debug+jq, multi-stage build, сломанный сосуд |
| 🔴 3 | Архимаг Алхимии | entrypoint vs CMD, swarm/scale/security, investigate.sh, production |

</details>

<details>
<summary>🔮 8. Призыв Существ <code>kubectl</code></summary>

**Метафора**: Поды = призванные существа, ноды = башни, деплойменты = армии, сервисы = порталы, RBAC = печати доступа

**Фокус на CKA**: императивные команды, --dry-run=client, rollout, RBAC, etcd backup

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Призыватель | kubectl basics, императивные команды, pods/logs/exec, CrashLoopBackOff, Deploy+SVC |
| 🟡 2 | Мастер Кластера | ConfigMap/Secret/Probes, RBAC (SA+Role+RB), rolling update, Ingress+NetworkPolicy |
| 🔴 3 | Архимаг Кластера | Taints/Affinity, ResourceQuota/LimitRange/etcd, jsonpath+jq audit, kubeadm upgrade |

</details>

<details>
<summary>⚙️ 9. Автоматические Чудеса <code>cicd</code></summary>

**Метафора**: Git = Книга Заклинаний, Pipeline = Конвейер, Actions = Автоматические Ритуалы, ArgoCD = Демон Синхронизации

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Конвейерщик | Git+CI/CD концепции, GitHub Actions, первый workflow, Docker CI, deploy strategies |
| 🟡 2 | Мастер Конвейера | Matrix/artifacts/cache, Trivy+Gitleaks security, K8s deploy из CI |
| 🔴 3 | Архимаг Конвейера | GitOps+ArgoCD, Helm/Kustomize, pipeline monitoring, env promotion+canary |

</details>

<details>
<summary>🌍 10. Создание Миров <code>terraform</code></summary>

**Метафора**: Terraform = Чертёж Башни, State = Книга Записей, Modules = Библиотека Чертежей, Workspaces = Параллельные Миры

| Level | Тема | Задания |
|-------|------|---------|
| 🟢 1 | Архитектор | HCL basics, variables/outputs, Docker provider (локально!), state/data sources, modules |
| 🟡 2 | Инженер | Workspaces+remote backend, count/for_each/dynamic blocks, multi-env, tfsec security |
| 🔴 3 | Архимаг Инфраструктуры | moved/import/state manipulation, testing+CI pipeline, Terragrunt+DRY, Atlantis+GitOps |

</details>

## 🎓 Курсы (уровни)

Каждый уровень заканчивается экзаменом:

| Курс | Папка | Ранг | Финал |
|------|-------|------|-------|
| Первокурсник | `level01` | 📖 Теория + простые практики | 🐉 Boss |
| Практикант | `level02` | 🎓 Средняя сложность | 🐉 Boss |
| Старший курс | `level03` | 🏅 Продвинутые техники | 👑 Uberboss |

## 📜 Типы свитков (заданий)

| Тип | Иконка | Описание |
|-----|--------|----------|
| `theory` | 📜 | Свиток Знаний — теория и показательные примеры |
| `practice` | ⚗️ | Лабораторная — практическое задание |
| `boss` | 🐉 | Экзамен уровня — комбинированное задание |
| `uberboss` | 👑 | Вызов Архиканцлера — финал факультета |

## ⚡ Система XP и званий

| XP | Звание |
|----|--------|
| 0-29 | Студент-маг |
| 30-99 | Студент 2-го курса |
| 100-199 | Маг-практикант |
| 200-299 | Старший Маг |
| 300-499 | Верховный Маг |
| 500+ | Архиканцлер |

XP начисляется автоматически на основе сложности: easy = 10 XP, medium = 25 XP, hard = 50 XP, expert = 100 XP.

## 📝 Формат свитков (.ex)

Каждый `.ex` файл — plain text с магическими секциями:

```
META
# Title: Название свитка
# Number: 001
# Level: 1
# Type: theory|practice|boss|uberboss
# Difficulty: easy|medium|hard|expert
# TimeLimitMin: 10

SETUP
#!/bin/bash
# Подготовка магического круга (выполняется при нажатии [R])

TASK
Текст свитка — описание того, что нужно сделать в терминале.
Включает лор Плоского Мира, примеры команд и объяснения.
Эта секция может быть длинной — она будет разбита на страницы.

ASSIGNMENT
🎯 ЗАДАНИЕ: Краткое название
1. Первый шаг
2. Второй шаг
Нажми [V] когда выполнишь — Совет Магов проверит.

VALIDATION
#!/bin/bash
# Проверка Советом Магов: exit 0 = успех
# ✓ ok — зелёная подсветка, ✗ fail — красная

HINTS
Первая подсказка Магического Шара
Вторая подсказка — конкретнее
Третья — почти готовое заклинание
```

### Секции свитка

| Секция | Обязательна | Описание |
|--------|-------------|----------|
| `META` | ✅ | Метаданные задания. Обязательно только `Title`, остальные поля опциональны |
| `SETUP` | ❌ | Bash-скрипт подготовки окружения. Выполняется перед открытием терминала |
| `TASK` | ✅ | Основной текст свитка — теория, примеры, объяснения. Разбивается на страницы |
| `ASSIGNMENT` | ❌ | Краткое пошаговое задание. Показывается отдельной страницей после TASK |
| `VALIDATION` | ✅ | Bash-скрипт проверки. `exit 0` = успех, строки с `✓`/`✗` подсвечиваются |
| `HINTS` | ❌ | Подсказки (по одной за нажатие [H]) |

### Поля META

| Поле | Обязательное | По умолчанию | Примечание |
|------|-------------|--------------|------------|
| `Title` | ✅ | — | Название свитка |
| `Number` | ❌ | Из имени файла | Трёхзначный номер (001, 002...) |
| `Level` | ❌ | 1 | Уровень (1, 2, 3) |
| `Type` | ❌ | practice | Тип: theory, practice, boss, uberboss |
| `Difficulty` | ❌ | medium | Сложность: easy, medium, hard, expert |
| `TimeLimitMin` | ❌ | 0 | Лимит времени в минутах (0 = без лимита) |

> **Примечание**: Факультет (`Track`) определяется автоматически из пути файла (`tasks/<track>/...`), поле `# Track` в META игнорируется. XP вычисляется из `Difficulty`.

## ➕ Создание нового свитка

1. Создай файл `tasks/<факультет>/levelXX/NNN_name.ex`
2. Номер (NNN) — трёхзначный, уникальный в пределах уровня
3. Заполни META (обязательно: `Title`), SETUP, TASK, VALIDATION, HINTS
4. Используй шаблон: `tasks/TEMPLATE.ex.example`
5. Перезапусти тренажёр — свиток появится в каталоге автоматически

**Порядок в уровне**: theory → practice → boss → uberboss
(сортировка по `Type`, затем по `Number`)

## ⚠️ Особенности магии

- На macOS `sed -i` требует аргумент: `sed -i "" "s/old/new/g" file`
- Магический Терминал призывает `bash` (не zsh)
- VALIDATION выполняется в отдельном магическом круге — не видит переменные интерактивной сессии
- Рабочая директория SETUP — `/tmp/termtrainer_lab/`
- `progress.json` создаётся в текущей рабочей директории

## 🛠 Технологии

- **Go 1.21+** — single-file приложение, только стандартная библиотека
- **Bash** — интерактивная оболочка + скрипты проверки
- **Никаких внешних зависимостей** — pure stdlib magic

---

*«Магия — это не вопрос заклинаний. Это вопрос знания того, какого заклинания не надо произносить.»*
— Архиканцлер Чудакулли, Незримый Университет
