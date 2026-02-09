import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  final ValueNotifier<bool> isListening = ValueNotifier(false);
  bool _speechAvailable = false;

  /// 🎤 Initialize STT
  Future<bool> initialize(
    Function(String status)? onStatus,
    Function(String error)? onError,
  ) async {
    _speechAvailable = await _speech.initialize(
      onStatus: onStatus,
      onError: (error) => onError?.call(error.errorMsg),
    );
    return _speechAvailable;
  }

  /// ▶ Start listening
  Future<void> startListening(
    Function(String recognizedText) onResult,
  ) async {
    if (!_speechAvailable) return;

    isListening.value = true;

    await _speech.listen(
      localeId: 'en_IN',
      listenMode: stt.ListenMode.confirmation,
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(seconds: 8),
      onResult: (result) {
        if (result.finalResult) {
          isListening.value = false;
          onResult(result.recognizedWords.toLowerCase());
        }
      },
    );
  }

  /// ⏹ Stop listening (USED EVERYWHERE)
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
    isListening.value = false;
  }

  /// ❌ Cancel listening (USED IN splash, home, menu, practice)
  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
    isListening.value = false;
  }
}
