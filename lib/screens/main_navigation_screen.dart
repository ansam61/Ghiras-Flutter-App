import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_settings_provider.dart';
import '../widgets/app_sidebar.dart';
import 'home/home_tab.dart';
import 'my_plants/my_plants_tab.dart';
import 'encyclopedia/encyclopedia_tab.dart';
import 'profile/profile_tab.dart';
import 'ai_scan/ai_scanner_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _tabs = const [
    HomeTab(),
    MyPlantsTab(),
    EncyclopediaTab(),
    ProfileTab(),
  ];

  void _openAIScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AIScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _getTabTitle(_currentIndex, settings),
          style: const TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppTheme.primaryGreen, size: 28),
          tooltip: settings.getText('القائمة الجانبية', 'Sidebar Navigation'),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded, color: AppTheme.primaryGreen),
            tooltip: settings.getText('ماسح التشخيص', 'AI Scanner'),
            onPressed: _openAIScanner,
          ),
        ],
      ),
      // Doctor Requirement: Sidebar Drawer Navigation
      drawer: AppSidebar(
        currentIndex: _currentIndex,
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Row(
        children: [
          // Permanent NavigationRail Sidebar for Tablet/Desktop screens
          if (MediaQuery.of(context).size.width >= 768)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: AppTheme.primaryGreen),
              selectedLabelTextStyle: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: Text(settings.getText('الرئيسية', 'Home')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.local_florist_outlined),
                  selectedIcon: const Icon(Icons.local_florist_rounded),
                  label: Text(settings.getText('نباتاتي', 'My Plants')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.menu_book_outlined),
                  selectedIcon: const Icon(Icons.menu_book_rounded),
                  label: Text(settings.getText('الموسوعة', 'Encyclopedia')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: Text(settings.getText('حسابي', 'Profile')),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAIScanner,
        backgroundColor: AppTheme.primaryGreen,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.center_focus_strong_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  String _getTabTitle(int index, AppSettingsProvider settings) {
    switch (index) {
      case 0:
        return settings.getText('الرئيسية', 'Home');
      case 1:
        return settings.getText('حديقتي ونباتاتي', 'My Garden & Plants');
      case 2:
        return settings.getText('موسوعة النباتات', 'Plant Encyclopedia');
      case 3:
        return settings.getText('حسابي والإعدادات', 'Profile & Settings');
      default:
        return settings.getText('غراس', 'Ghiras');
    }
  }
}
