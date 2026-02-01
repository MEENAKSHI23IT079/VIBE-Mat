import 'dart:math';
import 'package:flutter/material.dart';

import '../data/braille_data.dart';
import '../models/barille_item.dart';
import '../widgets/braille_dots_widget.dart';
import '../service/tts_service.dart';

class ChallengePage extends StatefulWidget {
  final String module; // "Maths" or "Science"

  const ChallengePage({Key? key, required this.module}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final Random _random = Random();
  final TtsService _ttsService = TtsService();

  late List<BrailleItem> _availableItems;
  final int _totalQuestions = 10;

  int _score = 0;
  int _questionNumber = 0;
  bool _challengeFinished = false;

  BrailleItem? _currentItem;
  List<BrailleItem> _options = [];
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  String _statusText = '';

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _startChallenge();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  // ---------------- LOAD DATA ----------------

  List<BrailleItem> _loadModuleData() {
    final List<String> categories =
        widget.module == 'Science'
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
              ];

    final List<BrailleItem> items = [];

    for (final category in categories) {
      items.addAll(getBrailleDataList(category));
    }

    return items;
  }

  // ---------------- CHALLENGE FLOW ----------------

  void _startChallenge() {
    _availableItems = _loadModuleData();

    setState(() {
      _score = 0;
      _questionNumber = 0;
      _challengeFinished = false;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _statusText = '';
    });

    if (_availableItems.length < 4) {
      setState(() {
        _challengeFinished = true;
        _statusText = 'Not enough data for ${widget.module}';
      });
      return;
    }

    _loadNewQuestion();
  }

  Future<void> _loadNewQuestion() async {
    await _ttsService.stop();

    if (_questionNumber >= _totalQuestions) {
      setState(() => _challengeFinished = true);
      _ttsService.speak(
        "Challenge completed. Your score is $_score",
      );
      return;
    }

    setState(() {
      _questionNumber++;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _statusText = '';
    });

    _currentItem =
        _availableItems[_random.nextInt(_availableItems.length)];

    _options = [_currentItem!];
    final distractors = List.from(_availableItems)..remove(_currentItem);
    distractors.shuffle();

    while (_options.length < 4) {
      _options.add(distractors.removeLast());
    }

    _options.shuffle();

    _ttsService.speak(_currentItem!.dotsAudioDescription);
  }

  Future<void> _checkAnswer(int index) async {
    if (_isAnswered) return;

    final bool isCorrect = _options[index] == _currentItem;
    await _ttsService.stop();

    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = index;
      if (isCorrect) _score++;
      _statusText = isCorrect ? 'Correct!' : 'Wrong!';
    });

    _ttsService.speak(
      isCorrect
          ? "Correct answer"
          : "Wrong answer. The correct answer is ${_currentItem!.displayName}",
    );
  }

  // ---------------- UI HELPERS ----------------

  Color _getButtonColor(int index) {
    if (!_isAnswered) return Colors.blue;

    if (_options[index] == _currentItem) return Colors.green;
    if (index == _selectedOptionIndex) return Colors.red;

    return Colors.grey;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _challengeFinished
              ? '${widget.module} Challenge Complete'
              : '${widget.module} – Question $_questionNumber / $_totalQuestions',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: Text('Score: $_score')),
          )
        ],
      ),
      body: _challengeFinished
          ? _buildResultScreen()
          : _buildQuestionScreen(),
    );
  }

  Widget _buildQuestionScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Identify this ${widget.module} Braille notation',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          BrailleDotsWidget(item: _currentItem!, dotSize: 40),
          const SizedBox(height: 20),

          if (_statusText.isNotEmpty)
            Text(
              _statusText,
              style: TextStyle(
                fontSize: 16,
                color:
                    _statusText == 'Correct!' ? Colors.green : Colors.red,
              ),
            ),

          const SizedBox(height: 20),

          ..._options.asMap().entries.map((entry) {
            final int i = entry.key;
            final BrailleItem item = entry.value;
            final String label =
                String.fromCharCode(65 + i); // A B C D

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ElevatedButton(
                onPressed: () => _checkAnswer(i),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(i),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  '$label : ${item.displayName}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _isAnswered ? _loadNewQuestion : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next Question'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Challenge Complete! 🎉',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text('Score: $_score / $_totalQuestions'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _startChallenge,
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
}
