import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../service/stt_service.dart';
import '../service/tts_service.dart';
import '../theme/theme_provider.dart';

import 'module_selection_page.dart';
import 'theme_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SttService _sttService = SttService();
  final TtsService _ttsService = TtsService();

  bool _sttAvailable = false;
  bool _isNavigating = false;

  String _voiceCommandStatus =
      'Say "Maths", "Science", or "Theme"';

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  @override
  void dispose() {
    _sttService.cancelListening();
    _ttsService.stop();
    super.dispose();
  }

  // ---------------- INITIALIZE VOICE ----------------
  Future<void> _initializeVoice() async {
    final granted = await _requestPermissions();
    if (!granted) return;

    await _ttsService.initialize();

    _sttAvailable = await _sttService.initialize(
      _handleVoiceCommand,
      (error) {
        setState(() => _voiceCommandStatus = 'Voice error occurred');
      },
    );

    if (_sttAvailable) {
      await _ttsService.speak(
        "Welcome to the Braille Learning Hub. "
        "Say Maths or Science to begin learning. "
        "Say Theme to change colors."
      );

      _startListening();
    }
  }

  Future<bool> _requestPermissions() async {
    final mic = await Permission.microphone.request();
    final speech = await Permission.speech.request();

    if (mic.isGranted && speech.isGranted) return true;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Microphone and Speech permissions are required',
          ),
        ),
      );
    }
    return false;
  }

  // ---------------- LISTENING ----------------
  void _startListening() {
    if (!_sttAvailable || _isNavigating) return;
    _sttService.startListening(_handleVoiceCommand);
  }

  void _handleVoiceInputTap() {
    if (!_sttAvailable) return;

    if (_sttService.isListening.value) {
      _sttService.stopListening();
    } else {
      setState(() => _voiceCommandStatus = 'Listening...');
      _startListening();
    }
  }

  // ---------------- VOICE COMMANDS ----------------
  void _handleVoiceCommand(String command) async {
    if (_isNavigating) return;

    final spoken = command.toLowerCase().trim();
    final themeProvider = context.read<ThemeProvider>();

    // 🎨 THEME
    if (spoken.contains('yellow')) {
      themeProvider.setTheme(AppTheme.yellowOnDarkBlue);
      await _ttsService.speak('Yellow theme enabled');
      return;
    }

    if (spoken.contains('high contrast')) {
      themeProvider.setTheme(AppTheme.highContrastDark);
      await _ttsService.speak('High contrast theme enabled');
      return;
    }

    if (spoken.contains('dark')) {
      themeProvider.setTheme(AppTheme.dark);
      await _ttsService.speak('Dark theme enabled');
      return;
    }

    if (spoken.contains('light')) {
      themeProvider.setTheme(AppTheme.light);
      await _ttsService.speak('Light theme enabled');
      return;
    }

    if (spoken.contains('theme')) {
      _navigate(const ThemeSelectionPage());
      return;
    }

    // 📘 MATHS
    if (spoken.contains('math')) {
      await _ttsService.speak('Opening Maths module');
      _navigate(const ModuleSelectionPage(module: 'Maths'));
      return;
    }

    // 🔬 SCIENCE
    if (spoken.contains('science')) {
      await _ttsService.speak('Opening Science module');
      _navigate(const ModuleSelectionPage(module: 'Science'));
      return;
    }

    // ❌ UNKNOWN
    await _ttsService.speak(
      'Command not recognized. Say Maths, Science, or Theme.',
    );

    setState(() {
      _voiceCommandStatus = 'Command not recognized';
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
        _voiceCommandStatus = 'Say Maths, Science, or Theme';
      });

      await _ttsService.speak(
        'You are back on the home screen. '
        'Say Maths or Science to continue.'
      );

      _startListening();
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braille Learning Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Change Theme',
            onPressed: () => _navigate(const ThemeSelectionPage()),
          ),
          if (_sttAvailable)
            ValueListenableBuilder<bool>(
              valueListenable: _sttService.isListening,
              builder: (_, listening, __) {
                return IconButton(
                  icon: Icon(
                    listening ? Icons.mic_off : Icons.mic,
                    size: 28,
                  ),
                  onPressed: _handleVoiceInputTap,
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
              icon: Icons.calculate,
              label: 'Maths',
              onTap: () =>
                  _navigate(const ModuleSelectionPage(module: 'Maths')),
            ),
            const SizedBox(height: 30),
            _bigButton(
              icon: Icons.science,
              label: 'Science',
              onTap: () =>
                  _navigate(const ModuleSelectionPage(module: 'Science')),
            ),
            const SizedBox(height: 50),
            Text(
              _voiceCommandStatus,
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
