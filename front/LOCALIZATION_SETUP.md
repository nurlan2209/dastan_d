# 🌍 Инструкция по запуску локализации / Локализацияны іске қосу нұсқаулығы

## ✅ Что уже сделано

1. ✅ Созданы файлы переводов:
   - `lib/l10n/app_kk.arb` - **Қазақша** (150+ фраз)
   - `lib/l10n/app_ru.arb` - **Русский** (150+ фраз)

2. ✅ Настроена система локализации:
   - LocaleProvider для управления языком
   - LanguageSwitcher виджет для переключения
   - Settings экран с выбором языка

3. ✅ Казахский язык установлен **по умолчанию**

---

## 🚀 Запуск приложения

### Шаг 1: Обновите код

```bash
git pull
```

### Шаг 2: Установите зависимости

```bash
cd front
flutter pub get
```

**Flutter автоматически сгенерирует файлы локализации!**

### Шаг 3: Запустите приложение

```bash
flutter run -d chrome
```

или

```bash
flutter run
```

**Вот и всё!** Приложение запустится на казахском языке 🇰🇿

---

## 🎯 Как использовать переводы в коде

Переводы уже добавлены для **всех основных фраз**. Теперь нужно заменить хардкод тексты на локализованные.

### Пример замены:

**Было (хардкод):**
```dart
Text('Мои заказы')
```

**Стало (с локализацией):**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// В методе build:
final l10n = AppLocalizations.of(context)!;

Text(l10n.myOrders)  // "Менің тапсырыстарым" или "Мои заказы"
```

### Полный пример экрана:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;  // <-- Добавить эту строку

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myOrders),  // <-- Заменить 'Мои заказы' на l10n.myOrders
      ),
      body: Column(
        children: [
          Text(l10n.orderDetails),      // "Тапсырыс туралы" / "Детали заказа"
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.save),      // "Сақтау" / "Сохранить"
          ),
        ],
      ),
    );
  }
}
```

---

## 📋 Доступные переводы

Все ключи находятся в файлах `lib/l10n/app_*.arb`. Вот основные категории:

### Авторизация
- `login`, `register`, `logout`
- `email`, `password`, `name`, `phone`
- `loginError`, `registerSuccess`

### Заказы
- `myOrders`, `createOrder`, `orderDetails`
- `newOrder`, `orderCreatedSuccess`, `orderCancelled`
- `statusNew`, `statusAssigned`, `statusCompleted`, и т.д.

### Услуги
- `services`, `addService`, `selectService`
- `serviceName`, `servicePrice`, `serviceDuration`
- `noServices`, `serviceDeleted`

### Пользователи
- `users`, `userManagement`, `deleteUser`
- `blocked`, `userActivated`

### Общие
- `save`, `cancel`, `delete`, `edit`
- `yes`, `no`, `loading`, `error`
- `downloadPDF`, `downloadCSV`

**Полный список:** см. `lib/l10n/app_kk.arb` или `lib/l10n/app_ru.arb`

---

## 🔧 Переключение языка

### Через UI:

1. Зайдите в **Настройки** (`/settings`)
2. Выберите нужный язык: 🇰🇿 Қазақша или 🇷🇺 Русский

### Программно:

```dart
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

// Сменить на казахский
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('kk'));

// Сменить на русский
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('ru'));
```

---

## 📝 Как добавить новый перевод

Если нужной фразы нет в списке:

1. Откройте оба файла:
   - `lib/l10n/app_kk.arb`
   - `lib/l10n/app_ru.arb`

2. Добавьте ключ в **оба** файла:

**app_kk.arb:**
```json
{
  "myNewKey": "Менің жаңа фразам"
}
```

**app_ru.arb:**
```json
{
  "myNewKey": "Моя новая фраза"
}
```

3. Перезапустите приложение:
```bash
flutter run
```

4. Используйте:
```dart
Text(l10n.myNewKey)
```

---

## 🎨 Экраны для перевода

Следующие экраны содержат хардкод текстына которые нужно заменить на `l10n.*`:

### Приоритет 1 (основные):
- ✅ `screens/shared/settings_screen.dart` - **уже переведен**
- `screens/auth/login_screen.dart`
- `screens/auth/register_screen.dart`
- `screens/client/my_orders_screen.dart`
- `screens/client/create_order_screen.dart`

### Приоритет 2:
- `screens/photographer/photographer_home_screen.dart`
- `screens/photographer/my_orders_screen.dart`
- `screens/photographer/schedule_screen.dart`
- `screens/admin/dashboard_screen.dart`
- `screens/admin/orders_screen.dart`

### Приоритет 3:
- Все остальные экраны в `screens/`

---

## 🔍 Быстрая проверка

После запуска приложения:

1. ✅ Язык по умолчанию должен быть **казахский** 🇰🇿
2. ✅ Зайдите в Settings - должен показаться переключатель языка
3. ✅ Переключите на русский - все тексты в Settings должны смениться
4. ✅ Перезапустите приложение - язык должен сохраниться

---

## ❗ Troubleshooting

### Ошибка: "AppLocalizations not found"

**Решение:**
```bash
flutter pub get
flutter clean
flutter run
```

### Перевод не обновляется

**Решение:** Сделайте **hot restart** (не hot reload):
- Нажмите `R` в терминале
- Или остановите и запустите заново

### Новый ключ не найден

**Решение:** Проверьте, что добавили ключ в **оба** файла (.arb)

---

## 📚 Дополнительно

- Подробное руководство: `LOCALIZATION_GUIDE.md`
- Примеры использования: см. `screens/shared/settings_screen.dart`
- Виджет переключателя: `widgets/language_switcher.dart`

---

## ✨ Следующие шаги

1. **Запустите приложение** - убедитесь что локализация работает
2. **Постепенно заменяйте тексты** - начните с login/register экранов
3. **Используйте `l10n.*`** вместо хардкод строк
4. **Тестируйте на обоих языках** - переключайтесь между қазақша и русский

**Удачи! Сәттілік тілеймін!** 🚀
