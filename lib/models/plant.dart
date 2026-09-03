class Plant {
  final int plantId;
  final String plantName;
  final String? scientificName;
  final String? imageUrl;
  final String? careInstructions;
  final String careAdvice;
  final int categoryId;
  final String? categoryName;
  final int wateringIntervalDays;
  final String sunlightRequirement;
  final String humidityRequirement;
  final String description;
  final DateTime lastWateredDate;
  final List<PlantImage>? images;

  Plant({
    required this.plantId,
    required this.plantName,
    this.scientificName,
    this.imageUrl,
    this.careInstructions,
    String? careAdvice,
    required this.categoryId,
    this.categoryName,
    int? wateringIntervalDays,
    String? sunlightRequirement,
    String? humidityRequirement,
    String? description,
    DateTime? lastWateredDate,
    this.images,
  })  : careAdvice = careAdvice ??
            careInstructions ??
            'امسح الأوراق بقطعة قماش مبللة وتجنب إغراق التربة بالماء.',
        wateringIntervalDays = wateringIntervalDays ?? 7,
        sunlightRequirement = sunlightRequirement ?? 'إضاءة غير مباشرة',
        humidityRequirement = humidityRequirement ?? '60% رطوبة معتدلة',
        description = description ?? careInstructions ?? 'نبات رائع يحتاج لرعاية منتظمة.',
        lastWateredDate = lastWateredDate ?? DateTime.now();

  // Convenient Getters for UI
  int get id => plantId;
  String get name => plantName;
  String get latinName => scientificName != null && scientificName!.isNotEmpty
      ? scientificName!
      : 'فصيلة زراعية مميزة';

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['plantId'] ?? json['id'] ?? 0,
      plantName: json['plantName'] ?? json['name'] ?? '',
      scientificName: json['scientificName'] ?? json['latinName'],
      imageUrl: json['imageUrl'],
      careInstructions: json['careInstructions'] ?? json['description'],
      careAdvice: json['careAdvice'] ?? json['careInstructions'],
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'],
      wateringIntervalDays: json['wateringIntervalDays'] ?? 7,
      sunlightRequirement: json['sunlightRequirement'],
      humidityRequirement: json['humidityRequirement'],
      description: json['description'] ?? json['careInstructions'],
      lastWateredDate: json['lastWateredDate'] != null
          ? DateTime.tryParse(json['lastWateredDate']) ?? DateTime.now()
          : DateTime.now(),
      images: json['images'] != null
          ? (json['images'] as List).map((i) => PlantImage.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'scientificName': scientificName,
      'imageUrl': imageUrl,
      'careInstructions': careInstructions,
      'careAdvice': careAdvice,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'wateringIntervalDays': wateringIntervalDays,
      'sunlightRequirement': sunlightRequirement,
      'humidityRequirement': humidityRequirement,
      'description': description,
      'lastWateredDate': lastWateredDate.toIso8601String(),
    };
  }
}

class PlantImage {
  final int imageId;
  final int plantId;
  final String imageUrl;
  final bool isPrimary;
  final DateTime uploadedAt;

  PlantImage({
    required this.imageId,
    required this.plantId,
    required this.imageUrl,
    required this.isPrimary,
    required this.uploadedAt,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      imageId: json['imageId'] ?? 0,
      plantId: json['plantId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isPrimary: json['isPrimary'] ?? true,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
