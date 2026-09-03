import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/plant_provider.dart';
import '../ai_scan/ai_scanner_screen.dart';
import '../plant_details/plant_details_screen.dart';
import '../add_plant/add_plant_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Timer? _quoteTimer;
  int _currentQuoteIndex = 0;

  final List<Map<String, String>> _quotes = [
    {
      'ar': 'النباتات تمنح بيتك روحاً ونقاءً، اعتنِ بها لتزهر حياتك.',
      'en': 'Plants bring life and purity to your home, care for them to bloom your life.'
    },
    {
      'ar': 'الري المنتظم في الصباح الباكر يمنح الجذور امتصاصاً مثالياً للغذاء.',
      'en': 'Regular early morning watering gives roots optimal nutrient absorption.'
    },
    {
      'ar': 'الضوء غير المباشر يمنع احتراق أوراق النباتات الداخلية المزهرة.',
      'en': 'Indirect sunlight prevents leaf burn on flowering houseplants.'
    },
    {
      'ar': 'غراس: شريكك اليومي لرعاية خضراء مستدامة وبشرية فائقة.',
      'en': 'Ghiras: Your daily partner for sustainable green care.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startQuoteRotation();
  }

  void _startQuoteRotation() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Theme & Language Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.primaryGreen,
                        child: const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settings.getText('مرحباً بك', 'Welcome'),
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const Text(
                            'eng: ANSAM JAMEEL',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'تغيير اللغة Language',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.mintSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            settings.isArabic ? 'EN' : 'عربي',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        onPressed: () {
                          settings.toggleLanguage();
                        },
                      ),
                      IconButton(
                        tooltip: 'تغيير المظهر (نهري/ليلي)',
                        icon: Icon(
                          settings.isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.dark_mode_rounded,
                          color: AppTheme.primaryGreen,
                        ),
                        onPressed: () {
                          settings.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic Auto-Rotating Tip Banner (Changes every 10 seconds)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  key: ValueKey<int>(_currentQuoteIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: settings.isDarkMode ? AppTheme.darkCard : AppTheme.mintSoft,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          color: AppTheme.primaryGreen, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          settings.getText(
                            _quotes[_currentQuoteIndex]['ar']!,
                            _quotes[_currentQuoteIndex]['en']!,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '10s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // AI Scanner Banner
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIScannerScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.deepEmerald],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.activeShadow,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.getText(
                                  'فحص وتعرّف الذكاء الاصطناعي', 'AI Diagnostic Scanner'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              settings.getText(
                                  'التقط صورة لورقة النبتة للحصول على تشخيص دقيق وعلاج عضوي.',
                                  'Take a photo of the plant leaf for accurate diagnosis.'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // My Plants Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settings.getText('نباتاتي المعنية', 'My Managed Plants'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: AppTheme.primaryGreen, size: 26),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddPlantScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Plants List or Empty State Card
              Consumer<PlantProvider>(
                builder: (context, provider, child) {
                  final plants = provider.plants;

                  if (plants.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.sleekShadow,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppTheme.mintSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: AppTheme.primaryGreen,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            settings.getText(
                              'حديقتك فارغة حالياً',
                              'Your garden is currently empty',
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            settings.getText(
                              'أضف نبتتك الأولى واختر تصنيفها ليتم ترحيلها وحفظها مباشرة في قاعدة البيانات.',
                              'Add your first plant and select its category to save it directly into the database.',
                            ),
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddPlantScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: Text(
                              settings.getText(
                                  'إضافة نبتتك الأولى الآن', 'Add Your First Plant'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SizedBox(
                    height: 185,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantDetailsScreen(plant: plant),
                              ),
                            );
                          },
                          child: Container(
                            width: 145,
                            margin: const EdgeInsets.only(left: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: AppTheme.sleekShadow,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppTheme.mintSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.eco_rounded,
                                      color: AppTheme.primaryGreen,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  plant.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
