# 🚨 БЫСТРОЕ РЕШЕНИЕ ОШИБКИ ЛОКАЛИЗАЦИИ

## Проблема:
```
Error: Couldn't resolve the package 'flutter_gen'
```

Flutter не сгенерировал файлы локализации автоматически.

---

## ✅ РЕШЕНИЕ (3 способа):

### Способ 1: Использовать скрипт (самый простой)

```bash
cd front
./generate_l10n.sh
flutter run -d chrome
```

### Способ 2: Вручную запустить генерацию

```bash
cd front
flutter gen-l10n
flutter run -d chrome
```

### Способ 3: Полная очистка и пересборка

```bash
cd front
flutter clean
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

---

## 🎯 Что делает `flutter gen-l10n`?

Эта команда читает файлы:
- `lib/l10n/app_kk.arb` (казахский)
- `lib/l10n/app_ru.arb` (русский)

И генерирует Dart код в:
- `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`
- `.dart_tool/flutter_gen/gen_l10n/app_localizations_kk.dart`
- `.dart_tool/flutter_gen/gen_l10n/app_localizations_ru.dart`

---

## ✨ После успешной генерации:

Вы увидите:
```
✓ Generating localizations
✓ Generated 2 locales
```

Теперь приложение запустится на **казахском языке** 🇰🇿!

---

## ❗ Если все равно не работает:

1. Проверьте версию Flutter:
```bash
flutter --version
```

2. Обновите Flutter (если нужно):
```bash
flutter upgrade
```

3. Попробуйте еще раз:
```bash
flutter clean
rm -rf .dart_tool/
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

---

## 📝 Примечание:

Файлы в `.dart_tool/flutter_gen/` **НЕ** коммитятся в git (они в .gitignore).

Каждый разработчик должен сгенерировать их локально командой:
```bash
flutter gen-l10n
```

или

```bash
flutter pub get
```

(если Flutter настроен правильно, генерация происходит автоматически)

---

**Готово!** Теперь запускай `./generate_l10n.sh` и все заработает! 🚀
