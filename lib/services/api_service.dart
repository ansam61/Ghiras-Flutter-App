import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';
import '../models/plant_category.dart';
import '../models/ai_diagnosis.dart';

class ApiService {
  // Base URLs for Windows Localhost, Android Emulator, and Web API
  static const String baseUrl = 'https://localhost:7267/api';

  static Future<List<Plant>> getPlants() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/Plants'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        return jsonList.map((e) => Plant.fromJson(e)).toList();
      }
    } catch (_) {}

    // Fallback Mock Data matching Adobe XD designs
    return [
      Plant(
        plantId: 1,
        plantName: 'نبتة البوتس الذهبي',
        scientificName: 'Epipremnum aureum',
        categoryId: 1,
        categoryName: 'نباتات داخلية',
        careInstructions:
            'الري عند جفاف التربة السطحية (كل 7 أيام)، وإبعادها عن الشمس المباشرة.',
      ),
      Plant(
        plantId: 2,
        plantName: 'شجرة الزيتون',
        scientificName: 'Olea europaea',
        categoryId: 2,
        categoryName: 'نباتات خارجية',
        careInstructions: 'تحتاج إضاءة شمس مباشرة وري معتدل كل 4 أيام.',
      ),
      Plant(
        plantId: 3,
        plantName: 'صبار الألوفيرا',
        scientificName: 'Aloe vera',
        categoryId: 3,
        categoryName: 'عصاريات وصبار',
        careInstructions: 'ري خفيف جداً كل 14 يوماً مع ضوء غير مباشر.',
      ),
    ];
  }

  static Future<List<PlantCategory>> getCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/PlantCategory'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        return jsonList.map((e) => PlantCategory.fromJson(e)).toList();
      }
    } catch (_) {}

    return [
      PlantCategory(
          categoryId: 1,
          categoryName: 'نباتات داخلية',
          createdAt: DateTime.now(),
          plantsCount: 12),
      PlantCategory(
          categoryId: 2,
          categoryName: 'نباتات خارجية',
          createdAt: DateTime.now(),
          plantsCount: 8),
      PlantCategory(
          categoryId: 3,
          categoryName: 'عصاريات وصبار',
          createdAt: DateTime.now(),
          plantsCount: 15),
      PlantCategory(
          categoryId: 4,
          categoryName: 'طبية وعطرية',
          createdAt: DateTime.now(),
          plantsCount: 6),
      PlantCategory(
          categoryId: 5,
          categoryName: 'متسلقات وزينة',
          createdAt: DateTime.now(),
          plantsCount: 9),
      PlantCategory(
          categoryId: 6,
          categoryName: 'أشجار مثمرة',
          createdAt: DateTime.now(),
          plantsCount: 4),
    ];
  }

  static Future<List<AIDiagnosis>> getDiagnoses() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/AIDiagnosis'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        return jsonList.map((e) => AIDiagnosis.fromJson(e)).toList();
      }
    } catch (_) {}

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
