import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/braille_data.dart';
import '../widgets/braille_dots_widget.dart';
import '../models/barille_item.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  // ---------------- GAME SETTINGS ----------------
  final int questionsPerLevel = 5;
  final int minCorrectToPass = 4;

  int currentLevel = 1;
  int currentQuestion = 0;
  int correctInLevel = 0;
  bool levelFinished = false;

  // ---------------- CORE STATE ----------------
  final Random _random = Random();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  bool _permissionsGranted = false;
  bool _sttAvailable = false;
  bool _isLoading = true;
  bool _isSpeaking = false;

  String _statusText = 'Initializing...';

  late List<BrailleItem> _availableItems;
  BrailleItem? _currentItem;
  List<BrailleItem> _options = [];
  int? _selectedIndex;
  bool? _isCorrect;
  bool _showHint = false;

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _permissionsGranted = await _requestPermissions();
    await _ttsService.initialize();

    _availableItems = List.from(allBrailleItems);

    if (_permissionsGranted) {
      _sttAvailable = await _sttService.initialize(_onSttStatus, _onSttError);
    }

    _loadQuestion();
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();

    return statuses.values.every((s) => s.isGranted);
  }

  void _onSttStatus(String status) {
    if (kDebugMode) print("STT: $status");
  }

  void _onSttError(String error) {
    if (kDebugMode) print("STT Error: $error");
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.cancelListening();
    super.dispose();
  }

  // ---------------- GAME FLOW ----------------
  void _loadQuestion() {
    if (currentQuestion >= questionsPerLevel) {
      _finishLevel();
      return;
    }

    setState(() {
      _isLoading = true;
      _isCorrect = null;
      _selectedIndex = null;
      _showHint = false;
    });

    _currentItem = _availableItems[_random.nextInt(_availableItems.length)];
    _options = [_currentItem!];

    final distractors = List.from(_availableItems)..remove(_currentItem);
    distractors.shuffle();

    while (_options.length < 4 && distractors.isNotEmpty) {
      _options.add(distractors.removeLast());
    }

    _options.shuffle();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => _isLoading = false);
      await _ttsService.speak(_currentItem!.dotsAudioDescription);
    });
  }

  void _checkAnswer(int index) {
    if (_isCorrect != null) return;

    bool correct = _options[index] == _currentItem;

    setState(() {
      _selectedIndex = index;
      _isCorrect = correct;
      if (correct) correctInLevel++;
      _statusText = correct ? "Correct!" : "Wrong!";
    });
  }

  void _nextQuestion() {
    setState(() {
      currentQuestion++;
    });
    _loadQuestion();
  }

  void _finishLevel() {
    levelFinished = true;
    bool passed = correctInLevel >= minCorrectToPass;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(passed ? "Level Completed 🎉" : "Level Failed ❌"),
        content: Text(
          passed
              ? "You unlocked Level ${currentLevel + 1}"
              : "You need $minCorrectToPass correct answers",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (passed) currentLevel++;
                currentQuestion = 0;
                correctInLevel = 0;
                levelFinished = false;
              });
              _loadQuestion();
            },
            child: Text(passed ? "Next Level" : "Retry"),
          )
        ],
      ),
    );
  }

  // ---------------- UI HELPERS ----------------
  Color? _optionColor(int i) {
  // Before answering → use default button color
  if (_isCorrect == null) return null;

  // Selected button
  if (i == _selectedIndex) {
    return _isCorrect! ? Colors.green : Colors.red;
  }

  // Show correct answer if user was wrong
  if (_options[i] == _currentItem && _isCorrect == false) {
    return Colors.green.shade300;
  }

  // Other buttons
  return Colors.grey.shade400;
}


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice Mode – Level $currentLevel"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Question ${currentQuestion + 1} / $questionsPerLevel",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Correct: $correctInLevel",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  BrailleDotsWidget(item: _currentItem!, dotSize: 40),
                  const SizedBox(height: 20),

                  ..._options.asMap().entries.map((e) {
                    final i = e.key;
                    final item = e.value;
                    final letter = String.fromCharCode(65 + i);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _optionColor(i),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed:
                            _isCorrect == null ? () => _checkAnswer(i) : null,
                        child: Text("$letter : ${item.displayName}"),
                      ),
                    );
                  }),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: _isCorrect != null ? _nextQuestion : null,
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
    );
  }
}