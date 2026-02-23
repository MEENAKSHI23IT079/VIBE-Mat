import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';
import 'braille_display_page.dart';
import '../data/braille_data.dart';
import 'package:permission_handler/permission_handler.dart';

class DictionaryMenuPage extends StatefulWidget {
  final String module; // Maths or Science

  const DictionaryMenuPage({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  State<DictionaryMenuPage> createState() => _DictionaryMenuPageState();
}

class _DictionaryMenuPageState extends State<DictionaryMenuPage> {
  final SttService _sttService = SttService();
  final TtsService _ttsService = TtsService();

  bool _sttAvailable = false;
  bool _permissionsGranted = false;
  bool _waitingForYes = true;

  String _statusText = 'Say YES to open dictionary';

  // ---------------- CATEGORIES ----------------

  final List<String> mathsCategories = const [
    'Indicators',
    'Numbers',
    'Basic Operations',
    'Special Symbols',
    'Brackets',
    'Greek Letters',
    'Fractions & Powers',
    'Advanced Math',
    'Algebra',
    'Geometry & Units',
  ];

  final List<String> scienceCategories = const [
    'Scientific Indicators',
    'Scientific Units',
    'Physics Symbols',
    'Chemistry Elements',
    'Biology Symbols',
  ];

  List<String> get categories =>
      widget.module == 'Science' ? scienceCategories : mathsCategories;

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    _initVoiceFlow();
  }

  Future<void> _initVoiceFlow() async {
    await _ttsService.initialize();

    _permissionsGranted = await _requestPermissions();
    if (!_permissionsGranted) return;

    _sttAvailable = await _sttService.initialize(_onSpeech, _onError);
    _sttService.stopListening();
    await _ttsService.speak(
      "Welcome to ${widget.module} dictionary. Say yes to open the dictionary.",
    );

    _sttService.startListening(_onSpeech);
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();

    return statuses.values.every((s) => s.isGranted);
  }

  // ---------------- SPEECH HANDLING ----------------

  void _onSpeech(String text) {
    final spoken = text.toLowerCase().trim();
    if (kDebugMode) print("Dictionary heard: $spoken");

    // WAITING FOR YES
    if (_waitingForYes) {
      if (spoken.contains('yes')) {
        _waitingForYes = false;
        _readCategories();
      }
      return;
    }

    // REPEAT
    if (spoken.contains('repeat')) {
      _readCategories();
      return;
    }

    // MATCH CATEGORY
    for (final category in categories) {
      final keyWord = category.toLowerCase().split(' ').first;
      if (spoken.contains(keyWord)) {
        _openCategory(category);
        return;
      }
    }
    _sttService.stopListening();
    _ttsService.speak("Category not recognized. Please repeat.");
  }

  void _onError(String error) {
    if (kDebugMode) print("STT error: $error");
    _statusText = 'Voice error';
    setState(() {});
  }

  // ---------------- VOICE OUTPUT ----------------

  Future<void> _readCategories() async {
  setState(() {
    _statusText = 'Listening for category name';
  });

  // Stop listening while speaking
  await _sttService.stopListening();

  // Intro
  await _ttsService.speak(
    "You can learn the following sections in ${widget.module}.",
  );

  // Read each category clearly
  for (final c in categories) {
    final name = c.split('(').first.trim();
    await _ttsService.speak(name);
  }

  // Clear question prompt
  await _ttsService.speak(
    "What do you want to learn now? Please say the section name.",
    onComplete: () {
      _sttService.startListening(_onSpeech);
    },
  );
}

  // ---------------- NAVIGATION ----------------

  void _openCategory(String category) async {
    await _ttsService.speak("Opening $category");

    final data = getBrailleDataList(category);
    if (data.isEmpty) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrailleDisplayPage(
          items: data,
          title: category,
        ),
      ),
    ).then((_) {
      _readCategories();
    });
  }

  // ---------------- CLEANUP ----------------

  @override
  void dispose() {
    _sttService.cancelListening();
    _ttsService.stop();
    super.dispose();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module} Dictionary'),
        actions: [
          if (_sttAvailable)
            ValueListenableBuilder<bool>(
              valueListenable: _sttService.isListening,
              builder: (_, listening, __) {
                return IconButton(
                  icon: Icon(listening ? Icons.mic_off : Icons.mic),
                  onPressed: () {
                    if (listening) {
                      _sttService.stopListening();
                    } else {
                      _sttService.startListening(_onSpeech);
                    }
                  },
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _statusText,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(categories[i]),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openCategory(categories[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
