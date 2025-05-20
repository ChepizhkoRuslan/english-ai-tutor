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
  final aiService = AIService();
  final speechService = SpeechService();
  final ttsService = TTSService();

  @override
  void initState() {
    super.initState();
    speechService.initialize();
  }

  void startListening() {
    speechService.start((text) {
      context.read<VoiceChatCubit>().sendVoiceMessage(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoiceChatCubit(aiService),
      child: Scaffold(
        appBar: AppBar(title: const Text("Голосовой репетитор")),
        body: BlocConsumer<VoiceChatCubit, VoiceChatState>(
          listener: (context, state) {
            if (!state.isLoading && state.aiMessage.isNotEmpty) {
              ttsService.speak(state.aiMessage);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Вы сказали:\n${state.userMessage}",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Ответ AI:\n${state.aiMessage}",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  state.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                        icon: const Icon(Icons.mic),
                        label: const Text("Говорить"),
                        onPressed: startListening,
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
