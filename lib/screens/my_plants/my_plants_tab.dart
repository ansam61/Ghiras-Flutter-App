import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/plant_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../models/plant.dart';
import '../plant_details/plant_details_screen.dart';
import '../add_plant/add_plant_screen.dart';

class MyPlantsTab extends StatefulWidget {
  const MyPlantsTab({super.key});

  @override
  State<MyPlantsTab> createState() => _MyPlantsTabState();
}

class _MyPlantsTabState extends State<MyPlantsTab> {
  final _searchController = TextEditingController();

  void _showDeleteConfirmation(
      BuildContext context, Plant plant, AppSettingsProvider settings) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.alertRedText),
            const SizedBox(width: 10),
            Text(settings.getText('حذف النبتة', 'Delete Plant')),
          ],
        ),
        content: Text(
          settings.getText(
            'هل أنت تأكد من رغبتك في حذف نبتة "${plant.name}" من حديقتك؟',
            'Are you sure you want to delete "${plant.name}" from your garden?',
          ),
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(settings.getText('إلغاء', 'Cancel'),
                style: const TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertRedText,
            ),
            onPressed: () {
              Provider.of<PlantProvider>(context, listen: false)
                  .deletePlant(plant.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(settings.getText(
                      'تم حذف "${plant.name}" بنجاح',
                      'Successfully deleted "${plant.name}"')),
                  backgroundColor: AppTheme.alertRedText,
                ),
              );
            },
            child: Text(settings.getText('حذف الآن', 'Delete Now')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getText('حديقتي ونباتاتي', 'My Garden & Plants')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.primaryGreen, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPlantScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<PlantProvider>(
          builder: (context, plantProvider, child) {
            return RefreshIndicator(
              onRefresh: () => plantProvider.fetchPlants(),
              color: AppTheme.primaryGreen,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: settings.isDarkMode
                            ? AppTheme.darkCard
                            : AppTheme.mintSoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fiber_manual_record_rounded,
                            size: 10,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            settings.getText(
                              'حديقتك الخضراء بخير • رعاية يومية مخصصة',
                              'Your garden is thriving • Personalized care',
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Filter Bar
                    Container(
                      decoration: BoxDecoration(
                        color: settings.isDarkMode
                            ? AppTheme.darkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.sleekShadow,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => plantProvider.setSearchQuery(val),
                        decoration: InputDecoration(
                          hintText: settings.getText(
                              'ابحث باسم النبتة في حديقتك...',
                              'Search plant name...'),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppTheme.primaryGreen),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories Chips Bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _categoryChip(
                              0, settings.getText('الكل', 'All'), plantProvider),
                          _categoryChip(
                              1,
                              settings.getText('داخلي', 'Indoor'),
                              plantProvider),
                          _categoryChip(
                              2,
                              settings.getText('خارجي', 'Outdoor'),
                              plantProvider),
                          _categoryChip(
                              3,
                              settings.getText('عصاريات', 'Succulents'),
                              plantProvider),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plants Grid View
                    Expanded(
                      child: plantProvider.filteredPlants.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.mintSoft,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.local_florist_rounded,
                                      color: AppTheme.primaryGreen,
                                      size: 38,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    settings.getText(
                                      'حديقتك فارغة، أضف نبتتك الأولى الآن',
                                      'Your garden is empty, add your first plant',
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    settings.getText(
                                      'اختر الاسم والتصنيف وسيتم الحفظ في قاعدة البيانات فوراً.',
                                      'Choose name and category to save directly to the database.',
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const AddPlantScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add_rounded, size: 20),
                                    label: Text(
                                      settings.getText(
                                          'إضافة نبتة جديدة', 'Add New Plant'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.92,
                              ),
                              itemCount: plantProvider.filteredPlants.length,
                              itemBuilder: (context, index) {
                                final plant =
                                    plantProvider.filteredPlants[index];
                                final isFav =
                                    plantProvider.isFavorite(plant.id);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PlantDetailsScreen(plant: plant),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: settings.isDarkMode
                                          ? AppTheme.darkCard
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: AppTheme.sleekShadow,
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0)
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 75,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppTheme.mintSoft,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.eco_rounded,
                                                color: AppTheme.primaryGreen,
                                                size: 38,
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () => plantProvider
                                                    .toggleFavorite(plant.id),
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    isFav
                                                        ? Icons.favorite_rounded
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    color: isFav
                                                        ? AppTheme.alertRedText
                                                        : AppTheme.textMuted,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              left: 4,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _showDeleteConfirmation(
                                                        context,
                                                        plant,
                                                        settings),
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete_outline_rounded,
                                                    color: AppTheme.alertRedText,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          plant.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          plant.latinName,
                                          style: const TextStyle(
                                            color: AppTheme.textMuted,
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.water_drop_outlined,
                                                    size: 13,
                                                    color: AppTheme.primaryGreen),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${plant.wateringIntervalDays}د',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                plantProvider
                                                    .waterPlant(plant.id);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(settings.getText(
                                                        'تم تسجيل ري "${plant.name}"',
                                                        'Watering recorded for "${plant.name}"')),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                settings.getText('ري', 'Water'),
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _categoryChip(
      int categoryId, String label, PlantProvider plantProvider) {
    final isSelected = plantProvider.selectedCategoryId == categoryId;
    return GestureDetector(
      onTap: () => plantProvider.setSelectedCategory(categoryId),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
