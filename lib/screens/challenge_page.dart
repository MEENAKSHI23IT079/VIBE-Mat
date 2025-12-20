import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/braille_data.dart';
import '../widgets/braille_dots_widget.dart';

import '../models/barille_item.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  // --- State Variables ---
  final Random _random = Random();
  final TtsService _ttsService = TtsService(); // Uses the updated service
  final SttService _sttService = SttService();
  bool _sttAvailable = false;
  bool _permissionsGranted = false;

  late List<BrailleItem> _availableItems;
  final int _totalQuestions = 10;

  int _score = 0;
  int _questionNumber = 0;
  bool _challengeFinished = false;

  BrailleItem? _currentItem;
  List<BrailleItem> _options = [];
  int? _selectedOptionIndex;
  bool _isAnswered = false; // Track if current question has been answered
  bool _isLoading = true;
  String _sttStatusInfo = 'Initializing...';
  bool _isSpeaking = false; // Flag to track if TTS is active
  bool _availableItemsInitialized = false;

  // --- Initialization and Permissions ---

  @override
  void initState() {
    super.initState();
    _initializeSequence();
  }

  Future<void> _initializeSequence() async {
    _permissionsGranted = await _requestPermissions();
    await _ttsService.initialize(); // Ensure TTS is ready

    if (!_availableItemsInitialized) {
      _availableItems = List.from(allBrailleItems);
      _availableItemsInitialized = true;
    }

    if (!_permissionsGranted) {
      if (mounted) {
        setState(() {
          _sttStatusInfo = 'Permissions denied. Voice commands disabled.';
          _isLoading = false;
          _startChallenge(); // Try to start challenge without voice
        });
      }
      return;
    }

    _sttAvailable = await _sttService.initialize(
      _onSttStatus,
      _onSttError,
    );

    if (mounted) {
      setState(() {
        _sttStatusInfo = _sttAvailable
            ? 'Loading Challenge...'
            : 'STT initialization failed. Voice commands disabled.';
      });
      _startChallenge(); // Start challenge after STT init attempt
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
        } else if (error.contains("busy")) {
          _sttStatusInfo = 'Speech service busy. Please wait.';
        } else {
          _sttStatusInfo = "STT Error. Try again.";
        }
        _isSpeaking = false; // Ensure speaking flag is reset on error
      });
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.cancelListening();
    super.dispose();
  }

  void _handleNoItems() {
    setState(() {
      _isLoading = false;
      _challengeFinished = true; // Cannot run challenge
      _currentItem = null;
      _sttStatusInfo = 'Not enough Braille items for challenge (need >= 4).';
    });
  }

  // --- Speaking Functions ---

  Future<void> _speakDots(BrailleItem item) async {
    try {
      if (mounted) setState(() => _isSpeaking = true);
      await _ttsService.speak(item.dotsAudioDescription);
    } catch (e) {
      if (kDebugMode) print("Error speaking dots: $e");
    } finally {
      if (mounted && _isSpeaking) setState(() => _isSpeaking = false);
    }
  }


  Future<void> _speakOptions() async {
    if (_options.isEmpty || !mounted || _isAnswered || _challengeFinished) return; // Dont speak if answered/finished

    try {
      if (mounted) setState(() => _isSpeaking = true);
      await Future.delayed(const Duration(milliseconds: 400));

      for (int i = 0; i < _options.length; i++) {
        if (!mounted || _isAnswered || _challengeFinished || !_isSpeaking) break; // Stop if state changes or stop requested
        final option = _options[i];
        final optionLetter = String.fromCharCode('A'.codeUnitAt(0) + i);
        final textToSpeak = "Option $optionLetter. ${option.displayName}.";
        if (kDebugMode) print("Speaking: $textToSpeak");

        await _ttsService.speak(textToSpeak); // Awaits completion

        if (i < _options.length - 1 && mounted && !_isAnswered && !_challengeFinished && _isSpeaking) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
    } catch (e) {
      if (kDebugMode) print("Error speaking options: $e");
    } finally {
      if (mounted && _isSpeaking) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  // --- Challenge Flow Logic ---

  void _startChallenge() {
    if (!_availableItemsInitialized) {
      _availableItems = List.from(allBrailleItems);
      _availableItemsInitialized = true;
    }

    _score = 0;
    _questionNumber = 0;
    _challengeFinished = false;
    _isAnswered = false;
    _selectedOptionIndex = null;
    _isLoading = true;
    _isSpeaking = false; // Reset speaking flag
    _sttStatusInfo = _sttAvailable
        ? 'Loading Challenge...'
        : 'Voice commands disabled.';


    if (_availableItems.isNotEmpty && _availableItems.length >= 4) {
      _loadNewQuestion(); // Load the first question
    } else {
      _handleNoItems(); // Handle insufficient items
    }
  }


  void _loadNewQuestion() {
    if (_questionNumber >= _totalQuestions) {
      setState(() {
        _challengeFinished = true;
        _isLoading = false;
        _isSpeaking = false;
        _sttStatusInfo = 'Challenge Complete!';
      });
      _ttsService.stop(); // Stop any lingering speech
      return;
    }

    _questionNumber++;

    setState(() {
      _isLoading = true;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _isSpeaking = false; // Reset speaking flag
      _sttStatusInfo = _sttAvailable
          ? 'Loading...'
          : 'Voice commands disabled.';
    });
    _ttsService.stop(); // Stop any previous speech first

    // Select item and options
    final int randomIndex = _random.nextInt(_availableItems.length);
    _currentItem = _availableItems[randomIndex];
    _options = [_currentItem!];
    final List<BrailleItem> distractorsPool = List.from(_availableItems)
      ..removeWhere((item) => item == _currentItem);
    distractorsPool.shuffle(_random);
    while (_options.length < 4 && distractorsPool.isNotEmpty) {
      _options.add(distractorsPool.removeLast());
    }
    while(_options.length < 4 && _availableItems.isNotEmpty) {
      _options.add(_availableItems[_random.nextInt(_availableItems.length)]);
    }
    _options.shuffle(_random);

    // Speak dots then options after UI builds
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() { _isLoading = false; }); // Visual loading finished
        try {
          // Ensure not interrupted before starting speech
          if (!mounted || _isAnswered || _challengeFinished) return;
          await _speakDots(_currentItem!);

          if (mounted && !_isAnswered && !_challengeFinished) { // Check again after dots speak
            await _speakOptions();
            // Update status only after speaking finishes (if not answered yet)
            if (mounted && !_isAnswered && !_challengeFinished) {
              setState(() => _sttStatusInfo = _sttAvailable ? 'Tap mic or say command' : 'Voice commands disabled.');
            }
          }
        } catch (e) {
          if(kDebugMode) print("Error during initial speak sequence: $e");
          if(mounted) {
            setState(() {
              _isSpeaking = false; // Ensure flag is reset on error
              _sttStatusInfo = "Error during speech. Tap mic or select.";
            });
          }
        }
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    _ttsService.stop(); // Immediately request TTS stop

    // Guard against multiple answers, invalid index
    if (_isAnswered || selectedIndex < 0 || selectedIndex >= _options.length) {
      if (kDebugMode) print("Answer check blocked: isAnswered=$_isAnswered, index=$selectedIndex");
      return;
    }
    if (kDebugMode) print("Checking answer for index: $selectedIndex");

    bool isCorrect = (_options[selectedIndex] == _currentItem);

    setState(() {
      _isAnswered = true; // Mark as answered
      _selectedOptionIndex = selectedIndex;
      if (isCorrect) {
        _score++;
      }
      _sttStatusInfo = isCorrect ? 'Correct! Tap Next.' : 'Incorrect. Tap Next.';
      _isSpeaking = false; // Ensure flag is false
      if (_sttService.isListening.value) _sttService.stopListening(); // Stop STT if active
    });
  }


  // --- Voice Command Handling ---

  void _handleVoiceInput() {
    // Ensure STT is available, permissions granted, not loading, not answered, not speaking, not finished
    if (!_sttAvailable || !_permissionsGranted || _isLoading || _isAnswered || _isSpeaking || _challengeFinished) {
      if (kDebugMode) {
        print("Voice input blocked: available=$_sttAvailable, granted=$_permissionsGranted, loading=$_isLoading, answered=$_isAnswered, speaking=$_isSpeaking, finished=$_challengeFinished");
      }
      // Provide feedback
      if (_isSpeaking) _ttsService.speak("Please wait until options are read.");
      else if (_isAnswered) _ttsService.speak("Please tap Next first.");
      else if (_isLoading) _ttsService.speak("Please wait.");
      else if (_challengeFinished) _ttsService.speak("Challenge is finished.");
      return;
    }

    _ttsService.stop(); // Stop any ongoing speech

    if (_sttService.isListening.value) {
      _sttService.stopListening();
      if (mounted) setState(() => _sttStatusInfo = 'Tap mic or say command');
    } else {
      if (mounted) setState(() => _sttStatusInfo = 'Listening...');
      _sttService.startListening(_processVoiceResult);
    }
  }

  void _processVoiceResult(String result) {
    // Check state again, including _isSpeaking
    if (_isAnswered || _isLoading || !mounted || _isSpeaking || _challengeFinished) return;

    final command = result.toLowerCase().trim();
    if (kDebugMode) print("Raw Voice Result: '$result', Processed: '$command'");

    int? answerIndex;

    // Matching logic (robust matching)
    if (command.startsWith('a') || command == 'hey' || command == 'ay' || command == 'option a') answerIndex = 0;
    else if (command.startsWith('b') || command == 'be' || command == 'bee' || command == 'option b') answerIndex = 1;
    else if (command.startsWith('c') || command == 'sea' || command == 'see' || command == 'option c') answerIndex = 2;
    else if (command.startsWith('d') || command == 'dee' || command == 'option d') answerIndex = 3;
    // No Hint command
    else if (command.contains('option') || command.contains('repeat') || command.contains('choices')) {
      if (kDebugMode) print("Voice command: Repeat options");
      _speakOptions(); // Call the function to speak options again
      return;
    }

    if (answerIndex != null && answerIndex < _options.length) {
      if (kDebugMode) print("Voice command maps to index: $answerIndex");
      _checkAnswer(answerIndex); // Check answer will stop TTS
    } else if (command.isNotEmpty) {
      if (kDebugMode) print("Unrecognized command: $command");
      if (mounted) setState(() { _sttStatusInfo = 'Command "$command" not recognized.';});
      _ttsService.speak('Command not recognized');
    } else {
      // Likely silence or error handled by _onSttError
      if (mounted && !_sttService.isListening.value) { // Reset if listening stopped without result
        setState(() { _sttStatusInfo = 'Tap mic or say command';});
      }
    }
  }


  // --- UI Build ---

  Color _getButtonColor(int optionIndex) {
    if (!_isAnswered) {
      // Default button color before answering
      return Theme.of(context).colorScheme.secondary;
    }
    // After answer is submitted:
    if (_options[optionIndex] == _currentItem) {
      // Always show the correct answer in green
      return Colors.green.shade400;
    } else if (optionIndex == _selectedOptionIndex) {
      // If this incorrect option was selected, show it in red
      return Colors.red.shade400;
    } else {
      // Other incorrect, unselected options fade out
      return Colors.grey.shade400;
    }
  }


  @override
  Widget build(BuildContext context) {
    // Determine if the mic button should be enabled
    bool canUseVoice = _sttAvailable && _permissionsGranted && !_isLoading && !_isAnswered && !_challengeFinished && !_isSpeaking;

    return Scaffold(
      appBar: AppBar(
        title: Text(_challengeFinished
            ? 'Challenge Complete!'
            : 'Challenge Q: ${_questionNumber > _totalQuestions ? _totalQuestions : _questionNumber}/$_totalQuestions'),
        actions: _challengeFinished ? null : [
          // Score Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: Text('Score: $_score', style: const TextStyle(fontSize: 18))),
          ),
          // Mic button
          ValueListenableBuilder<bool>(
              valueListenable: _sttService.isListening,
              builder: (context, isListening, child) {
                return IconButton(
                  icon: Icon(isListening ? Icons.mic_off : Icons.mic),
                  iconSize: 28,
                  tooltip: canUseVoice
                      ? (isListening ? 'Stop listening' : 'Use voice (A,B,C,D, Repeat Options)')
                      : (_isSpeaking ? 'Speaking...' : 'Voice commands unavailable'),
                  onPressed: canUseVoice ? _handleVoiceInput : null,
                  color: canUseVoice ? Theme.of(context).colorScheme.onPrimary : Colors.grey.shade400, // Use theme color or grey
                );
              }
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading && !_challengeFinished && _questionNumber <= 1 // Show loading indicator only before first question loads
          ? const Center(child: CircularProgressIndicator())
          : _challengeFinished
          ? _buildResultsScreen()
          : _currentItem == null // Handle case where challenge couldn't start properly
          ? Center(child: Text(_sttStatusInfo))
          : _buildQuestionScreen(),
    );
  }


  // Widget for displaying the current question
  Widget _buildQuestionScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded( // Make content scrollable
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Identify this Braille symbol:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row( // Speak buttons
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.volume_up, size: 20),
                          label: const Text('Dots'),
                          // Disable while loading or speaking
                          onPressed: (_isLoading || _isSpeaking) ? null : () => _speakDots(_currentItem!),
                        ),
                        const SizedBox(width: 20),
                        TextButton.icon( // Repeat options button
                          icon: const Icon(Icons.list, size: 20),
                          label: const Text('Options'),
                          // Disable while loading/speaking or if no options/answered/finished
                          onPressed: (_isLoading || _isSpeaking || _options.isEmpty || _isAnswered || _challengeFinished) ? null : _speakOptions,
                        ),
                      ]
                  ),
                  const SizedBox(height: 10),
                  if (_currentItem != null)
                    BrailleDotsWidget(item: _currentItem!, dotSize: 40),
                  const SizedBox(height: 15),
                  // STT Status / Feedback
                  Text(
                    _sttStatusInfo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: _sttStatusInfo.contains("Error") || _sttStatusInfo.contains("denied") || _sttStatusInfo.contains("disabled")
                            ? Colors.red.shade700
                            : (!_isAnswered ? Colors.grey.shade700 : (_options[_selectedOptionIndex!] == _currentItem ? Colors.green.shade700 : Colors.red.shade700))
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options Area
                  ..._options.asMap().entries.map((entry) {
                    int index = entry.key;
                    BrailleItem option = entry.value;
                    String optionLetter = String.fromCharCode('A'.codeUnitAt(0) + index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                        // Disable button if answer already submitted or speaking
                        onPressed: (_isAnswered || _isSpeaking) ? null : () => _checkAnswer(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getButtonColor(index),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          '$optionLetter: ${option.displayName}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ), // Expanded

          // Action Button Area (Fixed at bottom)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next Question'),
                // Enable only after answering
                onPressed: _isAnswered ? _loadNewQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for displaying the final results
  Widget _buildResultsScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_currentItem == null && !_availableItemsInitialized) // Check if challenge couldn't start due to no items
              Text(
                _sttStatusInfo, // Display the error message
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              )
            else // Normal results display
              ...[
                Text(
                  'Challenge Complete!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Final Score:',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$_score / $_totalQuestions',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],

            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Play Again'),
              onPressed: _startChallenge, // Restart the challenge
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Menu'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

} // End of _ChallengePageState