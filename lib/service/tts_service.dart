import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // default accessible speed

    _initialized = true;
  }

  /// 🔊 Speak text
  Future<void> speak(String text) async {
    await stop();
    await _flutterTts.speak(text);
  }

  /// ⏹ Stop speaking
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// 🐢🐇 Adjust speech speed (0.1 – 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  /// 🎚 Optional: pitch control
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }
}
