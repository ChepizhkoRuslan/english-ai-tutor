part of 'voice_chat_cubit.dart';

class VoiceChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;

  const VoiceChatState({
    required this.messages,
    required this.isLoading,
  });

  factory VoiceChatState.initial() => const VoiceChatState(
    messages: [],
    isLoading: false,
  );

  VoiceChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return VoiceChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [messages, isLoading];
}
