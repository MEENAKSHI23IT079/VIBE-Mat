import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/tts_service.dart';
import '../service/stt_service.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = false;
  bool _navigated = false;

  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    // Simulate loading
    Timer(const Duration(seconds: 3), () async {
      setState(() => loading = true);

      await Permission.microphone.request();
      await _ttsService.initialize();
      await _sttService.initialize(_onSpeechResult, (_) {});

      await _ttsService.speak(
        "Welcome to VIBE. Say yes to start, or press the start button."
      );

      _sttService.startListening(_onSpeechResult);
    });
  }

  void _onSpeechResult(String text) {
    if (_navigated) return;

    final spoken = text.toLowerCase();

    if (spoken.contains('yes') ||
        spoken.contains('start') ||
        spoken.contains('go')) {
      _navigateToHome();
    }
  }

  void _navigateToHome() async {
    if (_navigated) return;
    _navigated = true;

    _sttService.stopListening();
    await _ttsService.stop();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'VIBE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            loading
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: _navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          'Start',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: const [
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 40),
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
