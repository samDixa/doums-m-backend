class CourseModel {
  final int id;
  final String title;
  final String? description;
  final String? subject;
  final String? level;
  final bool isPaid;
  final double? price;
  final bool isActive;
  final String? subtitle;
  final double? discountPercentage;
  final bool isNew;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? batchImage;
  final String? whatsappUrl;
  final String? infoUrl;
  final List<CourseModuleModel>? modules;
  final List<CourseTestModel>? tests;

  CourseModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.subject,
    this.level,
    required this.isPaid,
    this.price,
    this.discountPercentage,
    this.isNew = false,
    this.startDate,
    this.endDate,
    this.batchImage,
    this.whatsappUrl,
    this.infoUrl,
    required this.isActive,
    this.modules,
    this.tests,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      subject: json['subject'],
      level: json['level'],
      isPaid: json['is_paid'] ?? false,
      price: json['price']?.toDouble(),
      discountPercentage: json['discount_percentage']?.toDouble(),
      isNew: json['is_new'] ?? false,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      batchImage: json['batch_image'],
      whatsappUrl: json['whatsapp_url'],
      infoUrl: json['info_url'],
      isActive: json['is_active'] ?? true,
      modules: (json['modules'] as List?)
          ?.map((m) => CourseModuleModel.fromJson(m))
          .toList(),
      tests: (json['tests'] as List?)
          ?.map((t) => CourseTestModel.fromJson(t))
          .toList(),
    );
  }
}

class CourseModuleModel {
  final int id;
  final String title;
  final int sequence;
  final List<CourseLessonModel> lessons;

  CourseModuleModel({
    required this.id,
    required this.title,
    required this.sequence,
    required this.lessons,
  });

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) {
    return CourseModuleModel(
      id: json['id'],
      title: json['title'],
      sequence: json['sequence'],
      lessons: (json['lessons'] as List?)
              ?.map((l) => CourseLessonModel.fromJson(l))
              .toList() ??
          [],
    );
  }
}

class CourseLessonModel {
  final int id;
  final String title;
  final String lessonType;
  final String? contentUrl;
  final int? durationSeconds;
  final int sequence;
  final bool isPreview;

  CourseLessonModel({
    required this.id,
    required this.title,
    required this.lessonType,
    this.contentUrl,
    this.durationSeconds,
    required this.sequence,
    required this.isPreview,
  });

  factory CourseLessonModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonModel(
      id: json['id'],
      title: json['title'],
      lessonType: json['lesson_type'],
      contentUrl: json['content_url'],
      durationSeconds: json['duration_seconds'],
      sequence: json['sequence'],
      isPreview: json['is_preview'] ?? false,
    );
  }
}

class CourseTestModel {
  final int id;
  final String title;
  final int? durationSeconds;
  final int? totalMarks;
  final bool isActive;

  final bool isPaid;
  final double price;

  CourseTestModel({
    required this.id,
    required this.title,
    this.durationSeconds,
    this.totalMarks,
    required this.isActive,
    this.isPaid = false,
    this.price = 0,
  });

  factory CourseTestModel.fromJson(Map<String, dynamic> json) {
    return CourseTestModel(
      id: json['id'],
      title: json['title'],
      durationSeconds: json['duration_seconds'],
      totalMarks: json['total_marks'],
      isActive: json['is_active'] ?? true,
      isPaid: json['is_paid'] ?? false,
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}
