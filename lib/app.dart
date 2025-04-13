import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/theme_service.dart';
import 'services/sound_service.dart';
import 'services/reading_service.dart';
import 'services/achievement_service.dart';
import 'services/search_service.dart';
import 'services/database_service.dart';
import 'services/auth_service.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => SoundService()),
        ChangeNotifierProvider(create: (_) => ReadingService()),
        ChangeNotifierProvider(create: (_) => AchievementService()),
        ChangeNotifierProvider(create: (_) => SearchService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => DatabaseService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            navigatorKey: AppRouter.navigatorKey,
            title: 'ReadKana',
            theme: themeService.themeData,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.initial,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
