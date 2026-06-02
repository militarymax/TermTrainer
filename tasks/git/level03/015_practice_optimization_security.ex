META
# Track: git
# Title: Оптимизация и печать Канцлера
# Number: 015
# Level: 3
# Type: practice
# Difficulty: hard
# TimeLimitMin: 25
# XP: 40

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_015"
rm -rf "$DIR" 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
for i in $(seq 1 5); do echo "Версия $i" >> история.txt && git add . && git commit -m "feat: version $i"; done

TASK
⚡ **Оптимизация и печать Канцлера**

Репозиторий растёт, коммиты множатся. Нужно уметь оптимизировать хранилище и подписывать важные коммиты — чтобы никто не подделал историю.

📋 **Задания**:
1. Оптимизация репозитория:

ASSIGNMENT
   - Выполни `git gc` — сборка мусора (упаковка объектов)
   - Проверь размер: `git count-objects -vH`
   - Выполни `git repack` — перепаковать объекты
   - Выполни `git prune` — удалить недостижимые объекты

2. Shallow clone:
   - Создай shallow clone: `git clone --depth 1 . /tmp/shallow_test`
   - Проверь: в shallow clone будет только 1 коммит
   - Удали тестовый каталог

3. GPG подпись коммитов (если есть ключ):
   - Попробуй: `git commit -S -m "signed commit"` (нужен GPG ключ)
   - Если нет ключа — просто изучи команду
   - Проверка подписи: `git log --show-signature`

4. Поиск по истории:
   - Найди когда добавили строку: `git log -S "Версия 3" --oneline`
   - Найди во всех коммитах: `git grep "Архив" $(git rev-list --all)`

📂 Рабочий каталог: `~/.termtrainer/git_015`

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_015"
score=0

cd "$DIR" 2>/dev/null || exit 1

# Check gc was run (objects should be packed)
if [ -d ".git/objects/pack" ]; then
  echo "✓ Объекты упакованы (gc/repack выполнен)"
  score=$((score+1))
fi

count_output=$(git count-objects -v 2>/dev/null)
if [ -n "$count_output" ]; then
  echo "✓ count-objects работает"
  score=$((score+1))
fi

commits=$(git rev-list --count HEAD 2>/dev/null)
[ "$commits" -ge 5 ] 2>/dev/null && { echo "✓ $commits коммитов"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Оптимизация и безопасность освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Сборка мусора: git gc — упаковать объекты и удалить мусор
Размер объектов: git count-objects -vH — человекочитаемый размер
Repack: git repack -a -d — перепаковать все объекты
Prune: git prune — удалить недостижимые объекты
Shallow clone: git clone --depth 1 /path/to/repo /tmp/shallow
GPG подпись: git commit -S -m "message" (нужен настроенный GPG ключ)
Проверка подписи: git log --show-signature
Поиск строки: git log -S "текст" --oneline — найти коммиты с добавлением/удалением строки
