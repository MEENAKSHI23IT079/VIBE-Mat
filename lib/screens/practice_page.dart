import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/braille_data.dart';
import '../models/barille_item.dart';
import '../widgets/braille_dots_widget.dart';
import '../service/tts_service.dart';
import '../service/stt_service.dart';

class PracticePage extends StatefulWidget {
  final String module;

  const PracticePage({Key? key, required this.module}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final Random _random = Random();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();
  final TextEditingController _answerController = TextEditingController();

  // ---------- LEVEL CONFIG ----------
  final int questionsPerLevel = 5;

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

  // ---------- STATE ----------
  int currentLevel = 1;
  int currentQuestion = 0;
  int attemptsForQuestion = 0;
  int totalAttempts = 0;

  late List<BrailleItem> _items;
  BrailleItem? _currentItem;

  late DateTime _levelStartTime;

  bool _listening = false;
  String _feedback = '';

  // ---------- INIT ----------
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
    _answerController.dispose();
    super.dispose();
  }

  // ---------- LEVEL ----------
  void _loadLevel() {
    _items = List.from(getBrailleDataList(levelMap[currentLevel]!));
    currentQuestion = 0;
    totalAttempts = 0;
    _levelStartTime = DateTime.now();
    _nextQuestion();
  }

  Future<void> _nextQuestion() async {
    _currentItem = _items[_random.nextInt(_items.length)];
    attemptsForQuestion = 0;
    _feedback = '';
    _answerController.clear();
    await _sttService.stopListening();
    await _ttsService.speak(
      "Level $currentLevel of ${levelMap.length}. "
      "Question ${currentQuestion + 1}. Identify this Braille symbol.",
    );
    await _sttService.stopListening();
    await _ttsService.speak(_currentItem!.dotsAudioDescription);
    setState(() {});
  }

  // ---------- ANSWER CHECK ----------
  Future<void> _checkAnswer(String answer) async {
  attemptsForQuestion++;
  totalAttempts++;

  final userAnswer = answer.trim().toLowerCase();

  final correctName = _currentItem!.name.toLowerCase();
  final correctSymbol = _currentItem!.symbol.toLowerCase();

  final bool isCorrect =
      userAnswer == correctName ||
      userAnswer == correctSymbol;

  if (!isCorrect) {
    _feedback = "Incorrect. Try again.";
    await _sttService.stopListening();
    await _ttsService.speak(
      "Incorrect. Please try again. Identify the braille symbol.",
    );
    setState(() {});
    return;
  }

  // ✅ CORRECT ANSWER
  _feedback = "Correct!";
  await _sttService.stopListening();
  await _ttsService.speak("Correct answer.");

  currentQuestion++;

  if (currentQuestion >= questionsPerLevel) {
    _finishLevel();
  } else {
    _nextQuestion();
  }
}


  // ---------- STT ----------
  void _startListening() async {
    if (_listening) return;

    setState(() => _listening = true);
    await _sttService.stopListening();
    await _ttsService.speak("Please say your answer");
    _sttService.startListening(_onSpeechResult);
  }

  void _onSpeechResult(String text) {
    _sttService.stopListening();
    setState(() => _listening = false);
    _checkAnswer(text);
  }

  // ---------- FINISH LEVEL ----------
  void _finishLevel() async {
    final duration =
        DateTime.now().difference(_levelStartTime).inSeconds;

    final message = duration < 60
        ? "Excellent speed and accuracy!"
        : duration < 120
            ? "Good job. Keep practicing!"
            : "Practice makes progress. Never give up!";
    await _sttService.stopListening();
    await _ttsService.speak(
      "Level completed. You took $duration seconds "
      "with $totalAttempts attempts. $message",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Level Complete 🎉"),
        content: Text(
          "Time: $duration seconds\n"
          "Attempts: $totalAttempts\n\n"
          "$message",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (currentLevel < levelMap.length) {
                currentLevel++;
                _loadLevel();
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              currentLevel < levelMap.length
                  ? "Next Level"
                  : "Finish",
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.module} Practice (Level $currentLevel / ${levelMap.length})"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _currentItem == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // LEVEL INFO CARD
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Level $currentLevel of ${levelMap.length} — "
                        "${levelMap[currentLevel]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  BrailleDotsWidget(item: _currentItem!, dotSize: 42),
                  const SizedBox(height: 20),

                  // TEXT INPUT FOR SIGHTED USERS
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: "Type your answer",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _checkAnswer,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.mic),
                    label: const Text("Answer by Voice"),
                    onPressed: _startListening,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _feedback,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
