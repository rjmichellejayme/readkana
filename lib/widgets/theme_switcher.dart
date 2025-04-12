import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return IconButton(
      icon: Icon(
        themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () {
        themeService.toggleTheme();
      },
    );
  }
}