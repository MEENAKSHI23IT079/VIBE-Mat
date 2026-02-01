import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/stt_service.dart';
import '../service/tts_service.dart';

import 'dictionary_menu_page.dart';
import 'practice_page.dart';
import 'challenge_page.dart';

class ModuleSelectionPage extends StatefulWidget {
  final String module; // Maths or Science

  const ModuleSelectionPage({Key? key, required this.module}) : super(key: key);

  @override
  State<ModuleSelectionPage> createState() => _ModuleSelectionPageState();
}

class _ModuleSelectionPageState extends State<ModuleSelectionPage> {
  final SttService _sttService = SttService();
  final TtsService _ttsService = TtsService();

  bool _sttAvailable = false;
  bool _isNavigating = false;

  String _statusText =
      'Say Dictionary, Practice, or Challenge';

  @override
  void initState() {
    super.initState();
    _initVoice();
  }

  @override
  void dispose() {
    _sttService.cancelListening();
    _ttsService.stop();
    super.dispose();
  }

  // ---------------- INIT VOICE ----------------
  Future<void> _initVoice() async {
    await Permission.microphone.request();

    await _ttsService.initialize();

    _sttAvailable = await _sttService.initialize(
      _onVoiceCommand,
      (error) {
        setState(() => _statusText = 'Voice error occurred');
      },
    );

    await _ttsService.speak(
      "You are in the ${widget.module} module. "
      "Say Dictionary, Practice, or Challenge."
    );

    if (_sttAvailable) {
      _startListening();
    }
  }

  void _startListening() {
    if (!_sttAvailable || _isNavigating) return;
    _sttService.startListening(_onVoiceCommand);
  }

  // ---------------- VOICE COMMANDS ----------------
  void _onVoiceCommand(String command) async {
    if (_isNavigating) return;

    final spoken = command.toLowerCase().trim();

    // 📘 DICTIONARY
    if (spoken.contains('dictionary')) {
      await _ttsService.speak('Opening dictionary');
      _navigate(DictionaryMenuPage(module: widget.module));
      return;
    }

    // ✍ PRACTICE
    if (spoken.contains('practice')) {
      await _ttsService.speak('Opening practice');
      _navigate(PracticePage(module: widget.module));
      return;
    }

    // 🏆 CHALLENGE
    if (spoken.contains('challenge')) {
      await _ttsService.speak('Opening challenge');
      _navigate(ChallengePage(module: widget.module));
      return;
    }

    // 🔙 BACK
    if (spoken.contains('back')) {
      await _ttsService.speak('Going back');
      Navigator.pop(context);
      return;
    }

    // ❌ UNKNOWN
    await _ttsService.speak(
      'Command not recognized. Say Dictionary, Practice, or Challenge.'
    );

    setState(() {
      _statusText = 'Command not recognized';
    });
  }

  // ---------------- NAVIGATION ----------------
  void _navigate(Widget page) async {
    if (_isNavigating) return;
    _isNavigating = true;

    _sttService.stopListening();
    await _ttsService.stop();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) async {
      _isNavigating = false;

      setState(() {
        _statusText = 'Say Dictionary, Practice, or Challenge';
      });

      await _ttsService.speak(
        "You are back in the ${widget.module} module."
      );

      _startListening();
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module} Module'),
        centerTitle: true,
        actions: [
          if (_sttAvailable)
            ValueListenableBuilder<bool>(
              valueListenable: _sttService.isListening,
              builder: (_, listening, __) {
                return IconButton(
                  icon: Icon(
                    listening ? Icons.mic_off : Icons.mic,
                    size: 28,
                  ),
                  onPressed: _startListening,
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _bigButton(
              icon: Icons.book,
              label: 'Dictionary',
              onTap: () => _navigate(
                DictionaryMenuPage(module: widget.module),
              ),
            ),

            const SizedBox(height: 25),

            _bigButton(
              icon: Icons.edit,
              label: 'Practice',
              onTap: () => _navigate(
                PracticePage(module: widget.module),
              ),
            ),

            const SizedBox(height: 25),

            _bigButton(
              icon: Icons.emoji_events,
              label: 'Challenge',
              onTap: () => _navigate(
                ChallengePage(module: widget.module),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 22),
        ),
      ),
    );
  }
}
