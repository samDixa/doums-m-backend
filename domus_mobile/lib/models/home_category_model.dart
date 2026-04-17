class CategoryModel {
  final int id;
  final String title;
  final int sequence;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.title,
    required this.sequence,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      sequence: json['sequence'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

class SubCategoryModel {
  final int id;
  final int categoryId;
  final String title;
  final String icon;
  final int sequence;
  final bool isActive;

  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.icon,
    required this.sequence,
    required this.isActive,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      icon: json['icon'],
      sequence: json['sequence'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

class SubCategoryDetailModel extends SubCategoryModel {
  final List<dynamic> lectures;
  final List<dynamic> notes;
  final List<dynamic> tests;

  SubCategoryDetailModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.icon,
    required super.sequence,
    required super.isActive,
    required this.lectures,
    required this.notes,
    required this.tests,
  });

  factory SubCategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryDetailModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      icon: json['icon'],
      sequence: json['sequence'] ?? 0,
      isActive: json['is_active'] ?? true,
      lectures: json['lectures'] ?? [],
      notes: json['notes'] ?? [],
      tests: json['tests'] ?? [],
    );
  }
}
