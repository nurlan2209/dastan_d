class ClientInfo {
  final String? name;
  final String? phone;
  final String? email;

  ClientInfo({this.name, this.phone, this.email});
}

class PhotographerInfo {
  final String? name;
  final double? rating;

  PhotographerInfo({this.name, this.rating});
}

class Order {
  final String id;
  final String clientId;
  final String? photographerId;
  final String service;
  final DateTime date;
  final String location;
  final String status;
  final double price;
  final String? result;
  final String? comment;

  // Поля, которые "подгружаются" с бэкенда через .populate()
  final String? clientName;
  final String? photographerName;
  final String? clientPhone;
  final String? clientEmail;
  final String? photographerEmail;
  final double? photographerRating;

  Order({
    required this.id,
    required this.clientId,
    this.photographerId,
    required this.service,
    required this.date,
    required this.location,
    required this.status,
    required this.price,
    this.result,
    this.comment,
    this.clientName,
    this.photographerName,
    this.clientPhone,
    this.clientEmail,
    this.photographerEmail,
    this.photographerRating,
  });

  // Добавляем геттеры для совместимости с кодом
  ClientInfo? get client {
    if (clientName == null) return null;
    return ClientInfo(name: clientName, phone: clientPhone, email: clientEmail);
  }

  PhotographerInfo? get photographer {
    if (photographerName == null) return null;
    return PhotographerInfo(name: photographerName, rating: photographerRating);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    // Функция-помощник для безопасного извлечения ID
    String? extractId(dynamic field) {
      if (field == null) return null;
      if (field is String) return field;
      if (field is Map) return field['_id'];
      return null;
    }

    // Функция-помощник для безопасного извлечения Имени
    String? extractName(dynamic field) {
      if (field == null) return null;
      if (field is Map) return field['fullName'] ?? field['name'];
      return null;
    }

    // Функция-помощник для безопасного извлечения Телефона
    String? extractPhone(dynamic field) {
      if (field == null) return null;
      if (field is Map) return field['phoneNumber'] ?? field['phone'];
      return null;
    }

    // Функция-помощник для безопасного извлечения Email
    String? extractEmail(dynamic field) {
      if (field == null) return null;
      if (field is Map) return field['email'];
      return null;
    }

    // Функция-помощник для безопасного извлечения Рейтинга
    double? extractRating(dynamic field) {
      if (field == null) return null;
      if (field is Map) return (field['rating'] as num?)?.toDouble();
      return null;
    }

    return Order(
      id: json['_id'],
      clientId: extractId(json['clientId'])!,
      photographerId: extractId(json['photographerId']),
      service: json['service'] ?? 'Услуга не указана',
      date: DateTime.parse(json['date']),
      location: json['location'] ?? 'Место не указано',
      status: json['status'] ?? 'pending',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      result: json['result'],
      comment: json['comment'],

      // Присваиваем "подгруженные" данные
      clientName: extractName(json['clientId']),
      photographerName: extractName(json['photographerId']),
      clientPhone: extractPhone(json['clientId']),
      clientEmail: extractEmail(json['clientId']),
      photographerEmail: extractEmail(json['photographerId']),
      photographerRating: extractRating(json['photographerId']),
    );
  }
}
