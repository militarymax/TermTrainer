META
# Track: git
# Title: Метки времени и дальние вести
# Number: 010
# Level: 2
# Type: practice
# Difficulty: medium
# TimeLimitMin: 15
# XP: 20

SETUP
#!/bin/bash
DIR="$HOME/.termtrainer/git_010"
rm -rf "$DIR" /tmp/git_010_bare.git 2>/dev/null
mkdir -p "$DIR"
cd "$DIR" && git init && git config user.email "rincewind@uu.edu" && git config user.name "Rincewind"
echo "# Архив" > README.md && git add . && git commit -m "feat: initial"
echo "Зелье" >> зелья.txt && git add . && git commit -m "feat: potions"
git init --bare /tmp/git_010_bare.git >/dev/null 2>&1

TASK
🏷️ **Метки времени и дальние вести**

Теги — это метки важных моментов в истории (релизы, версии). А fetch позволяет узнать, что нового на удалённом репо, не сливая изменения.

📋 **Задания**:
1. Создай легковесный тег: `git tag v1.0`
2. Создай аннотированный тег: `git tag -a v1.1 -m "Version 1.1 - added potions"`
3. Посмотри все теги: `git tag`
4. Посмотри информацию о теге: `git show v1.1`
5. Добавь remote: `git remote add origin /tmp/git_010_bare.git`
6. Запушь с тегами: `git push origin main --tags`

ASSIGNMENT
7. Выполни `git fetch origin` — получить информацию об удалённых изменениях
8. Сравни fetch vs pull: pull = fetch + merge

📖 **Разница fetch и pull**:
• `git fetch` — только скачивает информацию, НЕ меняет рабочие файлы
• `git pull` = `git fetch` + `git merge` — скачивает И применяет
• `git pull --rebase` = `git fetch` + `git rebase` — линейная история

📂 Рабочий каталог: `~/.termtrainer/git_010`

📂 Перейди в рабочий каталог: cd $HOME/.termtrainer/git_010

VALIDATION
#!/bin/bash
DIR="$HOME/.termtrainer/git_010"
score=0

cd "$DIR" 2>/dev/null || exit 1

tags=$(git tag 2>/dev/null)
if [ -n "$tags" ]; then
  echo "✓ Теги созданы: $(echo $tags | tr '\n' ' ')"
  score=$((score+1))
fi

annotated=$(git tag -l -n1 v1.1 2>/dev/null)
if echo "$annotated" | grep -q 'Version'; then
  echo "✓ Аннотированный тег v1.1"
  score=$((score+1))
fi

remotes=$(git remote 2>/dev/null)
[ -n "$remotes" ] && { echo "✓ Remote настроен"; score=$((score+1)); }

[ $score -ge 2 ] && { echo "✓ ok: Метки и дальние вести освоены! (баллов: $score/3)"; exit 0; }
echo "✗ Нужно больше практики (баллов: $score/3)"
exit 1

HINTS
Легковесный тег: git tag v1.0
Аннотированный тег: git tag -a v1.1 -m "Описание"
Список тегов: git tag
Информация о теге: git show v1.1
Push с тегами: git push origin main --tags
Push один тег: git push origin v1.1
Fetch: git fetch origin — скачать без применения
Pull = fetch + merge: git pull origin main
Pull rebase: git pull --rebase origin main — линейная история
