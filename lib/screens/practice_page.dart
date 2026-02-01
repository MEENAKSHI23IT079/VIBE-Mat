import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/braille_data.dart';
import '../models/barille_item.dart';
import '../widgets/braille_dots_widget.dart';
import '../service/tts_service.dart';
import '../service/stt_service.dart';

class PracticePage extends StatefulWidget {
  final String module; // Maths or Science

  const PracticePage({Key? key, required this.module}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final Random _random = Random();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  bool _isLoading = true;
  bool _isListening = false;

  final int questionsPerLevel = 5;
  final int minCorrectToPass = 4;

  final Map<int, String> mathsLevelMap = {
    1: 'Numbers (0-9)',
    2: 'Basic Operations',
    3: 'Special Symbols',
    4: 'Brackets',
    5: 'Greek Letters',
  };

  final Map<int, String> scienceLevelMap = {
    1: 'Scientific Indicators',
    2: 'Scientific Units',
    3: 'Physics Symbols',
    4: 'Chemistry Elements',
    5: 'Biology Symbols',
  };

  Map<int, String> get levelMap =>
      widget.module == 'Science' ? scienceLevelMap : mathsLevelMap;

  int currentLevel = 1;
  int currentQuestion = 0;
  int correctInLevel = 0;

  late List<BrailleItem> _availableItems;
  BrailleItem? _currentItem;
  List<BrailleItem> _options = [];

  int? _selectedIndex;
  bool? _isCorrect;

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Permission.microphone.request();
    await _ttsService.initialize();
    await _sttService.initialize(_onSpeechResult, (_) {});
    _loadLevel();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.cancelListening();
    super.dispose();
  }

  // ---------------- LEVEL ----------------
  void _loadLevel() {
    _availableItems =
        List.from(getBrailleDataList(levelMap[currentLevel]!));

    currentQuestion = 0;
    correctInLevel = 0;
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    await _ttsService.stop();

    if (currentQuestion >= questionsPerLevel) {
      _finishLevel();
      return;
    }

    setState(() {
      _isLoading = true;
      _isCorrect = null;
      _selectedIndex = null;
      _isListening = false;
    });

    _currentItem =
        _availableItems[_random.nextInt(_availableItems.length)];

    _options = [_currentItem!];
    final distractors = List.from(_availableItems)..remove(_currentItem);
    distractors.shuffle();

    while (_options.length < 4 && distractors.isNotEmpty) {
      _options.add(distractors.removeLast());
    }

    _options.shuffle();

    setState(() => _isLoading = false);

    await _ttsService.speak(
        "Level $currentLevel. Question ${currentQuestion + 1}. Identify the symbol.");
    _ttsService.speak(_currentItem!.dotsAudioDescription);
  }

  // ---------------- ANSWER ----------------
  Future<void> _checkAnswer(int index) async {
    if (_isCorrect != null) return;

    final correct = _options[index] == _currentItem;

    _sttService.stopListening();

    setState(() {
      _selectedIndex = index;
      _isCorrect = correct;
      _isListening = false;
      if (correct) correctInLevel++;
    });

    await _ttsService.stop();
    await _ttsService.speak(
      correct
          ? "Correct answer"
          : "Wrong answer. Correct answer is ${_currentItem!.displayName}",
    );
  }

  // ---------------- STT ----------------
  void _onSpeechResult(String text) {
    if (_isCorrect != null) return;

    final spoken = text.toLowerCase();

    if (spoken.contains('a')) _checkAnswer(0);
    else if (spoken.contains('b')) _checkAnswer(1);
    else if (spoken.contains('c')) _checkAnswer(2);
    else if (spoken.contains('d')) _checkAnswer(3);
  }

  void _startListening() async {
    if (_isListening || _isCorrect != null) return;

    setState(() => _isListening = true);

    await _ttsService.stop();
    await _ttsService.speak("Say option A, B, C or D");

    _sttService.startListening(_onSpeechResult);
  }

  void _nextQuestion() {
    setState(() => currentQuestion++);
    _loadQuestion();
  }

  void _finishLevel() {
    final passed = correctInLevel >= minCorrectToPass;

    _ttsService.speak(
      passed
          ? "Level completed. Moving to next level."
          : "Level failed. Try again.",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(passed ? "Level Completed 🎉" : "Level Failed ❌"),
        content: Text(
            passed ? "Proceed to next level" : "You need $minCorrectToPass correct answers"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (passed && currentLevel < levelMap.length) currentLevel++;
              _loadLevel();
            },
            child: Text(passed ? "Next Level" : "Retry"),
          )
        ],
      ),
    );
  }

  // ---------------- COLORS ----------------
  Color _optionColor(int i) {
    if (_isCorrect == null) return Colors.blue;

    if (_options[i] == _currentItem) return Colors.green;
    if (i == _selectedIndex) return Colors.red;

    return Colors.grey;
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.module} - Level $currentLevel"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Question ${currentQuestion + 1} / $questionsPerLevel"),
                  Text("Correct: $correctInLevel"),
                  const SizedBox(height: 20),

                  BrailleDotsWidget(item: _currentItem!, dotSize: 40),
                  const SizedBox(height: 20),

                  ..._options.asMap().entries.map((e) {
                    final i = e.key;
                    final letter = String.fromCharCode(65 + i);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _optionColor(i),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed:
                            _isCorrect == null ? () => _checkAnswer(i) : null,
                        child: Text(
                          "$letter : ${e.value.displayName}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _startListening,
                    icon: const Icon(Icons.mic),
                    label: const Text("Answer by Voice"),
                  ),

                  const SizedBox(height: 10),

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
