class NotificationModel {
  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.readAt,
    required this.raw,
  });

  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, dynamic> raw;

  bool get isUnread => readAt == null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'];
    final data =
        payload is Map<String, dynamic> ? payload : <String, dynamic>{};

    final type = json['type']?.toString() ?? data['type']?.toString() ?? '';
    final message = data['message']?.toString() ??
        json['message']?.toString() ??
        json['description']?.toString() ??
        json['body']?.toString() ??
        json['content']?.toString() ??
        '';

    final createdAt = DateTime.tryParse(json['created_at']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final readAt = DateTime.tryParse(json['read_at']?.toString() ?? '');

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: type,
      title: _resolveTitle(type, data, json),
      message: message,
      createdAt: createdAt,
      readAt: readAt,
      raw: json,
    );
  }

  static String _resolveTitle(
    String type,
    Map<String, dynamic> data,
    Map<String, dynamic> json,
  ) {
    final explicitTitle = json['title']?.toString() ??
        json['notification_title']?.toString() ??
        json['subject']?.toString() ??
        data['title']?.toString();
    if (explicitTitle != null && explicitTitle.trim().isNotEmpty) {
      return explicitTitle;
    }

    final dataType = data['type']?.toString();
    if (dataType == 'otp_code') {
      return 'OTP Code Generated';
    }
    if (dataType == 'welcome_email') {
      return 'Welcome to Pamtech';
    }

    final normalized = type.toLowerCase();
    if (normalized.contains('sendotp')) {
      return 'OTP Code Generated';
    }
    if (normalized.contains('welcome')) {
      return 'Welcome to Pamtech';
    }
    return 'Notification';
  }
}
