import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TTSService() {
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.45);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
    await _waitUntilDone();
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> _waitUntilDone() async {
    bool speaking = true;
    _tts.setCompletionHandler(() => speaking = false);
    while (speaking) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}