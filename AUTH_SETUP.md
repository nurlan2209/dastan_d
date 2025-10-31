# Настройка системы авторизации с подтверждением email

Данная система реализует:
- ✅ Регистрацию с отправкой 6-значного кода подтверждения на email
- ✅ Подтверждение email (код действует 5 минут)
- ✅ Запрет входа без подтверждения email
- ✅ Функцию "Забыли пароль" с отправкой кода на email
- ✅ Сброс пароля с вводом нового пароля

## Настройка Backend

### 1. Установка зависимостей

```bash
cd back
npm install nodemailer
```

### 2. Настройка SMTP в .env файле

Откройте файл `back/.env` и настройте следующие параметры:

#### Для Gmail:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM_NAME=Photo Studio
```

**Важно для Gmail:**
1. Перейдите в https://myaccount.google.com/security
2. Включите двухфакторную аутентификацию
3. Создайте "Пароль приложения" для приложения
4. Используйте сгенерированный пароль в SMTP_PASSWORD

#### Для Mail.ru:

```env
SMTP_HOST=smtp.mail.ru
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=your-email@mail.ru
SMTP_PASSWORD=your-password
SMTP_FROM_NAME=Photo Studio
```

#### Для Yandex:

```env
SMTP_HOST=smtp.yandex.ru
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=your-email@yandex.ru
SMTP_PASSWORD=your-password
SMTP_FROM_NAME=Photo Studio
```

### 3. Запуск сервера

```bash
cd back
npm start
```

## API Эндпоинты

### Регистрация
```
POST /api/auth/register
Body: {
  "name": "Иван Иванов",
  "email": "ivan@example.com",
  "password": "Password123!",
  "phone": "+77001234567"
}
Response: {
  "message": "Регистрация успешна. Проверьте вашу почту для подтверждения аккаунта.",
  "userId": "...",
  "email": "ivan@example.com"
}
```

### Подтверждение Email
```
POST /api/auth/verify-email
Body: {
  "email": "ivan@example.com",
  "code": "123456"
}
Response: {
  "message": "Email успешно подтвержден",
  "accessToken": "...",
  "refreshToken": "...",
  "role": "client",
  "userId": "...",
  "name": "Иван Иванов",
  "email": "ivan@example.com"
}
```

### Повторная отправка кода подтверждения
```
POST /api/auth/resend-verification
Body: {
  "email": "ivan@example.com"
}
Response: {
  "message": "Код подтверждения отправлен повторно"
}
```

### Вход
```
POST /api/auth/login
Body: {
  "email": "ivan@example.com",
  "password": "Password123!"
}
Response (если email не подтвержден):
{
  "message": "Email не подтвержден. Проверьте вашу почту.",
  "emailNotVerified": true,
  "email": "ivan@example.com"
}
Response (если email подтвержден):
{
  "accessToken": "...",
  "refreshToken": "...",
  "role": "client",
  "userId": "...",
  "name": "Иван Иванов",
  "email": "ivan@example.com"
}
```

### Запрос сброса пароля
```
POST /api/auth/forgot-password
Body: {
  "email": "ivan@example.com"
}
Response: {
  "message": "Если указанный email зарегистрирован, на него отправлен код для сброса пароля"
}
```

### Сброс пароля
```
POST /api/auth/reset-password
Body: {
  "email": "ivan@example.com",
  "code": "123456",
  "newPassword": "NewPassword123!"
}
Response: {
  "message": "Пароль успешно изменен"
}
```

## Настройка Flutter приложения

Файлы уже созданы и настроены:
- `front/lib/screens/auth/email_verification_screen.dart`
- `front/lib/screens/auth/forgot_password_screen.dart`
- `front/lib/screens/auth/reset_password_screen.dart`
- `front/lib/services/auth_service.dart` (обновлен)

## Настройка веб-сайта

Файлы уже созданы и настроены:
- `web-site/frontend/src/pages/VerifyEmail.jsx`
- `web-site/frontend/src/pages/ForgotPassword.jsx`
- `web-site/frontend/src/pages/ResetPassword.jsx`
- `web-site/frontend/src/services/api.js` (обновлен)

## Безопасность

✅ Все пароли хранятся в зашифрованном виде (bcrypt)
✅ Коды подтверждения действительны только 5 минут
✅ Коды удаляются после использования
✅ Просроченные коды автоматически удаляются из БД
✅ При неудачной отправке письма пользователь удаляется из БД

## Тестирование

### 1. Тестирование регистрации

1. Откройте приложение/сайт
2. Перейдите на страницу регистрации
3. Заполните форму и нажмите "Зарегистрироваться"
4. Проверьте почту - должно прийти письмо с 6-значным кодом
5. Введите код на странице подтверждения
6. После успешного подтверждения вы будете авторизованы

### 2. Тестирование входа

1. Попробуйте войти без подтверждения email - должна появиться ошибка
2. После подтверждения email вход должен работать нормально

### 3. Тестирование сброса пароля

1. На странице входа нажмите "Забыли пароль"
2. Введите email
3. Проверьте почту - должно прийти письмо с кодом
4. Введите код и новый пароль
5. Войдите с новым паролем

## Возможные проблемы

### Письма не приходят

1. Проверьте настройки SMTP в .env файле
2. Проверьте логи сервера на наличие ошибок
3. Проверьте папку "Спам" в почтовом ящике
4. Убедитесь, что для Gmail создан "Пароль приложения"

### Ошибка "Invalid login"

1. Убедитесь, что SMTP_USER и SMTP_PASSWORD указаны корректно
2. Для Gmail используйте "Пароль приложения", а не обычный пароль

### Таймаут при отправке

1. Проверьте SMTP_PORT (587 для TLS, 465 для SSL)
2. Проверьте SMTP_SECURE (false для TLS, true для SSL)
3. Проверьте интернет-соединение сервера

## База данных

Добавлены следующие изменения:

### Таблица User
- Добавлено поле `emailVerified` (Boolean, по умолчанию false)

### Новая таблица VerificationCode
```javascript
{
  email: String (indexed),
  code: String (6-значный код),
  type: String (enum: ["email_verification", "password_reset"]),
  expiresAt: Date (indexed, автоудаление),
  isUsed: Boolean (по умолчанию false)
}
```

Коды автоматически удаляются через 5 минут после создания благодаря TTL индексу MongoDB.
