import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> initialize() async {
    await _speech.initialize();
  }

  void start(Function(String) onResult) {
    _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  void stop() {
    _speech.stop();
  }
}

