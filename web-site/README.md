# 🌐 Photo Studio Web Application

Полноценное веб-приложение для управления фотостудией.

## 📚 Структура проекта

```
web-site/
├── backend/         # Java Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   └── README.md
│
└── frontend/        # React + Tailwind Frontend
    ├── src/
    ├── package.json
    └── README.md
```

## 🛠 Технологии

### Backend
- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Security + JWT**
- **MongoDB** (та же база что и в мобильном приложении)
- **Cloudinary** для загрузки фото
- **Maven**

### Frontend
- **React 18**
- **Vite**
- **Tailwind CSS**
- **React Router**
- **Axios**
- **Recharts** для графиков

## 🚀 Быстрый старт

### Backend

```bash
cd backend

# Установите зависимости
mvn clean install

# Настройте application.properties
# MONGODB_URI, JWT_SECRET, CLOUDINARY_*

# Запустите
mvn spring-boot:run
```

Backend запустится на `http://localhost:8080`

### Frontend

```bash
cd frontend

# Установите зависимости
npm install

# Настройте .env
# VITE_API_URL=http://localhost:8080/api

# Запустите dev сервер
npm run dev
```

Frontend запустится на `http://localhost:3000`

## 📊 Особенности

- ✅ JWT аутентификация с refresh tokens
- ✅ Роли: CLIENT, PHOTOGRAPHER, ADMIN
- ✅ Управление заказами
- ✅ Загрузка результатов на Cloudinary
- ✅ Статистика и отчеты (PDF, CSV)
- ✅ Адаптивный дизайн
- ✅ Material Design UI

## 🔗 API Endpoints

- `POST /api/auth/login` - Вход
- `POST /api/auth/register` - Регистрация
- `GET /api/orders` - Список заказов
- `POST /api/orders` - Создать заказ
- `GET /api/reports/summary` - Статистика
- И другие...

## 🗄️ База данных

Использует ту же MongoDB что и мобильное приложение. Коллекции:
- `users`
- `orders`
- `reviews`
- `schedules`

## 📝 Лицензия

MIT

## 👥 Разработчики

Photo Studio Team

---

**Примечание:** Веб-приложение работает с той же базой данных и API логикой, что и мобильное Flutter приложение. Это позволяет клиентам использовать как веб, так и мобильную версию.
