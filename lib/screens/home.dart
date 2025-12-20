import 'package:flutter/material.dart';
import '../service/stt_service.dart';
import 'dictionary_menu_page.dart';
import 'practice_page.dart';
import 'challenge_page.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SttService _sttService = SttService();
  // Use a more descriptive state variable
  String _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"';
  bool _sttAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeSttWithPermissions();
  }

  @override
  void dispose() {
    _sttService.cancelListening(); // Good practice to cancel on dispose
    super.dispose();
  }


  Future<void> _initializeSttWithPermissions() async {
    // Request permissions first
    bool permissionsGranted = await _requestPermissions();

    if (!permissionsGranted) {
      if (mounted) {
        setState(() {
          _sttAvailable = false;
          _voiceCommandStatus = 'Permissions denied. Voice commands unavailable.';
        });
      }
      return; // Don't initialize if permissions denied
    }

    // Permissions seem granted, now initialize STT
    _sttAvailable = await _sttService.initialize(
          (status) {
        print('STT Status: $status');
        if (status == 'done' && mounted && !_sttService.isListening.value) {
          // Reset status if listening finished without result/error
          // setState(() => _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"');
        }
      },
          (error) {
        print('STT Error: $error');
        if (mounted) {
          setState(() => _voiceCommandStatus = "STT Error: $error");
        }
      },
    );

    if (mounted) {
      setState(() {
        // Update status based on availability AFTER initialization attempt
        if (!_sttAvailable) {
          _voiceCommandStatus = 'Voice commands unavailable (STT failed).';
        } else {
          // Initial status if available
          _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"';
        }
      });
    }
  }

  Future<bool> _requestPermissions() async {
    var micStatus = await Permission.microphone.request();
    var speechStatus = await Permission.speech.request(); // Also request speech permission

    if (micStatus.isGranted && speechStatus.isGranted) {
      return true;
    } else {
      print("Permissions denied: Mic Granted: ${micStatus.isGranted}, Speech Granted: ${speechStatus.isGranted}");
      // Optionally show a more prominent message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone and Speech Recognition permissions are needed for voice commands.')),
      );
      return false;
    }
  }

  void _handleVoiceInput() {
    if (!_sttAvailable) return; // Don't start if not available

    if (_sttService.isListening.value) {
      _sttService.stopListening();
      // State update handled by ValueListenableBuilder
    } else {
      setState(() { _voiceCommandStatus = 'Listening...'; }); // Update status immediately
      _sttService.startListening(_handleVoiceCommand);
    }
  }


  void _handleVoiceCommand(String command) {
    final processedCommand = command.toLowerCase().trim();
    print("HomePage Recognized command: $processedCommand"); // Debugging

    // Make matching more flexible
    if (processedCommand.contains('dictionary') || processedCommand.contains('dictionaries')) {
      setState(() { _voiceCommandStatus = 'Navigating to Dictionary...'; });
      _navigateTo(context, const DictionaryMenuPage());
    } else if (processedCommand.contains('practice') || processedCommand.contains('practise')) {
      setState(() { _voiceCommandStatus = 'Navigating to Practice...'; });
      _navigateTo(context, const PracticePage());
    } else if (processedCommand.contains('challenge')) {
      setState(() { _voiceCommandStatus = 'Navigating to Challenge...'; });
      _navigateTo(context, const ChallengePage());
    } else if (processedCommand.isNotEmpty) {
      setState(() { _voiceCommandStatus = 'Command not recognized: "$processedCommand"';});
    } else {
      // If STT stops without a result (e.g., silence)
      setState(() { _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"';});
    }

    // Reset status briefly after navigation or non-recognition if desired
    // Future.delayed(const Duration(seconds: 2), () {
    //    if (mounted && !_sttService.isListening.value) { // Check if still mounted and not listening again
    //      setState(() => _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"');
    //    }
    // });
  }

  // Keep navigation helper separate
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      // This code runs when the user navigates *back* to the HomePage
      // Reset the status message when returning
      if (mounted && _sttAvailable) {
        setState(() {
          _voiceCommandStatus = 'Tap mic & say "Dictionary", "Practice", or "Challenge"';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braille Learning Hub'),
        actions: [
          // Show microphone icon only if STT is available
          if (_sttAvailable)
            ValueListenableBuilder<bool>(
                valueListenable: _sttService.isListening,
                builder: (context, isListening, child) {
                  return IconButton(
                    icon: Icon(isListening ? Icons.mic_off : Icons.mic, size: 28), // Slightly larger icon
                    tooltip: 'Use voice commands',
                    onPressed: _handleVoiceInput, // Use the dedicated handler
                  );
                }
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.book),
                label: const Text('Dictionary'),
                onPressed: () => _navigateTo(context, const DictionaryMenuPage()),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)), // Increase button height
              ),
              const SizedBox(height: 25), // Increase spacing
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Practice'),
                onPressed: () => _navigateTo(context, const PracticePage()),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: const Icon(Icons.emoji_events),
                label: const Text('Challenge'),
                onPressed: () => _navigateTo(context, const ChallengePage()),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
              ),
              const SizedBox(height: 50), // Increase spacing
              // Display Voice Command status clearly
              Text(
                _voiceCommandStatus,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: _voiceCommandStatus.startsWith("STT Error") || _voiceCommandStatus.startsWith("Permissions denied")
                      ? Colors.red
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}