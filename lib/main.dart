import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/plant_provider.dart';
import 'providers/app_settings_provider.dart';
import 'screens/splash_screen.dart';

/// Ghiras Global .NET 10 API Configuration
class ApiConfig {
  static const String baseHttpUrl = 'http://localhost:5250/api';
  static const String baseEmulatorUrl = 'http://10.0.2.2:5250/api';
  static const String baseHttpsUrl = 'https://localhost:7267/api';

  static const List<String> candidateEndpoints = [
    '$baseHttpUrl/plants',
    '$baseEmulatorUrl/plants',
    '$baseHttpsUrl/plants',
  ];
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Log API connection initialization
  debugPrint('🌿 [Ghiras AI]: Initializing application with backend API endpoint: ${ApiConfig.baseHttpUrl}');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: const GhirasApp(),
    ),
  );
}

class GhirasApp extends StatelessWidget {
  const GhirasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'غراس | Ghiras AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          
          locale: settings.currentLocale,
          supportedLocales: const [
            Locale('ar', 'SA'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}
