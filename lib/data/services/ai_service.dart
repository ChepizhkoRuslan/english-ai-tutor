import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = dotenv.isInitialized
      ? dotenv.env['OPENAI_API_KEY'] ?? ''
      : '';

  Future<String> getReply(String userInput) async {
    final url = Uri.parse('https://api.openai.com/v1/voice_chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {
            "role": "system",
            "content": "Ты — доброжелательный репетитор английского языка.",
          },
          {"role": "user", "content": userInput},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      return "Произошла ошибка. Попробуйте позже.";
    }
  }
}
