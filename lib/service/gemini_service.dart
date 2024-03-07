import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static Future<String> getResponse(String userPrompt) async {
    final apiKey = dotenv.env['API_KEY'] ?? "";
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    final prompt = userPrompt;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    log(response.text.toString());

    return response.text ?? "";
  }
}
