class PlantCategory {
  final int categoryId;
  final String categoryName;
  final String description;
  final DateTime createdAt;
  final int plantsCount;

  PlantCategory({
    required this.categoryId,
    required this.categoryName,
    String? description,
    DateTime? createdAt,
    this.plantsCount = 0,
  })  : description = description ?? 'قسم زراعي مخصص',
        createdAt = createdAt ?? DateTime.now();

  factory PlantCategory.fromJson(Map<String, dynamic> json) {
    return PlantCategory(
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? 'قسم زراعي مخصص',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      plantsCount: json['plantsCount'] ?? 0,
    );
  }
}
