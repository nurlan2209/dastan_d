# 📸 Photo Studio Management System

Полнофункциональная система управления фотостудией с кроссплатформенным мобильным приложением.

## 🎯 Описание проекта

Система для управления заказами фотостудии с тремя типами пользователей:
- **Клиенты** — бронируют съемки, просматривают заказы, оставляют отзывы
- **Фотографы** — управляют назначенными заказами, устанавливают расписание
- **Администраторы** — управляют пользователями, просматривают аналитику и отчеты

## 🛠 Технологический стек

### Backend
- **Node.js** + **Express.js** 5.1.0
- **MongoDB** + **Mongoose** 8.19.1
- **JWT** аутентификация (access + refresh tokens)
- **bcryptjs** для хеширования паролей
- **express-validator** для валидации данных
- **PDFKit** для генерации PDF отчетов
- **CSV-Writer** для экспорта в CSV

### Frontend
- **Flutter** 3.0+
- **Provider** для state management
- **Material Design 3**
- **fl_chart** для графиков и визуализации
- **Dio** + **HTTP** для API запросов
- Поддержка платформ: Android, iOS, Web, Windows, Linux, macOS

## 📁 Структура проекта

```
dastan_d/
├── back/              # Backend (Node.js + Express)
│   ├── config/        # Конфигурация БД
│   ├── controllers/   # Бизнес-логика
│   ├── models/        # Mongoose схемы
│   ├── routes/        # API маршруты
│   ├── middleware/    # Auth, валидация, обработка ошибок
│   ├── utils/         # PDF/CSV генераторы, JWT утилиты
│   ├── server.js      # Точка входа
│   ├── package.json
│   └── .env           # Переменные окружения
│
└── front/             # Frontend (Flutter)
    ├── lib/
    │   ├── config/    # API конфигурация
    │   ├── models/    # Data models
    │   ├── providers/ # State management
    │   ├── services/  # API сервисы
    │   ├── screens/   # UI экраны
    │   ├── widgets/   # Переиспользуемые виджеты
    │   ├── theme/     # Тема приложения
    │   └── main.dart
    └── pubspec.yaml
```

## 🚀 Установка и запуск

### Предварительные требования

- **Node.js** >= 16.x
- **MongoDB** (локальная или Atlas)
- **Flutter** >= 3.0
- **Git**

### Backend

1. **Клонируйте репозиторий и перейдите в папку backend:**
   ```bash
   cd back
   ```

2. **Установите зависимости:**
   ```bash
   npm install
   ```

3. **Создайте файл `.env` со следующими переменными:**
   ```env
   PORT=5001
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret_key
   JWT_REFRESH_SECRET=your_refresh_secret_key
   NODE_ENV=development
   ```

4. **Запустите сервер:**
   ```bash
   # Production
   npm start

   # Development (с hot reload)
   npm run dev
   ```

   Сервер запустится на `http://localhost:5001`

### Frontend

1. **Перейдите в папку frontend:**
   ```bash
   cd front
   ```

2. **Установите зависимости:**
   ```bash
   flutter pub get
   ```

3. **Настройте API URL в `lib/config/api_config.dart`:**
   ```dart
   static const String baseUrl = 'http://localhost:5001/api';
   ```

4. **Запустите приложение:**
   ```bash
   # На эмуляторе/симуляторе
   flutter run

   # Для конкретной платформы
   flutter run -d chrome        # Web
   flutter run -d windows       # Windows
   flutter run -d macos         # macOS
   flutter run -d linux         # Linux
   ```

5. **Создайте релизную сборку:**
   ```bash
   # Android APK
   flutter build apk --release

   # iOS
   flutter build ios --release

   # Web
   flutter build web --release
   ```

## 📊 API Endpoints

### Аутентификация (`/api/auth`)
- `POST /register` — Регистрация нового пользователя
- `POST /login` — Вход в систему
- `POST /refresh` — Обновление access token
- `GET /me` — Получить информацию о текущем пользователе

### Заказы (`/api/orders`)
- `GET /` — Получить список заказов (с фильтрацией по роли)
- `GET /:id` — Получить детали заказа
- `POST /` — Создать новый заказ (только клиенты)
- `PUT /:id` — Обновить заказ (админ/фотограф)
- `DELETE /:id` — Удалить заказ (только админ)

### Пользователи (`/api/users`)
- `GET /` — Получить список пользователей (админ)
- `GET /:id` — Получить информацию о пользователе
- `POST /` — Создать пользователя (админ)
- `PUT /:id` — Обновить пользователя (админ)
- `DELETE /:id` — Удалить пользователя (админ)

### Отчеты и статистика (`/api/reports`)
- `GET /summary` — Получить полную статистику (админ)
  - Общие метрики (заказы, выручка, конверсия)
  - Топ фотографов по заказам и рейтингу
  - Динамика заказов по месяцам
  - Распределение по статусам
- `GET /statistics` — Детальная статистика с фильтрами
- `GET /export/pdf` — Экспорт отчета в PDF
- `GET /export/csv` — Экспорт отчета в CSV

### Отзывы (`/api/reviews`)
- CRUD операции для отзывов

### Расписание (`/api/schedule`)
- CRUD операции для расписания фотографов

## 🔒 Безопасность

- ✅ JWT токены (access 15 мин, refresh 7 дней)
- ✅ Хеширование паролей с bcrypt
- ✅ Валидация всех входных данных
- ✅ RBAC (Role-Based Access Control)
- ✅ Helmet.js для HTTP заголовков
- ✅ CORS настроен
- ✅ Централизованная обработка ошибок

## 📈 Основные возможности

### Для клиентов
- Регистрация и вход в систему
- Создание заказов на фотосъемку
- Просмотр своих заказов
- Отслеживание статуса заказов
- Получение результатов работы
- Оставление отзывов

### Для фотографов
- Просмотр назначенных заказов
- Обновление статуса заказов
- Загрузка результатов работы
- Управление расписанием
- Просмотр своего рейтинга

### Для администраторов
- Управление пользователями (CRUD)
- Назначение фотографов на заказы
- Просмотр всех заказов
- **Подробная аналитика:**
  - Ключевые метрики (заказы, выручка, средний чек, конверсия)
  - Графики динамики заказов по месяцам
  - Топ-5 фотографов по заказам
  - Топ-5 фотографов по рейтингу
  - Распределение заказов по статусам
- **Экспорт отчетов:**
  - PDF с таблицей всех заказов
  - CSV для анализа в Excel
  - Фильтрация по датам и статусам

## 🎨 UI/UX Features

- Material Design 3
- Адаптивный дизайн
- Темная тема (опционально)
- Skeleton loaders для улучшения UX
- Анимированные графики и диаграммы
- Pull-to-refresh на всех экранах
- Валидация форм с подсказками
- Toast уведомления
- Обработка ошибок с понятными сообщениями

## 📝 Модели данных

### User (Пользователь)
```javascript
{
  name: String,
  email: String (unique),
  password: String (hashed),
  role: String (client/photographer/admin),
  phone: String,
  rating: Number (для фотографов),
  reviewsCount: Number (для фотографов),
  createdAt: Date,
  updatedAt: Date
}
```

### Order (Заказ)
```javascript
{
  clientId: ObjectId (ref: User),
  photographerId: ObjectId (ref: User),
  service: String,
  date: Date,
  location: String,
  status: String (new/assigned/in_progress/completed/cancelled/archived),
  price: Number,
  result: String (ссылка на результат),
  comment: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Review (Отзыв)
```javascript
{
  orderId: ObjectId (ref: Order),
  clientId: ObjectId (ref: User),
  photographerId: ObjectId (ref: User),
  rating: Number (1-5),
  comment: String,
  createdAt: Date
}
```

### Schedule (Расписание)
```javascript
{
  photographerId: ObjectId (ref: User),
  date: Date,
  startTime: String,
  endTime: String,
  available: Boolean,
  createdAt: Date
}
```

## 🧪 Тестирование

### Backend
```bash
cd back
npm test
```

### Frontend
```bash
cd front
flutter test
```

## 📱 Скриншоты

_TODO: Добавить скриншоты приложения_

## 🤝 Вклад в проект

1. Fork проекта
2. Создайте feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit изменения (`git commit -m 'Add some AmazingFeature'`)
4. Push в branch (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект находится под лицензией MIT.

## 👥 Авторы

- **Ваше имя** - *Начальная работа*

## 🙏 Благодарности

- Flutter team за отличный фреймворк
- Express.js community
- MongoDB team

---

**Примечание:** Перед развертыванием в production убедитесь, что:
- Изменили все секретные ключи в `.env`
- Настроили правильные CORS origins
- Используете HTTPS
- Настроили резервное копирование БД
- Настроили мониторинг и логирование
