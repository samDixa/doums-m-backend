class ArticleModel {
  final int id;
  final String title;
  final String content;
  final bool isPublished;
  final bool isClinicalCase;
  final DateTime createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isPublished,
    required this.isClinicalCase,
    required this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isPublished: json['is_published'] ?? false,
      isClinicalCase: json['is_clinical_case'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
