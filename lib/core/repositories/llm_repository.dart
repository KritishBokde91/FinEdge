import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// A message in the LLM conversation.
class LlmMessage {
  final String role; // 'system' | 'user' | 'assistant' | 'tool'
  final String? content;
  final String? toolCallId;
  final String? name;
  /// Raw JSON for special assistant messages carrying tool_calls payload.
  final Map<String, dynamic>? rawJson;

  const LlmMessage({
    required this.role,
    this.content,
    this.toolCallId,
    this.name,
    this.rawJson,
  });

  Map<String, dynamic> toJson() {
    if (rawJson != null) return rawJson!;
    final map = <String, dynamic>{'role': role};
    if (content != null) map['content'] = content;
    if (toolCallId != null) map['tool_call_id'] = toolCallId;
    if (name != null) map['name'] = name;
    return map;
  }
}

/// A tool call requested by the LLM.
class LlmToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const LlmToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });
}

/// Result from the LLM — either a final text or a list of tool calls to execute.
class LlmResult {
  final String? text;
  final List<LlmToolCall>? toolCalls;
  final bool isToolCall;

  const LlmResult.text(String t)
      : text = t,
        toolCalls = null,
        isToolCall = false;

  const LlmResult.tools(List<LlmToolCall> calls)
      : text = null,
        toolCalls = calls,
        isToolCall = true;
}

/// Repository managing LLM API calls to Groq (primary) with Gemini as fallback.
/// Uses tool/function-calling so the AI fetches only the data it needs,
/// keeping token consumption minimal.
class LlmRepository {
  const LlmRepository();

  static const _groqBaseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  static String get _groqModel {
    if (!dotenv.isInitialized) return 'openai/gpt-oss-120b';
    return dotenv.env['GROQ_MODEL'] ?? 'openai/gpt-oss-120b';
  }

  String get _groqApiKey {
    if (!dotenv.isInitialized) return '';
    return dotenv.env['GROQ_API_KEY'] ?? '';
  }

  /// Returns the FinSight AI system persona prompt.
  String getSystemPrompt() => '''
You are FinSight AI, an expert personal finance advisor for Indian users.
You have access to the user's live financial data through tools — always call
the appropriate tool(s) before answering so your response is grounded in real data.

Guidelines:
- Use Markdown formatting: **bold**, bullet lists, ## headers
- Use ₹ for INR amounts
- Be concise but insightful; give actionable, specific advice
- Celebrate positive behaviors (savings streaks, staying under budget)
- When spending is high, suggest concrete ways to reduce it
- Always provide context for numbers ("that's X% of your income")
''';

  /// Sends a request to Groq with optional tool definitions.
  /// Returns [LlmResult] — either the final text or tool calls to execute.
  Future<LlmResult> sendMessage({
    required List<LlmMessage> messages,
    List<Map<String, dynamic>>? tools,
  }) async {
    final apiKey = _groqApiKey;
    if (apiKey.isEmpty) {
      return const LlmResult.text(
        '⚠️ AI is not configured.\n\nAdd your `GROQ_API_KEY` to the `.env` file to enable the AI assistant.',
      );
    }

    final body = <String, dynamic>{
      'model': _groqModel,
      'messages': messages.map((m) => m.toJson()).toList(),
      'max_tokens': 1024,
      'temperature': 0.7,
    };

    if (tools != null && tools.isNotEmpty) {
      body['tools'] = tools;
      body['tool_choice'] = 'auto';
    }

    try {
      final response = await http
          .post(
            Uri.parse(_groqBaseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        final errBody =
            jsonDecode(response.body) as Map<String, dynamic>;
        final errMsg =
            (errBody['error'] as Map?)?['message'] as String? ??
                'Unknown API error (${response.statusCode})';
        throw Exception(errMsg);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List;
      final firstChoice = choices.first as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      final finishReason = firstChoice['finish_reason'] as String?;

      // Model wants to call tools
      if (finishReason == 'tool_calls') {
        final rawToolCalls = message['tool_calls'] as List;
        final toolCallsList = rawToolCalls.map((tc) {
          final tcMap = tc as Map<String, dynamic>;
          final fn = tcMap['function'] as Map<String, dynamic>;
          return LlmToolCall(
            id: tcMap['id'] as String,
            name: fn['name'] as String,
            arguments: jsonDecode(fn['arguments'] as String)
                as Map<String, dynamic>,
          );
        }).toList();
        return LlmResult.tools(toolCallsList);
      }

      // Plain text response
      final text = message['content'] as String? ?? '';
      return LlmResult.text(text);
    } catch (e) {
      return LlmResult.text(
        '⚠️ AI temporarily unavailable — using on-device analysis.\n\n'
        '_Error: ${e.toString()}_',
      );
    }
  }
}
