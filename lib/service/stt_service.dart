import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _speech = SpeechToText();
  final ValueNotifier<bool> isListening = ValueNotifier(false);

  Future<bool> initialize(
    Function(String)? onStatus,
    Function(String)? onError,
  ) async {
    return await _speech.initialize(
      onStatus: onStatus,
      onError: (e) => onError?.call(e.errorMsg),
    );
  }

  void startListening(Function(String) onResult) {
    isListening.value = true;
    _speech.listen(onResult: (r) => onResult(r.recognizedWords));
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void cancelListening() {
    _speech.cancel();
    isListening.value = false;
  }
}
