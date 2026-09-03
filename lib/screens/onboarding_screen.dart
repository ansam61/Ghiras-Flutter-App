import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_settings_provider.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    final List<Map<String, dynamic>> pages = [
      {
        'title': settings.getText('شخّص نبتتك فوراً', 'Instant Plant Diagnosis'),
        'description': settings.getText(
            'التقط صورة لورقة النبتة المصابة، ودع الذكاء الاصطناعي يكتشف المشكلة ويقدم الحل الصحيح.',
            'Take a photo of the affected leaf and let AI detect issues and provide the right fix.'),
        'icon': Icons.qr_code_scanner_rounded,
      },
      {
        'title': settings.getText('حلول وعلاجات عضوية', 'Organic Treatment Solutions'),
        'description': settings.getText(
            'احصل على إرشادات عناية دقيقة وبدائل علاجية آمنة وبشرية بدون مواد كيميائية ضارة.',
            'Get precise care guidance and safe organic remedies without harsh chemicals.'),
        'icon': Icons.eco_rounded,
      },
      {
        'title': settings.getText('موسوعة وعناية فائقة', 'Encyclopedia & Premium Care'),
        'description': settings.getText(
            'استكشف آلاف النباتات وتتبع مواعيد السقي والتقليم والتسميد بأسلوب سهل وشيق.',
            'Explore thousands of plants and track watering, pruning and fertilizing effortlessly.'),
        'icon': Icons.auto_stories_rounded,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      settings.getText('تخطي', 'Skip'),
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryLightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: const BoxDecoration(
                                color: AppTheme.mintSoft,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page['icon'],
                                size: 72,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 44),
                        Text(
                          page['title'],
                          style: const TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['description'],
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 15,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryGreen
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _currentPage == pages.length - 1
                      ? ElevatedButton(
                          onPressed: _skip,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(settings.getText(
                              'ابدأ رحلتك الخضراء الآن', 'Start Your Botanical Journey')),
                        )
                      : GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                              boxShadow: AppTheme.activeShadow,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
