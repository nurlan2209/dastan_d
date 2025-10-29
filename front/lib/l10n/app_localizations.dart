// Ручной класс локализации
// Альтернатива автогенерации flutter_gen

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('kk'),
    Locale('ru'),
  ];

  // App
  String get appName;
  String get welcome;
  String get welcomeBack;
  String get welcomeToPhotostudio;
  String get loginToAccount;
  String get createAccount;
  String get login;
  String get register;
  String get logout;
  String get logoutConfirm;
  String get logoutQuestion;

  // Auth
  String get email;
  String get password;
  String get confirmPassword;
  String get name;
  String get phone;
  String get enterEmail;
  String get enterPassword;
  String get enterName;
  String get enterYourName;
  String get enterValidEmail;
  String get passwordTooShort;
  String get passwordMin6;
  String get passwordsDoNotMatch;
  String loginErrorMsg(String error);
  String registerErrorMsg(String error);
  String get loginError;
  String get registerError;
  String get emailHint;
  String get nameHint;
  String get registerSuccess;

  // Navigation
  String get home;
  String get profile;
  String get settings;
  String get notifications;
  String get noNotifications;

  // Orders
  String get orders;
  String get myOrders;
  String get createOrder;
  String get newOrder;
  String get orderDetails;
  String get noOrders;
  String get noOrdersFilter;
  String get ordersNotFound;
  String get order;
  String get orderManagement;
  String get orderCreatedSuccess;
  String get orderCancelled;
  String get orderCompleted;
  String get cancelOrder;
  String get cancelOrderConfirm;
  String get cannotCancelOrder;
  String get yesCancel;

  // Photographers
  String get photographers;
  String get photographer;
  String get createPhotographer;
  String get createPhotographerAccount;
  String get photographerName;
  String get photographerCreatedSuccess;
  String get selectPhotographer;
  String get photographerAssignedSuccess;

  // Clients
  String get client;
  String get clients;

  // Services
  String get service;
  String get services;
  String get servicesCatalog;
  String get selectService;
  String get selectServiceHint;
  String get pleaseSelectService;
  String get noServices;
  String get noServicesInCatalog;
  String get addService;
  String get newService;
  String get editService;
  String get deleteService;
  String deleteServiceConfirm(String name);
  String get serviceDeleted;
  String get serviceUpdated;
  String get serviceName;
  String get serviceDescription;
  String get servicePrice;
  String get serviceDuration;

  // Location
  String get location;
  String get locationHint;
  String get shootingLocation;

  // Date/Time
  String get date;
  String get time;
  String get dateTime;
  String get dateTimeRequired;
  String get price;
  String get status;
  String get statusUpdated;

  // Comments
  String get comment;
  String get comments;
  String get commentHint;
  String get commentPlaceholder;

  // Statuses
  String get statusNew;
  String get statusAssigned;
  String get statusInProgress;
  String get statusCompleted;
  String get statusCancelled;
  String get statusArchived;
  String get statusAll;
  String get statusPending;
  String get statusConfirmed;
  String get statusCompletedPlural;

  // Admin
  String get dashboard;
  String get statistics;
  String get reports;
  String get reportsAndStatistics;
  String get users;
  String get userManagement;
  String get usersNotFound;
  String get deleteUser;
  String deleteUserConfirm(String name);
  String get userDeleted;
  String get userActivated;
  String get blocked;
  String get blockUser;
  String get activateUser;
  String get admin;
  String get admins;

  // Stats
  String get totalOrders;
  String get totalRevenue;
  String get averageCheck;
  String get completionRate;

  // Actions
  String get save;
  String get cancel;
  String get delete;
  String get edit;
  String get add;
  String get search;
  String get filter;
  String get export;
  String get exportPDF;
  String get exportCSV;
  String get downloadPDF;
  String get downloadCSV;
  String get retry;
  String get refresh;
  String get fillAllFields;

  // Common
  String get yes;
  String get no;
  String get ok;
  String get loading;
  String get loadingData;
  String loadingError(String error);
  String get error;
  String errorMsg(String error);
  String get success;
  String get noData;
  String get changePeriod;

  // Language
  String get selectLanguage;
  String get kazakh;
  String get russian;
  String get language;

  // Schedule
  String get schedule;
  String get mySchedule;
  String get noOrdersForDay;

  // Reviews
  String get reviews;
  String get myReviews;
  String get reviewsManagement;
  String get noReviews;
  String loadingReviewsError(String error);
  String get leaveReview;
  String get cannotLeaveReview;
  String get thanksForReview;
  String get reviewDeleted;

  // Rating
  String get rating;

  // Photographer assignment
  String get noPhotographerAssigned;
  String get assignPhotographer;

  // Date range
  String get startDate;
  String get endDate;
  String get apply;
  String get reset;

  // Money
  String get total;
  String get tenge;

  // Files
  String get filesLink;
  String get uploadResults;
  String get completeOrder;
  String get startWork;
  String get addResultLink;
  String get addResultLinkPlaceholder;
  String get resultLinkHint;

  // Payments
  String get payments;
  String get photographerPayments;
  String get paymentsCalculation;
  String get viewPaymentsList;
  String get paymentPercentage;
  String get paymentPercentageHint;
  String get enterNumber1to100;
  String get percentage;

  // Reports
  String get reportDownloadStarted;
  String reportDownloadError(String error);

  // Onboarding
  String get onboardingEasyBooking;
  String get onboardingTrackStatus;
  String get onboardingGetResults;
  String get onboardingGetResultsDesc;
  String get next;
  String get getStarted;

  // Loading errors
  String loadingServicesError(String error);
  String loadingDataError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['kk', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      _getLocalization(locale),
    );
  }

  AppLocalizations _getLocalization(Locale locale) {
    switch (locale.languageCode) {
      case 'kk':
        return AppLocalizationsKk();
      case 'ru':
        return AppLocalizationsRu();
      default:
        return AppLocalizationsKk(); // Default to Kazakh
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
