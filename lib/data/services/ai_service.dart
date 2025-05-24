import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIService {

  Future<String> getReply(String userInput) async {
    String apiKey = '';
    bool isCI = bool.fromEnvironment('CI', defaultValue: false);
    if (!isCI) {
      apiKey = dotenv.get('GROG_API_KEY');
    } else {
      apiKey = String.fromEnvironment('GROG_API_KEY');
    }
    // final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",//"o4-mini",
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
      debugPrint("❌ OpenAI error: ${response.statusCode}");
      debugPrint("🔍 Response body: ${response.body}");
      return "Произошла ошибка. Попробуйте позже.";
    }
  }
}
