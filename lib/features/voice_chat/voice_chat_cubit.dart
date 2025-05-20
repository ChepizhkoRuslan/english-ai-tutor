import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/services/ai_service.dart';

part 'voice_chat_state.dart';

class VoiceChatCubit extends Cubit<VoiceChatState> {
  final AIService aiService;

  VoiceChatCubit(this.aiService) : super(VoiceChatState.initial());

  Future<void> sendVoiceMessage(String text) async {
    emit(state.copyWith(userMessage: text, isLoading: true));
    final reply = await aiService.getReply(text);
    emit(state.copyWith(aiMessage: reply, isLoading: false));
  }
}
