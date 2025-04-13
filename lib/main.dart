import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readkana/screens/home_screen.dart'; // Adjust the import path
import 'package:readkana/services/reading_service.dart'; // Adjust the import path
import 'package:readkana/services/database_service.dart'; // If you're using it
import 'package:readkana/services/book_processor_service.dart'; // If you're using it

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReadKana',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReadingService()),
        // You might have other providers here, like DatabaseService, etc.
        Provider(create: (_) => DatabaseService()), // Example if DatabaseService is used directly
        Provider(create: (_) => BookProcessorService()), // Example
      ],
      child: MaterialApp(
        title: 'ReadKana',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          // Add other theme configurations
        ),
        home: const HomeScreen(),
      ),
    );
  }
}