import 'package:english_ai_tutor/data/services/speech_service.dart';
import 'package:english_ai_tutor/data/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/voice_chat_manager.dart';
import 'voice_chat_cubit.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  late final VoiceChatManager chatManager;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<VoiceChatCubit>();
    chatManager = VoiceChatManager(
      speech: SpeechService(),
      tts: TTSService(),
      cubit: cubit,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatManager.start();
    });
  }

  @override
  void dispose() {
    chatManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Голосовой репетитор")),
      body: BlocBuilder<VoiceChatCubit, VoiceChatState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[state.messages.length - 1 - index];
                    final isUser = msg.sender == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}