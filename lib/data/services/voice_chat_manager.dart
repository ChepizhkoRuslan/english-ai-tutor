import 'package:english_ai_tutor/data/services/speech_service.dart';
import 'package:english_ai_tutor/data/services/tts_service.dart';
import '../../features/voice_chat/voice_chat_cubit.dart';
import '../models/chat_massage.dart';


class VoiceChatManager {
  final SpeechService speech;
  final TTSService tts;
  final VoiceChatCubit cubit;
  bool _active = false;

  VoiceChatManager({
    required this.speech,
    required this.tts,
    required this.cubit,
  });

  void start() {
    if (_active) return;
    _active = true;
    _listenLoop();
  }

  void stop() {
    _active = false;
    speech.stop();
    tts.stop();
  }

  void _listenLoop() async {
    final available = await speech.initialize(
      onError: (error) {
        print("❌ STT error: $error");
        if (error.errorMsg == 'error_speech_timeout' && _active) {
          _listenLoop(); // retry on timeout
        }
      },
      onStatus: (status) {
        print("🎙 Status: $status");
      },
    );

    if (!available) {
      print("🚫 Speech recognition not available");
      return;
    }

    speech.start((text) async {
      await speech.stop();
      final userMessage = ChatMessage(sender: 'user', text: text);
      cubit.emit(cubit.state.copyWith(
        isLoading: true,
        messages: [...cubit.state.messages, userMessage],
      ));

      final replyText = await cubit.aiService.getReply(text);
      final aiMessage = ChatMessage(sender: 'ai', text: replyText);

      cubit.emit(cubit.state.copyWith(
        isLoading: false,
        messages: [...cubit.state.messages, aiMessage],
      ));

      await tts.speak(replyText);
      if (_active) _listenLoop();
    });
  }
}

