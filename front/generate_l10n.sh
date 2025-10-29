#!/bin/bash

echo "🌍 Генерация файлов локализации..."
echo ""

# Генерация локализации
flutter gen-l10n

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Локализация успешно сгенерирована!"
    echo ""
    echo "Файлы созданы в: .dart_tool/flutter_gen/gen_l10n/"
    echo ""
    echo "Теперь можно запустить приложение:"
    echo "  flutter run -d chrome"
else
    echo ""
    echo "❌ Ошибка при генерации локализации"
    echo ""
    echo "Попробуйте:"
    echo "  1. flutter clean"
    echo "  2. flutter pub get"
    echo "  3. flutter gen-l10n"
fi
