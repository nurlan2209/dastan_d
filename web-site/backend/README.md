# Photo Studio Backend (Spring Boot)

Backend для системы управления фотостудией на Java Spring Boot.

## Технологии

- Java 17
- Spring Boot 3.2.0
- Spring Security + JWT
- MongoDB
- Cloudinary для медиа
- Maven

## Запуск

```bash
# Установите зависимости
mvn clean install

# Запустите приложение
mvn spring-boot:run
```

Сервер запустится на http://localhost:8080

## Переменные окружения

Создайте `.env` или настройте в `application.properties`:

```
MONGODB_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## API Endpoints

- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Вход
- `POST /api/auth/refresh` - Обновление токена
- `GET /api/orders` - Список заказов
- `POST /api/orders` - Создать заказ
- ... и другие

