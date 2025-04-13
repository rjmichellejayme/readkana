import 'package:flutter/material.dart';

class RouteGuards {
  static bool isAuthenticated = false;

  static Route<dynamic> guardedRoute(
    BuildContext context,
    Widget destination,
    RouteSettings settings,
  ) {
    if (isAuthenticated) {
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
