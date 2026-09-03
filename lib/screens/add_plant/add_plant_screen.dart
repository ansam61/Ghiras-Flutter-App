import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/plant.dart';
import '../../providers/plant_provider.dart';
import '../../providers/app_settings_provider.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _nameController = TextEditingController();
  final _latinController = TextEditingController();
  int _selectedCategoryId = 1;
  double _wateringDays = 7;
  bool _isSubmitting = false;
  File? _selectedImageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedImageFile = File(picked.path);
        });
      }
    } catch (_) {}
  }

  void _showImageSourcePicker(AppSettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              settings.getText('اختيار صورة النبتة', 'Select Plant Photo'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppTheme.mintSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppTheme.primaryGreen),
              ),
              title: Text(
                settings.getText('التقاط صورة فورية بالكاميرا', 'Take Instant Photo'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                settings.getText('استخدم كاميرا الجهاز للالتقاط الحاد', 'Use device camera'),
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppTheme.mintSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library_rounded,
                    color: AppTheme.primaryGreen),
              ),
              title: Text(
                settings.getText('اختيار صورة من المعرض', 'Choose from Gallery'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                settings.getText('تصفح صور جهازك المحفوظة', 'Browse device gallery'),
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _savePlant(AppSettingsProvider settings) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(settings.getText(
              'يرجى كتابة اسم النبتة أولاً', 'Please enter plant name first')),
          backgroundColor: AppTheme.alertRedText,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final newPlant = Plant(
      plantId: 0,
      plantName: name,
      scientificName: _latinController.text.trim().isEmpty
          ? settings.getText('فصيلة زراعية أليفة', 'Domestic species')
          : _latinController.text.trim(),
      categoryId: _selectedCategoryId,
      categoryName: _getCategoryName(_selectedCategoryId, settings),
      wateringIntervalDays: _wateringDays.round(),
      sunlightRequirement: settings.getText('إضاءة معتدلة غير مباشرة', 'Moderate indirect light'),
      humidityRequirement: settings.getText('رطوبة مناسبة 60%', '60% humidity'),
      description: settings.getText('نبات رائع أضيف لروتين حديقتك اليومي.', 'Added to your daily plant routine.'),
      careAdvice: settings.getText(
          'امسح الأوراق بقطعة قماش مبللة مرتين شهرياً وتأكد من جفاف التربة قبل الري.',
          'Wipe leaves twice monthly and ensure soil surface is dry before watering.'),
      imageUrl: _selectedImageFile != null
          ? _selectedImageFile!.path
          : 'https://images.unsplash.com/photo-1597055181300-e3633a917c9c',
      lastWateredDate: DateTime.now(),
    );

    final success =
        await Provider.of<PlantProvider>(context, listen: false).addPlant(newPlant);

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(settings.getText(
                'تمت إضافة "$name" إلى روتين حديقتك بنجاح',
                'Successfully added "$name" to your garden routine')),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  String _getCategoryName(int id, AppSettingsProvider settings) {
    switch (id) {
      case 1:
        return settings.getText('نباتات داخلية', 'Indoor Plants');
      case 2:
        return settings.getText('نباتات خارجية', 'Outdoor Plants');
      case 3:
        return settings.getText('عصاريات وصبار', 'Succulents & Cacti');
      case 4:
        return settings.getText('طبية وعطرية', 'Herbs & Aromatics');
      default:
        return settings.getText('قسم عام', 'General');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    final List<Map<String, dynamic>> categories = [
      {'id': 1, 'name': settings.getText('نباتات داخلية', 'Indoor Plants')},
      {'id': 2, 'name': settings.getText('نباتات خارجية', 'Outdoor Plants')},
      {'id': 3, 'name': settings.getText('عصاريات وصبار', 'Succulents & Cacti')},
      {'id': 4, 'name': settings.getText('طبية وعطرية', 'Herbs & Aromatics')},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getText('إضافة نبتة جديدة', 'Add New Plant')),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Selection Picker Card (Camera or Gallery)
              GestureDetector(
                onTap: () => _showImageSourcePicker(settings),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: settings.isDarkMode
                        ? AppTheme.darkCard
                        : AppTheme.mintSoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: _selectedImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                _selectedImageFile!,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImageFile = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                color: AppTheme.primaryGreen,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              settings.getText(
                                'إضافة صورة من الجهاز أو الالتقاط بالكاميرا',
                                'Add photo from device or take instant picture',
                              ),
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                settings.getText('بيانات النبتة الأساسية', 'Basic Plant Info'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Name Field (Required)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: settings.getText('اسم النبتة (مطلوب)', 'Plant Name (Required)'),
                  hintText: settings.getText('مثلاً: البوتس الذهبي في الصالة', 'e.g. Living Room Pothos'),
                  prefixIcon: const Icon(Icons.eco_outlined, color: AppTheme.primaryGreen),
                ),
              ),
              const SizedBox(height: 14),

              // Dropdown Category Selector
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: settings.getText('تصنيف النبتة', 'Category'),
                  prefixIcon: const Icon(Icons.category_outlined, color: AppTheme.primaryGreen),
                ),
                items: categories
                    .map((c) => DropdownMenuItem<int>(
                          value: c['id'],
                          child: Text(c['name']),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategoryId = val);
                  }
                },
              ),
              const SizedBox(height: 14),

              // Scientific Name (Optional)
              TextField(
                controller: _latinController,
                decoration: InputDecoration(
                  labelText: settings.getText('الاسم العلمي (اختياري)', 'Scientific Name (Optional)'),
                  hintText: settings.getText('مثلاً: Epipremnum aureum', 'e.g. Epipremnum aureum'),
                  prefixIcon: const Icon(Icons.science_outlined, color: AppTheme.primaryGreen),
                ),
              ),
              const SizedBox(height: 24),

              // Watering Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settings.getText('دورية الري المستهدفة:', 'Watering Frequency:'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${settings.getText('كل', 'Every')} ${_wateringDays.round()} ${settings.getText('أيام', 'days')}',
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _wateringDays,
                min: 1,
                max: 30,
                divisions: 29,
                activeColor: AppTheme.primaryGreen,
                onChanged: (val) {
                  setState(() => _wateringDays = val);
                },
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _savePlant(settings),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(settings.getText('إضافة النبتة لروتين حديقتك', 'Add Plant to Garden Routine')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
