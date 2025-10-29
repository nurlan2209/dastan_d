# Руководство по локализации / Локализация нұсқаулығы

## Обзор

Приложение поддерживает два языка:
- 🇰🇿 **Казахский** (по умолчанию)
- 🇷🇺 **Русский**

Используется стандартная система локализации Flutter с файлами `.arb`.

---

## Структура файлов

```
front/
├── l10n.yaml                  # Конфигурация локализации
├── lib/
│   ├── l10n/
│   │   ├── app_kk.arb        # Казахский язык
│   │   └── app_ru.arb        # Русский язык
│   ├── providers/
│   │   └── locale_provider.dart  # Управление языком
│   └── widgets/
│       └── language_switcher.dart  # Переключатель языка
```

---

## Как использовать в коде

### 1. Импортировать локализацию в файл:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### 2. Получить объект локализации:

```dart
final l10n = AppLocalizations.of(context)!;
```

### 3. Использовать переведенные строки:

```dart
Text(l10n.welcomeBack)      // "Қош келдіңіз!" или "С возвращением!"
Text(l10n.login)            // "Кіру" или "Войти"
Text(l10n.email)            // "Email" или "Email"
```

---

## Примеры использования

### Пример 1: AppBar

```dart
AppBar(
  title: Text(l10n.settings),  // "Баптаулар" / "Настройки"
)
```

### Пример 2: Кнопка

```dart
ElevatedButton(
  onPressed: _save,
  child: Text(l10n.save),  // "Сақтау" / "Сохранить"
)
```

### Пример 3: Форма с валидацией

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: l10n.email,
    hintText: l10n.emailHint,
  ),
  validator: (value) {
    if (value == null || !value.contains('@')) {
      return l10n.enterValidEmail;  // "Дұрыс Email енгізіңіз" / "Введите корректный Email"
    }
    return null;
  },
)
```

### Пример 4: Статусы заказов

```dart
String getStatusText(BuildContext context, String status) {
  final l10n = AppLocalizations.of(context)!;

  switch (status) {
    case 'new':
      return l10n.statusNew;           // "Жаңа" / "Новый"
    case 'assigned':
      return l10n.statusAssigned;      // "Тағайындалды" / "Назначен"
    case 'in_progress':
      return l10n.statusInProgress;    // "Орындалуда" / "В работе"
    case 'completed':
      return l10n.statusCompleted;     // "Аяқталды" / "Завершен"
    default:
      return status;
  }
}
```

---

## Добавление новых переводов

### 1. Добавьте ключ и перевод в оба файла:

**`lib/l10n/app_kk.arb`** (Казахский):
```json
{
  "newKey": "Жаңа мәтін",
  "greeting": "Сәлем, {name}!",
  "@greeting": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

**`lib/l10n/app_ru.arb`** (Русский):
```json
{
  "newKey": "Новый текст",
  "greeting": "Привет, {name}!"
}
```

### 2. Запустите генерацию:

```bash
flutter pub get
flutter gen-l10n
```

или просто:

```bash
flutter run
```

Flutter автоматически сгенерирует код при запуске.

### 3. Используйте в коде:

```dart
Text(l10n.newKey)
Text(l10n.greeting('Диас'))  // "Сәлем, Диас!" / "Привет, Диас!"
```

---

## Переключение языка

### Программно:

```dart
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

// Получить текущий язык
final locale = Provider.of<LocaleProvider>(context).locale;

// Изменить язык на казахский
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('kk'));

// Изменить язык на русский
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('ru'));
```

### Через UI виджет:

```dart
import '../widgets/language_switcher.dart';

// В теле виджета:
const LanguageSwitcher()  // Показать как карточку

// Или как иконку с диалогом:
const LanguageSwitcher(showAsDialog: true)
```

---

## Доступные переводы

### Основные
- `appName`, `welcome`, `welcomeBack`, `login`, `register`, `logout`

### Формы
- `email`, `password`, `name`, `phone`, `confirmPassword`
- `enterEmail`, `enterPassword`, `enterName`, `enterValidEmail`
- `passwordTooShort`, `passwordsDoNotMatch`

### Навигация
- `home`, `profile`, `settings`, `notifications`

### Заказы
- `orders`, `myOrders`, `createOrder`, `orderDetails`, `noOrders`

### Статусы
- `statusNew`, `statusAssigned`, `statusInProgress`
- `statusCompleted`, `statusCancelled`, `statusArchived`

### Действия
- `save`, `cancel`, `delete`, `edit`, `add`, `search`, `filter`
- `export`, `exportPDF`, `exportCSV`

### Остальное
- `photographer`, `client`, `service`, `location`, `date`, `time`, `price`
- `loading`, `error`, `success`, `yes`, `no`, `ok`

**Полный список смотрите в файлах `lib/l10n/app_*.arb`**

---

## Пример полного экрана с локализацией

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          // Переключатель языка как иконка
          const LanguageSwitcher(showAsDialog: true),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcome,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Форма
            TextFormField(
              decoration: InputDecoration(
                labelText: l10n.email,
                hintText: l10n.emailHint,
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return l10n.enterValidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Кнопки
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(l10n.save),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Советы

1. **Всегда** используйте `l10n.*` вместо хардкода строк
2. Если нужной строки нет в `.arb`, добавьте её в **оба** файла
3. После добавления новых строк запустите `flutter pub get`
4. Язык сохраняется в `SharedPreferences` и восстанавливается при запуске
5. По умолчанию используется казахский язык

---

## Troubleshooting

### Ошибка: "AppLocalizations not found"
Решение: Запустите `flutter pub get` и перезапустите приложение

### Перевод не обновляется
Решение: Сделайте hot restart (не hot reload)

### Новый ключ не найден
Решение: Проверьте, что добавили ключ в **оба** файла .arb

---

## Контакты

По вопросам локализации обращайтесь к разработчикам проекта.
