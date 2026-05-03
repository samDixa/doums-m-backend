class TestGroupModel {
  final int id;
  final String title;
  final int? parentId;
  final int? sequence;
  final bool isActive;
  final List<TestGroupModel>? children;
  final List<MockTestModel>? tests;

  TestGroupModel({
    required this.id,
    required this.title,
    this.parentId,
    this.sequence,
    required this.isActive,
    this.children,
    this.tests,
  });

  factory TestGroupModel.fromJson(Map<String, dynamic> json) {
    return TestGroupModel(
      id: json['id'],
      title: json['title'],
      parentId: json['parent_id'],
      sequence: json['sequence'],
      isActive: json['is_active'] ?? true,
      children: (json['children'] as List?)
          ?.map((c) => TestGroupModel.fromJson(c))
          .toList(),
      tests: (json['tests'] as List?)
          ?.map((t) => MockTestModel.fromJson(t))
          .toList(),
    );
  }
}

class MockTestModel {
  final int id;
  final String title;
  final int? totalMarks;
  final int? negativeMarks;
  final int? positiveMarks;
  final int? durationSeconds;
  final String? testImage;
  final String? lastAttemptDate;
  final int? attemptsCount;
  final bool isNew;

  final bool isPaid;
  final double price;

  MockTestModel({
    required this.id,
    required this.title,
    this.totalMarks,
    this.negativeMarks,
    this.positiveMarks,
    this.durationSeconds,
    this.testImage,
    this.lastAttemptDate,
    this.attemptsCount,
    this.isNew = false,
    this.isPaid = false,
    this.price = 0,
  });

  factory MockTestModel.fromJson(Map<String, dynamic> json) {
    return MockTestModel(
      id: json['id'],
      title: json['title'],
      totalMarks: json['total_marks'],
      negativeMarks: json['negative_marks'],
      positiveMarks: json['positive_marks'],
      durationSeconds: json['duration_seconds'],
      testImage: json['test_image'],
      lastAttemptDate: json['last_attempt_date'],
      attemptsCount: json['attempts_count'],
      isNew: json['is_new'] ?? false,
      isPaid: json['is_paid'] ?? false,
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}
