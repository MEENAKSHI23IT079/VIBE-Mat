import 'dart:math';
import 'package:flutter/material.dart';

import '../data/braille_data.dart';
import '../models/barille_item.dart';
import '../widgets/braille_dots_widget.dart';
import '../service/tts_service.dart';
import '../service/stt_service.dart';

class ChallengePage extends StatefulWidget {
  final String module;

  const ChallengePage({Key? key, required this.module}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final Random _random = Random();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  static const int _totalQuestions = 25;

  late List<BrailleItem> _questionPool;
  late List<BrailleItem> _questions;

  int _currentIndex = 0;
  int _score = 0;
  bool _finished = false;

  BrailleItem? _currentItem;
  List<BrailleItem> _options = [];

  @override
  void initState() {
    super.initState();
    _initChallenge();
  }

  Future<void> _initChallenge() async {
    await _ttsService.initialize();
    _ttsService.setSpeechRate(0.4); // slow voice

    await _sttService.initialize(
      (s) => debugPrint("STT: $s"),
      (e) => debugPrint("STT error: $e"),
    );

    _loadQuestions();
    _loadQuestion();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.stopListening();
    super.dispose();
  }

  // ---------------- LOAD DATA ----------------

  List<BrailleItem> _loadAllModuleItems() {
    final categories = widget.module == 'Science'
        ? [
            'Scientific Indicators',
            'Scientific Units',
            'Physics Symbols',
            'Chemistry Elements',
            'Biology Symbols',
          ]
        : [
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

    final List<BrailleItem> items = [];
    for (final c in categories) {
      items.addAll(getBrailleDataList(c));
    }
    return items;
  }

  void _loadQuestions() {
    _questionPool = _loadAllModuleItems()..shuffle();
    _questions = _questionPool.take(_totalQuestions).toList();
  }

  // ---------------- QUESTION FLOW ----------------

  Future<void> _loadQuestion() async {
    if (_currentIndex >= _questions.length) {
      _finishChallenge();
      return;
    }

    _currentItem = _questions[_currentIndex];

    _options = [_currentItem!];
    final distractors =
        List<BrailleItem>.from(_questionPool)..remove(_currentItem);
    distractors.shuffle();

    while (_options.length < 4) {
      _options.add(distractors.removeLast());
    }
    _options.shuffle();

    await _readQuestion();
    _listenForAnswer();
  }

  Future<void> _readQuestion() async {
    await _ttsService.stop();

    await _ttsService.speak(
      "Question ${_currentIndex + 1}. Identify this Braille symbol.",
    );

    await _ttsService.speak(_currentItem!.dotsAudioDescription);

    for (int i = 0; i < _options.length; i++) {
      final letter = String.fromCharCode(65 + i);
      await _ttsService.speak(
        "Option $letter. ${_options[i].displayName}",
      );
    }

    await _ttsService.speak(
      "Please say option A, B, C or D",
    );
  }

  // ---------------- VOICE ANSWER ----------------

  void _listenForAnswer() {
    _sttService.startListening(_processVoiceAnswer);
  }

  Future<void> _processVoiceAnswer(String text) async {
    _sttService.stopListening();
    final answer = text.toLowerCase();

    int? selectedIndex;

    if (answer.contains('a')) selectedIndex = 0;
    if (answer.contains('b')) selectedIndex = 1;
    if (answer.contains('c')) selectedIndex = 2;
    if (answer.contains('d')) selectedIndex = 3;

    if (selectedIndex == null) {
      await _ttsService.speak("I did not understand. Please repeat.");
      _listenForAnswer();
      return;
    }

    final correct = _options[selectedIndex] == _currentItem;

    if (correct) {
      _score++;
      await _ttsService.speak("Correct");
    } else {
      await _ttsService.speak(
        "Wrong. Correct answer is ${_currentItem!.displayName}",
      );
    }

    _currentIndex++;
    Future.delayed(const Duration(seconds: 1), _loadQuestion);
  }

  // ---------------- FINISH ----------------

  Future<void> _finishChallenge() async {
    setState(() => _finished = true);
    await _ttsService.speak(
      "Challenge completed. Your score is $_score out of $_totalQuestions",
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module} Voice Challenge'),
      ),
      body: _finished
          ? _buildResult()
          : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    return Center(
      child: _currentItem == null
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question ${_currentIndex + 1} / $_totalQuestions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                BrailleDotsWidget(item: _currentItem!, dotSize: 45),
                const SizedBox(height: 30),
                const Text(
                  'Answer using voice',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Challenge Complete 🎉',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text('Score: $_score / $_totalQuestions'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
}
