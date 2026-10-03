/// Repository managing LLM chatbot configuration parameters.
///
/// Ported from LlmRepository.kt.
class LlmRepository {
  const LlmRepository();

  /// Gets the system instruction prompt template.
  String getSystemPrompt() => 'You are FinSight AI assistant specialized in personal finances.';
}
