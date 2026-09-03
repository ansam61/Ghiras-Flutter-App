import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantProvider extends ChangeNotifier {
  // Candidate API endpoints for Windows Desktop, Web & Android Emulator
  static final List<String> _apiEndpoints = [
    'http://localhost:5250/api/plants',
    'http://10.0.2.2:5250/api/plants',
    'https://localhost:7267/api/plants',
    'https://10.0.2.2:7267/api/plants',
  ];

  String? _workingEndpoint;

  List<Plant> _plants = [];
  final Set<int> _favoritePlantIds = {1, 2};
  bool _isLoading = false;
  bool _isLiveApiConnected = false;
  String _searchQuery = '';
  int _selectedCategoryId = 0; // 0: الكل

  List<Plant> get plants => _plants;
  Set<int> get favoritePlantIds => _favoritePlantIds;
  bool get isLoading => _isLoading;
  bool get isLiveApiConnected => _isLiveApiConnected;
  String get searchQuery => _searchQuery;
  int get selectedCategoryId => _selectedCategoryId;

  // Filtered Plants based on Search Query & Category
  List<Plant> get filteredPlants {
    return _plants.where((plant) {
      final matchesSearch = _searchQuery.isEmpty ||
          plant.name.contains(_searchQuery) ||
          plant.latinName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryId == 0 ||
          plant.categoryId == _selectedCategoryId;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Favorite Plants List
  List<Plant> get favoritePlants {
    return _plants.where((plant) => _favoritePlantIds.contains(plant.id)).toList();
  }

  PlantProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _plants = [
      Plant(
        plantId: 1,
        plantName: 'البوتس الذهبي',
        scientificName: 'Epipremnum aureum',
        categoryId: 1,
        categoryName: 'نباتات داخلية',
        wateringIntervalDays: 3,
        sunlightRequirement: 'إضاءة متوسطة غير مباشرة',
        humidityRequirement: '60% رطوبة معتدلة',
        imageUrl: 'https://images.unsplash.com/photo-1597055181300-e3633a917c9c',
        description: 'نبات زينة داخلي رائع يمتص السموم وينقي هواء الغرفة بسهولة.',
        careAdvice: 'امسح الأوراق بقطعة قماش مبللة مرتين شهرياً لتنقية الهواء، وتجنب بقاء الماء ركوداً في الصحن الملحق.',
        lastWateredDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Plant(
        plantId: 2,
        plantName: 'جلد النمر (سانسيفيريا)',
        scientificName: 'Sansevieria trifasciata',
        categoryId: 1,
        categoryName: 'نباتات داخلية',
        wateringIntervalDays: 14,
        sunlightRequirement: 'تحمل الإضاءة المنخفضة والعالية',
        humidityRequirement: 'رطوبة منخفضة (40%)',
        imageUrl: 'https://images.unsplash.com/photo-1599598425947-03064377754d',
        description: 'نبات قوي جداً ومقاوم للجفاف ينتج الأكسجين ليلاً بشكل ممتاز.',
        careAdvice: 'اروهِ فقط عند جفاف التربة تماماً (كل 14 يوم)، وتجنب صب الماء في قلب أوراق النبتة لمنع التعفن.',
        lastWateredDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Plant(
        plantId: 3,
        plantName: 'صبار الألوفيرا الطبي',
        scientificName: 'Aloe vera',
        categoryId: 3,
        categoryName: 'عصاريات وصبار',
        wateringIntervalDays: 10,
        sunlightRequirement: 'شمس مباشرة وساطعة',
        humidityRequirement: 'رطوبة جافة وجيدة التهوية',
        imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921',
        description: 'نبات عصاري طبي مفيد لترطيب البشرة وعلاج الحروق البسيطة.',
        careAdvice: 'ضعه في مكان مشمس جيد التهوية، واستخدم تربة مخصصة للصبار عالية التصريف للماء.',
        lastWateredDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Plant(
        plantId: 4,
        plantName: 'مونستيرا داليشيوسا',
        scientificName: 'Monstera deliciosa',
        categoryId: 1,
        categoryName: 'نباتات داخلية',
        wateringIntervalDays: 7,
        sunlightRequirement: 'إضاءة ساطعة غير مباشرة',
        humidityRequirement: 'رطوبة عالية (70%)',
        imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b',
        description: 'نبات القفص الصدري ذو الأوراق المفرغة الجذابة للمنازل الحديثة.',
        careAdvice: 'رش الأوراق برذاذ خفيف من الماء أسبوعياً لرفع الرطوبة، وزودها بدعامة خشبية لدعم تسلق الأوراق.',
        lastWateredDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    fetchPlants();
  }

  // Setters for Search & Category Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  // READ: Fetch Plants from REST API with Fallback & Dynamic Host Detection
  Future<void> fetchPlants() async {
    _isLoading = true;
    notifyListeners();

    for (final url in _apiEndpoints) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            _plants = data.map((json) => Plant.fromJson(json)).toList();
            _isLiveApiConnected = true;
            _workingEndpoint = url;
            break;
          }
        }
      } catch (_) {
        continue;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE: Add Plant to API & SQL Server Database
  Future<bool> addPlant(Plant newPlant) async {
    _isLoading = true;
    notifyListeners();

    final targetUrl = _workingEndpoint ?? _apiEndpoints.first;

    try {
      final response = await http.post(
        Uri.parse(targetUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newPlant.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final createdJson = jsonDecode(response.body);
        _plants.insert(0, Plant.fromJson(createdJson));
        _isLiveApiConnected = true;
      } else {
        _addLocalPlant(newPlant);
      }
    } catch (_) {
      _addLocalPlant(newPlant);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return true;
  }

  void _addLocalPlant(Plant newPlant) {
    final localPlant = Plant(
      plantId: DateTime.now().millisecondsSinceEpoch,
      plantName: newPlant.name,
      scientificName: newPlant.latinName,
      categoryId: newPlant.categoryId,
      categoryName: newPlant.categoryName,
      wateringIntervalDays: newPlant.wateringIntervalDays,
      sunlightRequirement: newPlant.sunlightRequirement,
      humidityRequirement: newPlant.humidityRequirement,
      imageUrl: newPlant.imageUrl,
      description: newPlant.description,
      lastWateredDate: DateTime.now(),
    );
    _plants.insert(0, localPlant);
  }

  // UPDATE: Edit Plant
  Future<bool> updatePlant(Plant updatedPlant) async {
    final index = _plants.indexWhere((p) => p.id == updatedPlant.id);
    if (index != -1) {
      _plants[index] = updatedPlant;
      notifyListeners();

      final targetUrl = _workingEndpoint ?? _apiEndpoints.first;
      try {
        await http.put(
          Uri.parse('$targetUrl/${updatedPlant.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updatedPlant.toJson()),
        );
      } catch (_) {}
      return true;
    }
    return false;
  }

  // DELETE: Delete Plant from API & State
  Future<bool> deletePlant(int plantId) async {
    _plants.removeWhere((p) => p.id == plantId);
    _favoritePlantIds.remove(plantId);
    notifyListeners();

    final targetUrl = _workingEndpoint ?? _apiEndpoints.first;
    try {
      await http.delete(Uri.parse('$targetUrl/$plantId'));
    } catch (_) {}

    return true;
  }

  // ACTION: Water Plant Now
  void waterPlant(int plantId) {
    final index = _plants.indexWhere((p) => p.id == plantId);
    if (index != -1) {
      final plant = _plants[index];
      _plants[index] = Plant(
        plantId: plant.id,
        plantName: plant.name,
        scientificName: plant.latinName,
        categoryId: plant.categoryId,
        categoryName: plant.categoryName,
        wateringIntervalDays: plant.wateringIntervalDays,
        sunlightRequirement: plant.sunlightRequirement,
        humidityRequirement: plant.humidityRequirement,
        imageUrl: plant.imageUrl,
        description: plant.description,
        lastWateredDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // ACTION: Toggle Favorite State
  void toggleFavorite(int plantId) {
    if (_favoritePlantIds.contains(plantId)) {
      _favoritePlantIds.remove(plantId);
    } else {
      _favoritePlantIds.add(plantId);
    }
    notifyListeners();
  }

  bool isFavorite(int plantId) {
    return _favoritePlantIds.contains(plantId);
  }
}
