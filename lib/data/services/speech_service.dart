import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initialize({
    Function(SpeechRecognitionError)? onError,
    Function(String)? onStatus,
  }) async {
    return await _speech.initialize(
      onError: onError,
      onStatus: onStatus,
    );
  }

  Future<void> start(Function(String) onResult) async {
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
      ),
      localeId: 'en_US',
      pauseFor: const Duration(seconds: 30),
      listenFor: const Duration(seconds: 60),
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
