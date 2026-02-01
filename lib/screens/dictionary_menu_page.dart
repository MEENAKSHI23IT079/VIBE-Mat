import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/barille_item.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';
import 'braille_display_page.dart';
import '../data/braille_data.dart';
import 'package:permission_handler/permission_handler.dart';

class DictionaryMenuPage extends StatefulWidget {
  final String module; // "Maths" or "Science"

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
  String _sttStatusInfo = 'Initializing...';

  // ---------------- CATEGORY LISTS ----------------

  final List<String> mathsCategories = const [
    'Numbers (0-9)',
    'Basic Operations',
    'Special Symbols',
    'Brackets',
    'Greek Letters',
    'Indicators',
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
      widget.module == 'Science'
          ? scienceCategories
          : mathsCategories;

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    _initializeSequence();
  }

  Future<void> _initializeSequence() async {
    await _ttsService.initialize();
    _permissionsGranted = await _requestPermissions();

    if (!_permissionsGranted) {
      setState(() {
        _sttStatusInfo = 'Permissions denied. Voice disabled.';
      });
      return;
    }

    _sttAvailable = await _sttService.initialize(
      _onSttStatus,
      _onSttError,
    );

    setState(() {
      _sttStatusInfo = _sttAvailable
          ? 'Tap mic & say a category name'
          : 'Voice unavailable';
    });
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();

    return statuses.values.every((s) => s.isGranted);
  }

  void _onSttStatus(String status) {
    if (kDebugMode) print('STT Status: $status');
  }

  void _onSttError(String error) {
    if (kDebugMode) print('STT Error: $error');
    setState(() {
      _sttStatusInfo = 'Voice error. Try again.';
    });
  }

  @override
  void dispose() {
    _sttService.cancelListening();
    _ttsService.stop();
    super.dispose();
  }

  // ---------------- VOICE HANDLING ----------------

  void _handleVoiceInput() {
    if (!_sttAvailable || !_permissionsGranted) return;

    if (_sttService.isListening.value) {
      _sttService.stopListening();
      setState(() => _sttStatusInfo = 'Tap mic & say a category name');
    } else {
      setState(() => _sttStatusInfo = 'Listening...');
      _sttService.startListening(_processVoiceResult);
    }
  }

  void _processVoiceResult(String result) {
    final command = result.toLowerCase().trim();

    String? matchedCategory;

    for (final category in categories) {
      if (command.contains(category.toLowerCase().split(' ').first)) {
        matchedCategory = category;
        break;
      }
    }

    if (matchedCategory != null) {
      _ttsService.speak("Opening $matchedCategory");
      _navigateToCategory(matchedCategory);
    } else {
      _ttsService.speak("Category not recognized");
    }
  }

  // ---------------- NAVIGATION ----------------

  void _navigateToCategory(String categoryTitle) {
    final data = getBrailleDataList(categoryTitle);

    if (data.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrailleDisplayPage(
          items: data,
          title: categoryTitle,
        ),
      ),
    ).then((_) {
      setState(() {
        _sttStatusInfo = 'Tap mic & say a category name';
      });
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final canUseVoice = _sttAvailable && _permissionsGranted;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.module} Dictionary"),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _sttService.isListening,
            builder: (_, listening, __) {
              return IconButton(
                icon: Icon(listening ? Icons.mic_off : Icons.mic),
                onPressed: canUseVoice ? _handleVoiceInput : null,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _sttStatusInfo,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.list_alt),
                title: Text(categories[i]),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _navigateToCategory(categories[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
