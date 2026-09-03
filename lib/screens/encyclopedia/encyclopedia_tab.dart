import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/plant_category.dart';
import '../../providers/plant_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../plant_details/plant_details_screen.dart';

class EncyclopediaTab extends StatefulWidget {
  const EncyclopediaTab({super.key});

  @override
  State<EncyclopediaTab> createState() => _EncyclopediaTabState();
}

class _EncyclopediaTabState extends State<EncyclopediaTab> {
  int _selectedCategoryId = 0;

  void _showCategoryPlants(
      BuildContext context, PlantCategory category, AppSettingsProvider settings) {
    setState(() {
      _selectedCategoryId = category.categoryId;
    });

    final provider = Provider.of<PlantProvider>(context, listen: false);
    provider.setSelectedCategory(category.categoryId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: settings.isDarkMode ? AppTheme.darkBackground : AppTheme.backgroundSoft,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${settings.getText('قسم', 'Category')}: ${category.categoryName}',
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              category.description,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Consumer<PlantProvider>(
                builder: (context, plantProvider, child) {
                  final categoryPlants = plantProvider.plants.where((p) {
                    if (category.categoryId == 0) return true;
                    return p.categoryId == category.categoryId;
                  }).toList();

                  if (categoryPlants.isEmpty) {
                    return Center(
                      child: Text(
                        settings.getText(
                          'لا توجد نباتات مسجلة في هذا القسم بعد',
                          'No plants listed in this category yet',
                        ),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: categoryPlants.length,
                    itemBuilder: (context, index) {
                      final plant = categoryPlants[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.sleekShadow,
                          border: Border.all(
                            color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppTheme.mintSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.eco_rounded, color: AppTheme.primaryGreen),
                          ),
                          title: Text(
                            plant.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            plant.latinName,
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.primaryGreen),
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantDetailsScreen(plant: plant),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    final List<PlantCategory> categories = [
      PlantCategory(
          categoryId: 0,
          categoryName: settings.getText('الكل', 'All'),
          description: settings.getText('جميع أقسام النباتات', 'All plant categories'),
          plantsCount: 4),
      PlantCategory(
          categoryId: 1,
          categoryName: settings.getText('نباتات داخلية', 'Indoor Plants'),
          description: settings.getText('مناسبة للغرف والمكاتب', 'Suitable for rooms and offices'),
          plantsCount: 3),
      PlantCategory(
          categoryId: 2,
          categoryName: settings.getText('نباتات خارجية', 'Outdoor Plants'),
          description: settings.getText('للحدائق والبلكونات', 'For gardens and balconies'),
          plantsCount: 1),
      PlantCategory(
          categoryId: 3,
          categoryName: settings.getText('عصاريات وصبار', 'Succulents & Cacti'),
          description: settings.getText('تحتمل الجفاف', 'Drought tolerant'),
          plantsCount: 1),
      PlantCategory(
          categoryId: 4,
          categoryName: settings.getText('طبية وعطرية', 'Herbs & Aromatics'),
          description: settings.getText('نعناع ولافندر ورائحة زكية', 'Mint, lavender and fresh scent'),
          plantsCount: 2),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  settings.getText('موسوعة النباتات والأقسام', 'Plant Encyclopedia'),
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.sleekShadow,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                  ),
                ),
                child: TextField(
                  onChanged: (val) {
                    Provider.of<PlantProvider>(context, listen: false).setSearchQuery(val);
                  },
                  decoration: InputDecoration(
                    hintText: settings.getText(
                        'ابحث باسم القسم أو الفصيلة...', 'Search category or species...'),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryGreen),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text(
                settings.getText('تصفح النباتات حسب الفئة:', 'Browse Plants by Category:'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategoryId == category.categoryId;

                    return GestureDetector(
                      onTap: () => _showCategoryPlants(context, category, settings),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected ? AppTheme.activeShadow : AppTheme.sleekShadow,
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryGreen : const Color(0xFFF1F5F9).withValues(alpha: 0.5),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: AppTheme.mintSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.eco_rounded,
                                color: AppTheme.primaryGreen,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category.categoryName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              category.description,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
