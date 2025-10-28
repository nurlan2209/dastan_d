# Photo Studio Frontend (React + Tailwind CSS)

Веб-интерфейс для системы управления фотостудией.

## Технологии

- React 18
- Vite
- Tailwind CSS
- React Router
- Axios
- Zustand (state management)
- React Hook Form
- Recharts (графики)

## Установка и запуск

```bash
# Установите зависимости
npm install

# Запустите dev сервер
npm run dev

# Сборка для production
npm run build
```

Приложение запустится на http://localhost:3000

## Переменные окружения

Создайте `.env`:

```
VITE_API_URL=http://localhost:8080/api
```

## Структура

```
src/
├── components/     # Переиспользуемые компоненты
├── pages/          # Страницы приложения
├── services/       # API сервисы
├── context/        # React Context (Auth)
├── utils/          # Утилиты
└── assets/         # Статические файлы
```

## Функции

- Аутентификация (JWT)
- Управление заказами
- Дашборд с статистикой
- Отчеты и аналитика
- Адаптивный дизайн
- Material Design
