import 'dart:math';
import 'package:flutter/material.dart';

import '../data/braille_data.dart';
import '../models/barille_item.dart';
import '../widgets/braille_dots_widget.dart';
import '../service/tts_service.dart';
import '../service/stt_service.dart'; // ✅ Speech-to-Text

class ChallengePage extends StatefulWidget {
  final String module; // "Maths" or "Science"

  const ChallengePage({Key? key, required this.module}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final Random _random = Random();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

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

  _sttService.initialize(
    (status) {
      debugPrint('STT Status: $status');
    },
    (error) {
      debugPrint('STT Error: $error');
    },
  );

  _startChallenge();
}

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.stopListening();
    super.dispose();
  }

  // ---------------- LOAD DATA ----------------

  List<BrailleItem> _loadModuleData() {
    final categories =
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
    await _sttService.stopListening();

    if (_questionNumber >= _totalQuestions) {
      setState(() => _challengeFinished = true);
      _ttsService.speak(
        "Challenge completed. Your score is $_score out of $_totalQuestions",
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

    // 🔊 Speak full question + options
    _speakQuestionAndOptions();
  }

  Future<void> _speakQuestionAndOptions() async {
    await _ttsService.speak(
      "Question $_questionNumber. Identify this ${widget.module} braille notation.",
    );

    await _ttsService.speak(_currentItem!.dotsAudioDescription);

    await _ttsService.speak("Options are.");

    for (int i = 0; i < _options.length; i++) {
      final label = String.fromCharCode(65 + i);
      await _ttsService.speak(
        "Option $label. ${_options[i].displayName}",
      );
    }

    await _ttsService.speak(
      "Please say A, B, C or D to answer.",
      onComplete: () {
        _sttService.startListening(_handleVoiceAnswer);
      },
    );
  }

  // ---------------- VOICE ANSWER ----------------

  void _handleVoiceAnswer(String spokenText) {
    if (_isAnswered) return;

    spokenText = spokenText.toLowerCase();

    if (spokenText.contains('a')) _checkAnswer(0);
    else if (spokenText.contains('b')) _checkAnswer(1);
    else if (spokenText.contains('c')) _checkAnswer(2);
    else if (spokenText.contains('d')) _checkAnswer(3);
    else {
      _ttsService.speak(
        "I didn't understand. Please say A, B, C or D.",
        onComplete: () {
          _sttService.startListening(_handleVoiceAnswer);
        },
      );
    }
  }

  // ---------------- CHECK ANSWER ----------------

  Future<void> _checkAnswer(int index) async {
    if (_isAnswered) return;

    final bool isCorrect = _options[index] == _currentItem;

    await _ttsService.stop();
    await _sttService.stopListening();

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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            final i = entry.key;
            final item = entry.value;
            final label = String.fromCharCode(65 + i);

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
            'Challenge Complete!',
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
