# 🔧 Как правильно коммитить от своего имени

## ⚠️ ВАЖНО: История переписана!

Все предыдущие коммиты от `emergent-agent-e1` теперь переписаны на твоё имя:
- **Kostya Tolmatch** <kostyatolmatchh@gmail.com>

## 📝 Текущая конфигурация Git

```bash
git config user.name "Kostya Tolmatch"
git config user.email "kostyatolmatchh@gmail.com"
```

✅ Эта конфигурация уже установлена локально!

## 🚀 Как делать коммиты (2 способа)

### Способ 1: Через "Save to Github" (текущий способ)

1. Нажми кнопку **"Save to Github"** в интерфейсе Emergent
2. ⚠️ Коммит может быть от `emergent-agent-e1` - это ограничение платформы
3. После коммита нужно будет переписать историю снова (см. ниже)

### Способ 2: Ручной коммит (рекомендуется для важных изменений) ✅

```bash
# 1. Посмотри что изменилось
git status

# 2. Добавь файлы
git add .

# 3. Сделай коммит с понятным сообщением
git commit -m "feat(contracts): add payment analytics feature"

# 4. Используй "Save to Github" только для push
# Или если есть доступ к GitHub token:
# git push origin main
```

## 🔄 Если снова появились коммиты от emergent-agent

Запусти этот скрипт для переписывания истории:

```bash
cd /app

# Настрой git (если нужно)
git config user.name "Kostya Tolmatch"
git config user.email "kostyatolmatchh@gmail.com"

# Перепиши историю
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
OLD_EMAIL="github@emergent.sh"
CORRECT_NAME="Kostya Tolmatch"
CORRECT_EMAIL="kostyatolmatchh@gmail.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

# Используй "Save to Github" для force push
```

## 📋 Проверка текущего автора

```bash
# Проверь последние коммиты
git log --format="%an <%ae>" | head -10

# Должно быть:
# Kostya Tolmatch <kostyatolmatchh@gmail.com>
```

## 💡 Лучшие практики

### Хорошие сообщения коммитов (conventional commits):

```bash
# Новая функция
git commit -m "feat(contracts): add merchant registry system"

# Исправление бага
git commit -m "fix(deploy): correct proxy initialization"

# Обновление документации
git commit -m "docs(readme): add Base Pay integration guide"

# Рутинные изменения
git commit -m "chore: update dependencies"

# CI/CD изменения
git commit -m "ci(workflows): add mainnet upgrade workflow"

# Тесты
git commit -m "test(contracts): add payment flow tests"
```

### Плохие сообщения:
❌ "auto-commit for abc-123-def"
❌ "update"
❌ "fix"
❌ "changes"

## 🎯 Для аирдропа важно:

1. **Осмысленные коммиты** - показывают что ты понимаешь что делаешь
2. **Consistent activity** - регулярные коммиты лучше чем один большой
3. **Professional commit messages** - используй conventional commits
4. **Твоё имя в истории** - показывает что это твой проект

---

✅ **Текущий статус:** 
- Git настроен на твоё имя
- История переписана (106 коммитов от тебя)
- Готово к "Save to Github"
