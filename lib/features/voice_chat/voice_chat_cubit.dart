import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/ai_service.dart';

part 'voice_chat_state.dart';

class VoiceChatCubit extends Cubit<VoiceChatState> {
  final AIService aiService;

  VoiceChatCubit(this.aiService) : super(VoiceChatState.initial());

  Future<void> sendVoiceMessage(String text) async {
    final userMsg = ChatMessage(sender: 'user', text: text);
    emit(
      state.copyWith(isLoading: true, messages: [...state.messages, userMsg]),
    );

    final reply = await aiService.getReply(text);
    final aiMsg = ChatMessage(sender: 'ai', text: reply);
    emit(
      state.copyWith(isLoading: false, messages: [...state.messages, aiMsg]),
    );
  }

  void addUserMessage(String text) {
    final msg = ChatMessage(sender: 'user', text: text);
    emit(state.copyWith(isLoading: true, messages: [...state.messages, msg]));
  }

  void addAIMessage(String text) {
    final msg = ChatMessage(sender: 'ai', text: text);
    emit(state.copyWith(isLoading: false, messages: [...state.messages, msg]));
  }
}
