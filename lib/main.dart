import 'package:braille_app_new/screens/splash.dart';
import 'package:flutter/material.dart';
// Remove HomePage import if not needed elsewhere in main
// import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrailleApp());
}

class BrailleApp extends StatelessWidget {
  const BrailleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Braille Learner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: const SplashScreen(), // <-- Use SplashScreen here
      debugShowCheckedModeBanner: false,
    );
  }
}