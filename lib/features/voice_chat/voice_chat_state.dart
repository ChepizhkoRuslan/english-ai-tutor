part of 'voice_chat_cubit.dart';

class VoiceChatState extends Equatable {
  final String userMessage;
  final String aiMessage;
  final bool isLoading;

  const VoiceChatState({
    required this.userMessage,
    required this.aiMessage,
    required this.isLoading,
  });

  factory VoiceChatState.initial() => const VoiceChatState(
    userMessage: '',
    aiMessage: '',
    isLoading: false,
  );

  VoiceChatState copyWith({
    String? userMessage,
    String? aiMessage,
    bool? isLoading,
  }) {
    return VoiceChatState(
      userMessage: userMessage ?? this.userMessage,
      aiMessage: aiMessage ?? this.aiMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [userMessage, aiMessage, isLoading];
}
