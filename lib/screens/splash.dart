import 'dart:async';
import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // Navigate to HomePage after a delay
    Timer(const Duration(seconds: 3), () { // Adjust duration as needed
      // Use pushReplacement to prevent going back to splash screen
      setState(() {
        loading= true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Customize your splash screen appearance
      backgroundColor: Theme.of(context).primaryColor, // Example background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional: Add an icon or logo
            // Icon(Icons.accessibility_new, size: 100, color: Colors.white),
            // SizedBox(height: 20),
            Text(
              'VIBE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child:
              loading?
              Column(
                children: [
                  //startbutton
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              ):
              Column(
                children: [
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}