import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/plant.dart';
import '../../providers/plant_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/care_calendar_widget.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;
  const PlantDetailsScreen({super.key, required this.plant});

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  late DateTime _scheduledWateringDate;

  @override
  void initState() {
    super.initState();
    _scheduledWateringDate = widget.plant.lastWateredDate
        .add(Duration(days: widget.plant.wateringIntervalDays));
  }

  void _confirmDelete(BuildContext context, AppSettingsProvider settings) {
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
            'هل أنت متأكد من رغبتك في حذف نبتة "${widget.plant.name}" من حديقتك؟',
            'Are you sure you want to delete "${widget.plant.name}" from your garden?',
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
            onPressed: () async {
              await Provider.of<PlantProvider>(context, listen: false)
                  .deletePlant(widget.plant.id);
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(settings.getText(
                        'تم إزالة "${widget.plant.name}" من حديقتك',
                        'Removed "${widget.plant.name}" from your garden')),
                    backgroundColor: AppTheme.alertRedText,
                  ),
                );
              }
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

    return Consumer<PlantProvider>(
      builder: (context, provider, child) {
        final isFav = provider.isFavorite(widget.plant.id);
        final currentPlant = provider.plants.firstWhere(
          (p) => p.id == widget.plant.id,
          orElse: () => widget.plant,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppTheme.mintSoft,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: AppTheme.primaryGreen),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav
                          ? AppTheme.alertRedText
                          : AppTheme.primaryGreen,
                    ),
                    onPressed: () => provider.toggleFavorite(widget.plant.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppTheme.alertRedText),
                    onPressed: () => _confirmDelete(context, settings),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.sleekShadow,
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: AppTheme.primaryGreen,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPlant.name,
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentPlant.latinName,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${settings.getText('التصنيف', 'Category')}: ${currentPlant.categoryName} • ${settings.getText('رعاية مخصصة ومزامنة يومية', 'Personalized care & daily sync')}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          _metricCard(
                              settings.getText('مستوى الري', 'Water Level'),
                              '${settings.getText('كل', 'Every')} ${currentPlant.wateringIntervalDays} ${settings.getText('أيام', 'days')}',
                              Icons.water_drop_outlined,
                              settings),
                          const SizedBox(width: 10),
                          _metricCard(
                              settings.getText('مستوى الضوء', 'Light Level'),
                              currentPlant.sunlightRequirement,
                              Icons.wb_sunny_outlined,
                              settings),
                          const SizedBox(width: 10),
                          _metricCard(
                              settings.getText('الرطوبة', 'Humidity'),
                              currentPlant.humidityRequirement,
                              Icons.thermostat_outlined,
                              settings),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Interactive Watering Schedule Banner
                      Text(
                        settings.getText(
                            'جدول رعاية النبتة القادم', 'Upcoming Care Schedule'),
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: settings.isDarkMode
                              ? AppTheme.darkCard
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                          ),
                          boxShadow: AppTheme.sleekShadow,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0F2FE),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.water_drop_rounded,
                                    color: Color(0xFF0284C7),
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${settings.getText('تاريخ الري المجدول', 'Scheduled Date')}: ${_scheduledWateringDate.day}/${_scheduledWateringDate.month}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${settings.getText('الموعد القادم', 'Next Due')}: ${_scheduledWateringDate.day}/${_scheduledWateringDate.month}/${_scheduledWateringDate.year}',
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                provider.waterPlant(currentPlant.id);
                                setState(() {
                                  _scheduledWateringDate = DateTime.now().add(
                                      Duration(
                                          days: currentPlant
                                              .wateringIntervalDays));
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(settings.getText(
                                        'تم تسجيل ري النبتة وتجديد الموعد بنجاح',
                                        'Watering recorded and schedule updated successfully')),
                                    backgroundColor: AppTheme.primaryGreen,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                  settings.getText('تم الري', 'Watered'),
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Interactive Calendar Widget
                      Text(
                        settings.getText(
                            'تقويم جدولة واختيار مواعيد الري',
                            'Interactive Care Calendar'),
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CareCalendarWidget(
                        selectedDate: _scheduledWateringDate,
                        onDateSelected: (newDate) {
                          setState(() {
                            _scheduledWateringDate = newDate;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${settings.getText('تم تحديد موعد الري الجديد', 'New watering date scheduled')}: ${newDate.day}/${newDate.month}/${newDate.year}',
                              ),
                              backgroundColor: AppTheme.primaryGreen,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      Text(
                        settings.getText(
                            'نصائح غراس لرعاية النبتة', 'Ghiras Care Advice'),
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: settings.isDarkMode
                              ? AppTheme.darkCard
                              : AppTheme.warningBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppTheme.accentAmber
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppTheme.accentAmber,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                currentPlant.careAdvice,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metricCard(String title, String value, IconData icon,
      AppSettingsProvider settings) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
          boxShadow: AppTheme.sleekShadow,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
