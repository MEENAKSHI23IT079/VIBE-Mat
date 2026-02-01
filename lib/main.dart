import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BrailleApp(),
    ),
  );
}

class BrailleApp extends StatelessWidget {
  const BrailleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Braille Learner',
      theme: themeProvider.themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
