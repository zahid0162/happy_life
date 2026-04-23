import 'dart:convert';

class NotificationsResponse {
  final String status;
  final String message;
  final Data data;

  NotificationsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  final List<Notification> notifications;

  Data({required this.notifications});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      notifications: (json['notifications'] as List? ?? [])
          .map((notification) => Notification.fromJson(notification as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((notification) => notification.toJson()).toList(),
    };
  }
}

class Notification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String slug;
  final String notificationType;
  final String referenceId;
  final String status;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.slug,
    required this.notificationType,
    required this.referenceId,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      notificationType: json['notification_type'] as String? ?? '',
      referenceId: json['reference_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      version: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'slug': slug,
      'notification_type': notificationType,
      'reference_id': referenceId,
      'status': status,
      'is_read': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}