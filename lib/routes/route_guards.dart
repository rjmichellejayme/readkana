import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class RouteGuards {
  static Route<dynamic> guardedRoute(
    BuildContext context,
    Widget destination,
    RouteSettings settings,
  ) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    if (authService.isAuthenticated) {
      return MaterialPageRoute(
        builder: (_) => destination,
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: settings,
      );
    }
  }
}
