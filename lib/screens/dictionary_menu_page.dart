import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import '../models/barille_item.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';
import 'braille_display_page.dart';
import '../data/braille_data.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

class DictionaryMenuPage extends StatefulWidget {
  const DictionaryMenuPage({Key? key}) : super(key: key);

  @override
  State<DictionaryMenuPage> createState() => _DictionaryMenuPageState();
}

class _DictionaryMenuPageState extends State<DictionaryMenuPage> {
  // --- State Variables ---
  final SttService _sttService = SttService();
  final TtsService _ttsService = TtsService(); // For audio feedback
  bool _sttAvailable = false;
  bool _permissionsGranted = false;
  String _sttStatusInfo = 'Initializing...';

  // Keep category list accessible
  final List<String> categories = const [
    'Numbers (0-9)',
    'Basic Operations',
    'Special Symbols',
    'Brackets',
    'Greek Letters',
    // Add more category titles as you add data in braille_data.dart
  ];

  // --- Initialization and Permissions ---

  @override
  void initState() {
    super.initState();
    _initializeSequence();
  }

  Future<void> _initializeSequence() async {
    await _ttsService.initialize(); // Initialize TTS for feedback
    _permissionsGranted = await _requestPermissions();
    if (!_permissionsGranted) {
      if (mounted) {
        setState(() {
          _sttStatusInfo = 'Permissions denied. Voice commands disabled.';
        });
      }
      return;
    }

    // Permissions granted, try initializing STT
    _sttAvailable = await _sttService.initialize(
      _onSttStatus,
      _onSttError,
    );

    if (mounted) {
      setState(() {
        _sttStatusInfo = _sttAvailable
            ? 'Tap mic & say a category name (e.g., "Numbers")'
            : 'STT initialization failed. Voice commands disabled.';
      });
    }
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();
    bool granted = statuses[Permission.microphone] == PermissionStatus.granted &&
        statuses[Permission.speech] == PermissionStatus.granted;
    if (!granted && kDebugMode) print("Permission Statuses: $statuses");
    return granted;
  }

  void _onSttStatus(String status) {
    if (kDebugMode) print('STT Status: $status');
  }

  void _onSttError(String error) {
    if (kDebugMode) print('STT Error: $error');
    if (mounted) {
      setState(() {
        if (error.contains("No speech recognized")) {
          _sttStatusInfo = 'Did not hear anything. Try again.';
        } else {
          _sttStatusInfo = "STT Error. Try again.";
        }
      });
    }
  }


  @override
  void dispose() {
    _sttService.cancelListening();
    _ttsService.stop(); // Stop TTS if playing
    super.dispose();
  }

  // --- Voice Command Handling ---

  void _handleVoiceInput() {
    // Ensure STT is available and permissions granted
    if (!_sttAvailable || !_permissionsGranted) {
      if (kDebugMode) print("Voice input blocked: available=$_sttAvailable, granted=$_permissionsGranted");
      return;
    }

    if (_sttService.isListening.value) {
      _sttService.stopListening();
      if (mounted) setState(() => _sttStatusInfo = 'Tap mic & say a category name');
    } else {
      if (mounted) setState(() => _sttStatusInfo = 'Listening for category name...');
      _sttService.startListening(_processVoiceResult);
    }
  }

  void _processVoiceResult(String result) {
    if (!mounted) return; // Check if widget is still alive

    final command = result.toLowerCase().trim();
    if (kDebugMode) print("Raw Voice Result: '$result', Processed: '$command'");

    if (command.isEmpty) {
      if (mounted) setState(() => _sttStatusInfo = 'Tap mic & say a category name'); // Reset if silence/no result
      return;
    }

    String? matchedCategory;

    // Iterate through categories to find a match (using flexible 'contains')
    for (final category in categories) {
      // Prepare category name for matching (lowercase, maybe remove parentheses content)
      final categoryLower = category.toLowerCase();
      // Simple matching: check if command is part of category name or vice-versa
      // Or check for keywords
      List<String> keywords = _getKeywordsFromCategory(categoryLower);

      // Check if the command contains any keyword from the category
      bool keywordMatch = keywords.any((keyword) => command.contains(keyword));

      if (keywordMatch) {
        matchedCategory = category;
        break; // Found a match, stop searching
      }
    }


    if (matchedCategory != null) {
      if (kDebugMode) print("Voice command maps to category: $matchedCategory");
      _ttsService.speak("Navigating to $matchedCategory"); // Give audio feedback
      if (mounted) {
        setState(() { _sttStatusInfo = 'Navigating to $matchedCategory...';});
        // Find the data and navigate
        _navigateToCategory(matchedCategory);
      }
    } else {
      if (kDebugMode) print("Unrecognized category command: $command");
      if (mounted) setState(() { _sttStatusInfo = 'Category "$command" not recognized.';});
      _ttsService.speak('Category not recognized');
    }
  }

  // Helper to extract keywords for better matching
  List<String> _getKeywordsFromCategory(String categoryLower) {
    // Basic keyword extraction (can be improved)
    String cleaned = categoryLower.replaceAll(RegExp(r'[()]'), ''); // Remove parentheses
    List<String> parts = cleaned.split(' ');
    // Add common variations or primary words
    if (categoryLower.contains("numbers")) return ["number", "digit"];
    if (categoryLower.contains("operations")) return ["operation", "operator", "math", "plus", "minus"]; // Add more operators if needed
    if (categoryLower.contains("special")) return ["special", "symbol"];
    if (categoryLower.contains("brackets")) return ["bracket", "parenthesis", "integral", "radical"];
    if (categoryLower.contains("greek")) return ["greek", "alpha", "beta"]; // Add more greek letters if needed
    // Default: return significant words (e.g., more than 2 letters)
    return parts.where((p) => p.length > 2).toList();
  }


  // --- Navigation ---

  void _navigateToCategory(String categoryTitle) {
    List<BrailleItem> data = getBrailleDataList(categoryTitle);
    if (data.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrailleDisplayPage(
            items: data,
            title: categoryTitle,
            // BrailleDisplayPage initializes its own STT/TTS currently
          ),
        ),
      ).then((_) {
        // When returning to this page, reset the status
        if (mounted && _sttAvailable) {
          setState(() {
            _sttStatusInfo = 'Tap mic & say a category name';
          });
        }
      });
    } else {
      if (kDebugMode) print("No data found for category: $categoryTitle");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No data found for $categoryTitle')),
      );
      // Reset status if navigation fails
      if (mounted) setState(() => _sttStatusInfo = 'Tap mic & say a category name');
    }
  }

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    // Determine if the mic button should be enabled
    bool canUseVoice = _sttAvailable && _permissionsGranted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary Categories'),
        actions: [
          // Mic button
          ValueListenableBuilder<bool>(
              valueListenable: _sttService.isListening,
              builder: (context, isListening, child) {
                return IconButton(
                  icon: Icon(isListening ? Icons.mic_off : Icons.mic),
                  iconSize: 28,
                  tooltip: canUseVoice
                      ? (isListening ? 'Stop listening' : 'Say a category name')
                      : 'Voice commands unavailable',
                  onPressed: canUseVoice ? _handleVoiceInput : null,
                  color: canUseVoice ? null : Colors.grey,
                );
              }
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column( // Wrap ListView in Column to add status text
        children: [
          // Status Info Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              _sttStatusInfo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: _sttStatusInfo.contains("Error") || _sttStatusInfo.contains("denied") || _sttStatusInfo.contains("disabled")
                    ? Colors.red.shade700
                    : Colors.grey.shade700,
              ),
            ),
          ),
          const Divider(height: 1), // Separator

          // Category List
          Expanded( // Make ListView take remaining space
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final categoryTitle = categories[index];
                return ListTile(
                  title: Text(categoryTitle),
                  leading: const Icon(Icons.list_alt),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _navigateToCategory(categoryTitle),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}