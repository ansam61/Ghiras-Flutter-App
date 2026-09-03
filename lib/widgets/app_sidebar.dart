import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_settings_provider.dart';
import '../screens/ai_scan/ai_scanner_screen.dart';
import '../screens/auth/login_screen.dart';

class AppSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelectTab;

  const AppSidebar({
    super.key,
    required this.currentIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Drawer(
      backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
      child: Column(
        children: [
          // Premium Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.deepEmerald],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'A',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            accountName: const Text(
              'eng: ANSAM JAMEEL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              settings.getText(
                'منصة غراس • ansam@ghiras.com',
                'Ghiras Platform • ansam@ghiras.com',
              ),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),

          // Sidebar Navigation List Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              children: [
                _drawerItem(
                  context: context,
                  index: 0,
                  icon: Icons.home_rounded,
                  label: settings.getText('الرئيسية', 'Home'),
                ),
                _drawerItem(
                  context: context,
                  index: 1,
                  icon: Icons.local_florist_rounded,
                  label: settings.getText('حديقتي ونباتاتي', 'My Plants'),
                ),
                _drawerItem(
                  context: context,
                  index: 2,
                  icon: Icons.menu_book_rounded,
                  label: settings.getText('موسوعة النباتات', 'Encyclopedia'),
                ),
                _drawerItem(
                  context: context,
                  index: 3,
                  icon: Icons.person_rounded,
                  label: settings.getText('حسابي والإعدادات', 'Profile & Settings'),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(),
                ),

                // AI Scanner Quick Launcher
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.mintSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    settings.getText('ماسح التشخيص بالذكاء الاصطناعي', 'AI Diagnostic Scanner'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AIScannerScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Quick Preference Controls (Theme & Language)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.backgroundSoft,
              border: const Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      settings.getText('المظهر (نهري/ليلي)', 'Appearance'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                        color: AppTheme.primaryGreen,
                      ),
                      onPressed: () => settings.toggleTheme(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      settings.getText('اللغة (العربية/English)', 'Language'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      child: Text(
                        settings.isArabic ? 'English' : 'عربي',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => settings.toggleLanguage(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.alertRedText,
                    side: const BorderSide(color: AppTheme.alertRedText),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(settings.getText('تسجيل الخروج', 'Log Out')),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryGreen : AppTheme.textMuted,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          Navigator.pop(context);
          onSelectTab(index);
        },
      ),
    );
  }
}
