import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_settings_provider.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _selectedTab = 0;

  final List<Map<String, String>> _favoritePlants = [
    {'name': 'البوتس الذهبي', 'latin': 'Epipremnum aureum'},
    {'name': 'جلد النمر (سانسيفيريا)', 'latin': 'Sansevieria trifasciata'},
    {'name': 'صبار الألوفيرا الطبي', 'latin': 'Aloe vera'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  settings.getText('المفضلة وحسابي', 'Favorites & Profile'),
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.sleekShadow,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryGreen,
                      child: const Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'eng: ANSAM JAMEEL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          settings.getText('المسؤول الرئيسي • ansam@ghiras.com',
                              'Administrator • ansam@ghiras.com'),
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Theme & Language Settings Card
              Text(
                settings.getText('إعدادات التفضيلات والمظهر', 'Preferences & Appearance'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
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
                    // Theme Switch (Light / Dark)
                    SwitchListTile(
                      activeColor: AppTheme.primaryGreen,
                      title: Text(
                        settings.getText('الوضع النهري / الليلي', 'Light / Dark Mode'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        settings.isDarkMode
                            ? settings.getText('الوضع الحالي: ليلي', 'Current: Dark')
                            : settings.getText('الوضع الحالي: نهري', 'Current: Light'),
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      secondary: Icon(
                        settings.isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.wb_sunny_rounded,
                        color: AppTheme.primaryGreen,
                      ),
                      value: settings.isDarkMode,
                      onChanged: (val) {
                        settings.toggleTheme();
                      },
                    ),
                    const Divider(height: 1),
                    // Language Switch (Ar / En)
                    SwitchListTile(
                      activeColor: AppTheme.primaryGreen,
                      title: Text(
                        settings.getText('لغة التطبيق (العربية / English)', 'Language (Ar / En)'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        settings.isArabic ? 'اللغة الحالية: العربية' : 'Current: English',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      secondary: const Icon(
                        Icons.language_rounded,
                        color: AppTheme.primaryGreen,
                      ),
                      value: !settings.isArabic,
                      onChanged: (val) {
                        settings.toggleLanguage();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Favorites Pill Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            settings.getText('النباتات المفضلة', 'Favorite Plants'),
                            style: TextStyle(
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : AppTheme.textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            settings.getText('المقالات والروابط', 'Articles & Links'),
                            style: TextStyle(
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : AppTheme.textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Favorites List Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _favoritePlants.length,
                itemBuilder: (context, index) {
                  final plant = _favoritePlants[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: settings.isDarkMode ? AppTheme.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppTheme.mintSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                plant['latin']!,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.favorite_rounded,
                          color: AppTheme.alertRedText,
                          size: 22,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.alertRedText,
                  side: const BorderSide(color: AppTheme.alertRedText),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(settings.getText('تسجيل الخروج', 'Log Out')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
