import 'package:english_ai_tutor/data/services/ai_service.dart';
import 'package:english_ai_tutor/data/services/speech_service.dart';
import 'package:english_ai_tutor/data/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'voice_chat_cubit.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final speechService = SpeechService();
  final ttsService = TTSService();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    await speechService.initialize();
    _startListening();
  }

  void _startListening() {
    if (isSpeaking) return; // не слушать во время TTS
    speechService.start((recognized) {
      if(recognized == "") return;
      speechService.stop(); // стоп на всякий случай
      Future.microtask(() {
        context.read<VoiceChatCubit>().sendVoiceMessage(recognized);
      });
    });

    // speechService.start((text) {
    //   print("✅ Распознано: $text");
    //   Future.microtask(() {
    //     context.read<VoiceChatCubit>().sendVoiceMessage(text);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Голосовой репетитор")),
      body: BlocConsumer<VoiceChatCubit, VoiceChatState>(
        listenWhen: (prev, curr) => prev.aiMessage != curr.aiMessage,
        listener: (context, state) async {
          if (state.aiMessage.isNotEmpty) {
            setState(() => isSpeaking = true);
            await ttsService.speak(state.aiMessage);
            setState(() => isSpeaking = false);
            _startListening(); // начать слушать снова
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: BlocBuilder<VoiceChatCubit, VoiceChatState>(
                  builder:
                      (context, state) => ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (state.userMessage.isNotEmpty)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("👤 ${state.userMessage}"),
                            ),
                          if (state.aiMessage.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("🤖 ${state.aiMessage}"),
                            ),
                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(isSpeaking ? "🔈 Speaking..." : "🎤 Listening..."),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
