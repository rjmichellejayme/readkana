import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readkana/screens/home_screen.dart';
import 'package:readkana/screens/login_screen.dart';
import 'package:readkana/screens/signup_screen.dart';
import 'package:readkana/screens/splash_screen.dart';
import 'package:readkana/services/reading_service.dart';
import 'package:readkana/services/database_service.dart';
import 'package:readkana/services/book_processor_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReadingService()),
        Provider(create: (_) => DatabaseService()),
        Provider(create: (_) => BookProcessorService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReadKana',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
