// Русские переводы
import 'app_localizations.dart';

class AppLocalizationsRu extends AppLocalizations {
  @override
  String get appName => 'Photostudio';
  @override
  String get welcome => 'Добро пожаловать!';
  @override
  String get welcomeBack => 'С возвращением!';
  @override
  String get welcomeToPhotostudio => 'Добро пожаловать в Photostudio';
  @override
  String get loginToAccount => 'Войдите в свой аккаунт Photostudio';
  @override
  String get createAccount => 'Создать аккаунт';
  @override
  String get login => 'Войти';
  @override
  String get register => 'Регистрация';
  @override
  String get logout => 'Выйти';
  @override
  String get logoutConfirm => 'Подтвердите выход';
  @override
  String get logoutQuestion => 'Вы уверены, что хотите выйти?';
  @override
  String get email => 'Email';
  @override
  String get password => 'Пароль';
  @override
  String get confirmPassword => 'Подтвердите пароль';
  @override
  String get name => 'Имя';
  @override
  String get phone => 'Телефон';
  @override
  String get enterEmail => 'Введите Email';
  @override
  String get enterPassword => 'Введите пароль';
  @override
  String get enterName => 'Введите ваше имя';
  @override
  String get enterYourName => 'Введите ваше имя';
  @override
  String get enterValidEmail => 'Введите корректный Email';
  @override
  String get passwordTooShort => 'Пароль слишком короткий';
  @override
  String get passwordMin6 => 'Минимум 6 символов';
  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';
  @override
  String loginErrorMsg(String error) => 'Ошибка входа: $error';
  @override
  String registerErrorMsg(String error) => 'Ошибка регистрации: $error';
  @override
  String get loginError => 'Ошибка входа';
  @override
  String get registerError => 'Ошибка регистрации';
  @override
  String get emailHint => 'ivan@example.com';
  @override
  String get nameHint => 'Иван Иванов';
  @override
  String get registerSuccess => 'Регистрация успешна! Теперь войдите.';
  @override
  String get home => 'Главная';
  @override
  String get profile => 'Профиль';
  @override
  String get settings => 'Настройки';
  @override
  String get notifications => 'Уведомления';
  @override
  String get noNotifications => 'Уведомлений нет';
  @override
  String get orders => 'Заказы';
  @override
  String get myOrders => 'Мои заказы';
  @override
  String get createOrder => 'Создать заказ';
  @override
  String get newOrder => 'Новый заказ';
  @override
  String get orderDetails => 'Детали заказа';
  @override
  String get noOrders => 'Нет заказов';
  @override
  String get noOrdersFilter => 'Нет заказов по данному фильтру';
  @override
  String get ordersNotFound => 'Заказы не найдены';
  @override
  String get order => 'Заказ';
  @override
  String get orderManagement => 'Управление заказами';
  @override
  String get orderCreatedSuccess => 'Заказ создан успешно!';
  @override
  String get orderCancelled => 'Заказ отменен';
  @override
  String get orderCompleted => 'Заказ завершен!';
  @override
  String get cancelOrder => 'Отменить заказ';
  @override
  String get cancelOrderConfirm => 'Отменить заказ?';
  @override
  String get cannotCancelOrder => 'Невозможно отменить заказ в текущем статусе';
  @override
  String get yesCancel => 'Да, отменить';
  @override
  String get photographers => 'Фотографы';
  @override
  String get photographer => 'Фотограф';
  @override
  String get createPhotographer => 'Создать аккаунт фотографа';
  @override
  String get createPhotographerAccount => 'Создать аккаунт фотографа';
  @override
  String get photographerName => 'Имя фотографа*';
  @override
  String get photographerCreatedSuccess => 'Фотограф успешно создан!';
  @override
  String get selectPhotographer => 'Выберите фотографа';
  @override
  String get photographerAssignedSuccess => 'Фотограф назначен!';
  @override
  String get client => 'Клиент';
  @override
  String get clients => 'Клиенты';
  @override
  String get service => 'Услуга';
  @override
  String get services => 'Услуги';
  @override
  String get servicesCatalog => 'Каталог услуг';
  @override
  String get selectService => 'Выберите услугу';
  @override
  String get selectServiceHint => 'Выберите услугу';
  @override
  String get pleaseSelectService => 'Пожалуйста, выберите услугу';
  @override
  String get noServices => 'Услуги пока не добавлены';
  @override
  String get noServicesInCatalog => 'Нет услуг в каталоге';
  @override
  String get addService => 'Добавить услугу';
  @override
  String get newService => 'Новая услуга';
  @override
  String get editService => 'Редактировать услугу';
  @override
  String get deleteService => 'Удалить услугу';
  @override
  String deleteServiceConfirm(String name) => 'Вы уверены, что хотите удалить \'$name\'?';
  @override
  String get serviceDeleted => 'Услуга удалена';
  @override
  String get serviceUpdated => 'Услуга обновлена';
  @override
  String get serviceName => 'Название';
  @override
  String get serviceDescription => 'Описание';
  @override
  String get servicePrice => 'Цена (₸)';
  @override
  String get serviceDuration => 'Длительность (минут)';
  @override
  String get location => 'Локация';
  @override
  String get locationHint => "Напр. 'Парк Горского'";
  @override
  String get shootingLocation => 'Место съёмки*';
  @override
  String get date => 'Дата';
  @override
  String get time => 'Время';
  @override
  String get dateTime => 'Дата и время';
  @override
  String get dateTimeRequired => 'Дата и время*';
  @override
  String get price => 'Цена';
  @override
  String get status => 'Статус';
  @override
  String get statusUpdated => 'Статус обновлён';
  @override
  String get comment => 'Комментарий';
  @override
  String get comments => 'Комментарии';
  @override
  String get commentHint => 'Любые пожелания к заказу';
  @override
  String get commentPlaceholder => 'Расскажите о своем опыте...';
  @override
  String get statusNew => 'Новый';
  @override
  String get statusAssigned => 'Назначен';
  @override
  String get statusInProgress => 'В работе';
  @override
  String get statusCompleted => 'Завершен';
  @override
  String get statusCancelled => 'Отменен';
  @override
  String get statusArchived => 'Архив';
  @override
  String get statusAll => 'Все';
  @override
  String get statusPending => 'В ожидании';
  @override
  String get statusConfirmed => 'Подтверждён';
  @override
  String get statusCompletedPlural => 'Завершены';
  @override
  String get dashboard => 'Панель управления';
  @override
  String get statistics => 'Статистика';
  @override
  String get reports => 'Отчеты';
  @override
  String get reportsAndStatistics => 'Отчеты и Статистика';
  @override
  String get users => 'Пользователи';
  @override
  String get userManagement => 'Управление аккаунтами';
  @override
  String get usersNotFound => 'Пользователи не найдены';
  @override
  String get deleteUser => 'Удалить пользователя';
  @override
  String deleteUserConfirm(String name) => 'Вы уверены, что хотите удалить \'$name\'?';
  @override
  String get userDeleted => 'Пользователь удален';
  @override
  String get userActivated => 'Пользователь активирован';
  @override
  String get blocked => 'Заблокирован';
  @override
  String get blockUser => 'Заблокировать';
  @override
  String get activateUser => 'Активировать';
  @override
  String get admin => 'Администратор';
  @override
  String get admins => 'Админы';
  @override
  String get totalOrders => 'Всего заказов';
  @override
  String get totalRevenue => 'Общая выручка';
  @override
  String get averageCheck => 'Средний чек';
  @override
  String get completionRate => 'Процент завершения';
  @override
  String get save => 'Сохранить';
  @override
  String get cancel => 'Отмена';
  @override
  String get delete => 'Удалить';
  @override
  String get edit => 'Редактировать';
  @override
  String get add => 'Добавить';
  @override
  String get search => 'Поиск';
  @override
  String get filter => 'Фильтр';
  @override
  String get export => 'Экспорт';
  @override
  String get exportPDF => 'Экспорт PDF';
  @override
  String get exportCSV => 'Экспорт CSV';
  @override
  String get downloadPDF => 'Скачать PDF';
  @override
  String get downloadCSV => 'Скачать CSV';
  @override
  String get retry => 'Повторить';
  @override
  String get refresh => 'Обновить';
  @override
  String get fillAllFields => 'Заполните все поля';
  @override
  String get yes => 'Да';
  @override
  String get no => 'Нет';
  @override
  String get ok => 'ОК';
  @override
  String get loading => 'Загрузка...';
  @override
  String get loadingData => 'Загрузка данных...';
  @override
  String loadingError(String error) => 'Ошибка загрузки: $error';
  @override
  String get error => 'Ошибка';
  @override
  String errorMsg(String error) => 'Ошибка: $error';
  @override
  String get success => 'Успешно';
  @override
  String get noData => 'Нет данных за выбранный период';
  @override
  String get changePeriod => 'Изменить период';
  @override
  String get selectLanguage => 'Выберите язык';
  @override
  String get kazakh => 'Казахский';
  @override
  String get russian => 'Русский';
  @override
  String get language => 'Язык';
  @override
  String get schedule => 'Расписание';
  @override
  String get mySchedule => 'Мой График';
  @override
  String get noOrdersForDay => 'На выбранный день заказов нет';
  @override
  String get reviews => 'Отзывы';
  @override
  String get myReviews => 'Мои отзывы';
  @override
  String get reviewsManagement => 'Управление отзывами';
  @override
  String get noReviews => 'Отзывов пока нет';
  @override
  String loadingReviewsError(String error) => 'Ошибка загрузки отзывов: $error';
  @override
  String get leaveReview => 'Оставить отзыв';
  @override
  String get cannotLeaveReview => 'Невозможно оставить отзыв: фотограф не назначен';
  @override
  String get thanksForReview => 'Спасибо за отзыв!';
  @override
  String get reviewDeleted => 'Отзыв удален';
  @override
  String get rating => 'Рейтинг';
  @override
  String get noPhotographerAssigned => 'Фотограф не назначен';
  @override
  String get assignPhotographer => 'Назначить фотографа';
  @override
  String get startDate => 'Дата начала';
  @override
  String get endDate => 'Дата окончания';
  @override
  String get apply => 'Применить';
  @override
  String get reset => 'Сбросить';
  @override
  String get total => 'Всего';
  @override
  String get tenge => 'тг';
  @override
  String get filesLink => 'Ссылка на файлы';
  @override
  String get uploadResults => 'Загрузить результаты';
  @override
  String get completeOrder => 'Завершить заказ';
  @override
  String get startWork => 'Начать работу';
  @override
  String get addResultLink => 'Добавьте ссылку на результат работы:';
  @override
  String get addResultLinkPlaceholder => 'Добавьте ссылку на результат';
  @override
  String get resultLinkHint => 'Ссылка на Google Drive / Яндекс.Диск';
  @override
  String get payments => 'Выплаты';
  @override
  String get photographerPayments => 'Выплаты фотографам';
  @override
  String get paymentsCalculation => 'Расчет выплат';
  @override
  String get viewPaymentsList => 'Просмотр ведомости выплат фотографам';
  @override
  String get paymentPercentage => 'Процент выплаты';
  @override
  String get paymentPercentageHint => 'Например: 70';
  @override
  String get enterNumber1to100 => 'Введите число от 1 до 100';
  @override
  String get percentage => 'Процент (%)';
  @override
  String get reportDownloadStarted => 'Загрузка отчета началась...';
  @override
  String reportDownloadError(String error) => 'Ошибка загрузки отчета: $error';
  @override
  String get onboardingEasyBooking => 'Легкое бронирование';
  @override
  String get onboardingTrackStatus => 'Отслеживание статуса';
  @override
  String get onboardingGetResults => 'Получайте результаты';
  @override
  String get onboardingGetResultsDesc => 'Фотографы загружают готовые работы прямо в приложение';
  @override
  String get next => 'Далее';
  @override
  String get getStarted => 'Начать';
  @override
  String loadingServicesError(String error) => 'Ошибка загрузки услуг: $error';
  @override
  String loadingDataError(String error) => 'Ошибка загрузки данных: $error';
}
