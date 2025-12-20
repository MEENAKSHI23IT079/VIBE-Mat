import 'package:flutter/material.dart';
import '../models/barille_item.dart';
import '../service/stt_service.dart';
import '../service/tts_service.dart';
import '../widgets/braille_dots_widget.dart';

class BrailleDisplayPage extends StatefulWidget {
  final List<BrailleItem> items;
  final String title;

  const BrailleDisplayPage({
    Key? key,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  _BrailleDisplayPageState createState() => _BrailleDisplayPageState();
}

class _BrailleDisplayPageState extends State<BrailleDisplayPage> {
  int _currentIndex = 0;
  final TtsService _ttsService = TtsService(); // Create instance here or get from Provider
  final SttService _sttService = SttService(); // Create instance here or get from Provider
  bool _sttAvailable = false;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initStt(); // Initialize STT for voice commands
  }

  Future<void> _initStt() async {
    // Only initialize if not already done (e.g., via Provider)
    _sttAvailable = await _sttService.initialize(
            (status) => print('STT Status: $status'), // Simple logging
            (error) => print('STT Error: $error')     // Simple logging
    );
    setState(() {}); // Update UI if needed based on availability
  }


  BrailleItem get currentItem => widget.items[_currentIndex];

  void _speakCurrentItem() {
    _ttsService.speak(currentItem.audioDescription);
  }

  void _goToNext() {
    if (_currentIndex < widget.items.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _speakCurrentItem(); // Speak the new item automatically
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _speakCurrentItem(); // Speak the new item automatically
    }
  }

  void _handleVoiceCommand(String command) {
    print("DisplayPage Recognized: $command");
    if (command.contains('next')) {
      _goToNext();
    } else if (command.contains('previous') || command.contains('back')) {
      _goToPrevious();
    } else if (command.contains('speak') || command.contains('read')) {
      _speakCurrentItem();
    }
    // Add other commands if needed
  }


  @override
  void dispose() {
    _ttsService.stop(); // Stop TTS when page is disposed
    _sttService.stopListening(); // Ensure STT stops
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_sttAvailable)
            ValueListenableBuilder<bool>(
                valueListenable: _sttService.isListening,
                builder: (context, isListening, child) {
                  return IconButton(
                    icon: Icon(isListening ? Icons.mic_off : Icons.mic),
                    tooltip: 'Voice commands: Next, Previous, Speak',
                    onPressed: () {
                      if (isListening) {
                        _sttService.stopListening();
                      } else {
                        _sttService.startListening(_handleVoiceCommand);
                      }
                    },
                  );
                }
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Display Character Name and Symbol
            Text(
              currentItem.name,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (currentItem.symbol.isNotEmpty && currentItem.symbol != currentItem.name)
              Text(
                '"${currentItem.symbol}"',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),

            // Display Braille Dots
            Center(child: BrailleDotsWidget(item: currentItem)),
            const SizedBox(height: 40),

            // Speak Button
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('Speak Description'),
              onPressed: _speakCurrentItem,
            ),
            const Spacer(), // Pushes navigation buttons to the bottom

            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  onPressed: _currentIndex > 0 ? _goToPrevious : null, // Disable if first item
                ),
                Text('${_currentIndex + 1} / ${widget.items.length}'), // Page number
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  onPressed: _currentIndex < widget.items.length - 1 ? _goToNext : null, // Disable if last item
                ),
              ],
            ),
            const SizedBox(height: 20), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}