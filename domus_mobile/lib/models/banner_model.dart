class BannerModel {
  final int id;
  final String imageUrl;
  final String? navigationTarget;
  final Map<String, dynamic> navigationArgs;
  final int sequence;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.navigationTarget,
    this.navigationArgs = const {},
    required this.sequence,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      imageUrl: json['image_url'],
      navigationTarget: json['navigation_target'],
      navigationArgs: Map<String, dynamic>.from(json['navigation_args'] ?? {}),
      sequence: json['sequence'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}
