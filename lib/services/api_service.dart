import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';
import '../models/plant_category.dart';
import '../models/ai_diagnosis.dart';

class ApiService {
  // Dynamic Host Base URLs for Windows Desktop, Chrome & Android Emulator
  static final List<String> baseUrls = [
    'http://localhost:5250/api',
    'http://10.0.2.2:5250/api',
    'https://localhost:7267/api',
    'https://10.0.2.2:7267/api',
  ];

  static Future<List<Plant>> getPlants() async {
    for (final base in baseUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/Plants'))
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final List jsonList = json.decode(response.body);
          return jsonList.map((e) => Plant.fromJson(e)).toList();
        }
      } catch (_) {}
    }

    // Fallback empty list if offline
    return [];
  }

  static Future<List<PlantCategory>> getCategories() async {
    for (final base in baseUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/PlantCategory'))
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final List jsonList = json.decode(response.body);
          return jsonList.map((e) => PlantCategory.fromJson(e)).toList();
        }
      } catch (_) {}
    }

    return [
      PlantCategory(
          categoryId: 1,
          categoryName: 'نباتات زينة داخلية',
          description: 'نباتات مخصصة للزينة الداخلية والمنازل',
          createdAt: DateTime.now(),
          plantsCount: 0),
      PlantCategory(
          categoryId: 2,
          categoryName: 'نباتات ظلية',
          description: 'نباتات تناسب المساحات المغلقة',
          createdAt: DateTime.now(),
          plantsCount: 0),
      PlantCategory(
          categoryId: 3,
          categoryName: 'أعشاب ونباتات طبية',
          description: 'نباتات تُستخدم في الطهي أو التداوي والاستخدامات العطرية',
          createdAt: DateTime.now(),
          plantsCount: 0),
      PlantCategory(
          categoryId: 4,
          categoryName: 'خضروات وفواكه',
          description: 'نباتات إنتاجية ذات ثمار ونفع غذائي',
          createdAt: DateTime.now(),
          plantsCount: 0),
      PlantCategory(
          categoryId: 5,
          categoryName: 'عصاريات وصبارات',
          description: 'نباتات متحملة للجفاف وتحتمل قلة الري',
          createdAt: DateTime.now(),
          plantsCount: 0),
      PlantCategory(
          categoryId: 6,
          categoryName: 'نباتات مائية',
          description: 'نباتات تنمو وتعيش في البيئة المائية',
          createdAt: DateTime.now(),
          plantsCount: 0),
    ];
  }

  static Future<List<AIDiagnosis>> getDiagnoses() async {
    for (final base in baseUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/AIDiagnosis'))
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final List jsonList = json.decode(response.body);
          return jsonList.map((e) => AIDiagnosis.fromJson(e)).toList();
        }
      } catch (_) {}
    }

    return [
      AIDiagnosis(
        diagnosisId: 1,
        plantName: 'نبتة البوتس الذهبي',
        sampleImageUrl: '',
        diseaseName: 'عفن الجذور الفطري',
        confidenceRate: 96.0,
        organicTreatment:
            'إيقاف الري فوراً لمدة 5 أيام، ونقل الوعاء لمنطقة جيدة التهوية بعيدة عن الشمس الحارة.',
        diagnosisDate: DateTime.now().subtract(const Duration(days: 1)),
      )
    ];
  }
}
