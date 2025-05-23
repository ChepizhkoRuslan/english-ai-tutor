import 'package:english_ai_tutor/features/voice_chat/voice_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/services/ai_service.dart';
import 'features/voice_chat/voice_chat_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const bool isCI = bool.fromEnvironment('CI', defaultValue: false);
  if (!isCI) {
    await dotenv.load(fileName: "env");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final aiService = AIService();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VoiceChatCubit(aiService)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: VoiceChatScreen(),
      ),
    );
  }
}
