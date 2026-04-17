class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isGlobal;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isGlobal,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'in_app',
      isGlobal: json['is_global'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
