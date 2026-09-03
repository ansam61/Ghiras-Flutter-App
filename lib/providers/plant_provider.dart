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
  final Set<int> _favoritePlantIds = {};
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
    _plants = [];
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

  // READ: Fetch Plants from REST API & SQL Server Database
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
          _plants = data.map((json) => Plant.fromJson(json)).toList();
          _isLiveApiConnected = true;
          _workingEndpoint = url;
          break;
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
