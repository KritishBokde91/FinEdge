import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../../../core/repositories/llm_repository.dart';
import '../../../../core/supabase/supabase_client_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/services/ai_coach_engine.dart';
import '../widgets/typing_indicator_widget.dart';
import '../widgets/quick_chips_widget.dart';
import '../widgets/spending_chart_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ChatMessage model
// ─────────────────────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  /// Optional chart data extracted from AI response (category → amount).
  final Map<String, double>? chartData;
  final String? chartTitle;

  ChatMessage({
    String? id,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.chartData,
    this.chartTitle,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class AiAssistantPage extends ConsumerStatefulWidget {
  const AiAssistantPage({super.key});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isGroqConnected = false;

  @override
  void initState() {
    super.initState();
    _checkGroqConnection();
    _addWelcomeMessage();
  }

  void _checkGroqConnection() {
    _isGroqConnected = dotenv.isInitialized &&
        (dotenv.env['GROQ_API_KEY']?.isNotEmpty ?? false);
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: '''## 👋 Hello! I'm FinSight AI

I'm your personal finance coach — powered by **Groq AI** with real-time access to your transaction data.

**What I can do:**
- 📊 Analyze your spending patterns
- 💡 Identify budget overruns
- 🎯 Track your savings goals
- 📈 Show spending trends over time
- 🏪 Break down top merchant spend

Try one of the quick actions below, or ask me anything!''',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend([String? overrideQuery]) async {
    final query = overrideQuery ?? _controller.text.trim();
    if (query.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      // Fetch live data from repositories
      final txRepository = ref.read(transactionRepositoryProvider);
      final txSnapshot = await txRepository.watchAllTransactions().first;

      final budgetUseCase = ref.read(manageBudgetUseCaseProvider);
      final budgets = await budgetUseCase.watchBudgets().first;

      final goalUseCase = ref.read(manageGoalUseCaseProvider);
      final goals = await goalUseCase.watchGoals().first;

      // Build context and engine
      final context = AiDataContext(
        transactions: txSnapshot,
        budgets: budgets,
        goals: goals,
      );
      final engine = AiCoachEngine(
        llmRepo: const LlmRepository(),
        context: context,
      );

      // Get AI response (Groq tool-calling → local fallback)
      final responseText = await engine.processQueryWithLLM(query);

      // Try to extract chart data from the response
      final chartData = _extractChartData(responseText);

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: responseText,
            isUser: false,
            chartData: chartData,
            chartTitle: _inferChartTitle(query),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: '⚠️ Something went wrong: ${e.toString()}\n\nPlease try again.',
            isUser: false,
          ));
          _isTyping = false;
        });
      }
    }
  }

  /// Attempts to extract spending data from AI response text for chart display.
  /// Looks for patterns like "Food: ₹3,500" or JSON blocks.
  Map<String, double>? _extractChartData(String text) {
    // Try to parse JSON data blocks the AI might embed
    final jsonMatch = RegExp(r'\{[^{}]*"categories"\s*:\s*\[.*?\]\s*\}',
            dotAll: true)
        .firstMatch(text);
    if (jsonMatch != null) {
      try {
        final parsed = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
        final cats = parsed['categories'] as List?;
        if (cats != null) {
          final Map<String, double> result = {};
          for (final cat in cats) {
            final catMap = cat as Map<String, dynamic>;
            final name = catMap['category'] as String? ?? '';
            final amtStr =
                catMap['total_inr']?.toString() ?? '0';
            result[name] = double.tryParse(amtStr) ?? 0;
          }
          if (result.isNotEmpty) return result;
        }
      } catch (_) {}
    }

    // Fallback: parse "Label: ₹X,XXX" patterns from the text
    final pattern =
        RegExp(r'(?:\*\*)?([A-Za-z &]+)(?:\*\*)?\s*[:\-–]\s*₹?([\d,]+)');
    final matches = pattern.allMatches(text);
    if (matches.length >= 2) {
      final Map<String, double> result = {};
      for (final m in matches.take(6)) {
        final label = m.group(1)?.trim() ?? '';
        final amtStr = m.group(2)?.replaceAll(',', '') ?? '0';
        final amt = double.tryParse(amtStr);
        if (label.isNotEmpty && amt != null && amt > 0) {
          result[label] = amt;
        }
      }
      if (result.length >= 2) return result;
    }

    return null;
  }

  String? _inferChartTitle(String query) {
    final q = query.toLowerCase();
    if (q.contains('categor') || q.contains('spending')) return 'Spending by Category';
    if (q.contains('merchant')) return 'Top Merchants';
    if (q.contains('budget')) return 'Budget Utilization';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentSupabaseUserProvider);
    final cloudUser = userAsync.value ?? ref.watch(currentUserProvider);
    final isSignedIn = cloudUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Financial Coach',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _isGroqConnected ? '⚡ Powered by Groq AI' : '📱 On-device Mode',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (!isSignedIn)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                icon: const Icon(Icons.cloud_outlined, size: 18),
                label: const Text('Sign In'),
                onPressed: () => context.push('/cloud-login'),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: const Icon(
                  Icons.cloud_done_rounded,
                  size: 16,
                  color: Colors.green,
                ),
                label: Text(
                  cloudUser.email?.split('@').first ?? 'Synced',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                tooltip: 'Cloud Connected: ${cloudUser.email}\nYour data and insights are synced',
                onPressed: () => context.push('/profile'),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            tooltip: 'View SMS Logs',
            onPressed: () => context.push('/ai/sms_logs'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Cloud Status & Benefits Banner ─────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSignedIn
                    ? theme.colorScheme.primaryContainer.withOpacity(0.4)
                    : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSignedIn
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_queue_outlined,
                    size: 18,
                    color: isSignedIn
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isSignedIn
                          ? 'Cloud Connected: Backups, multi-device sync, and community rules active.'
                          : 'Sign in to enable automatic cloud backups and cross-device sync.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSignedIn ? FontWeight.w500 : FontWeight.normal,
                        color: isSignedIn
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (!isSignedIn)
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () => context.push('/cloud-login'),
                      child: const Text('Sign In', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),

            // ── Chat messages ──────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  // Typing indicator at end
                  if (index == _messages.length) {
                    return _buildTypingBubble(theme);
                  }
                  return _buildMessageBubble(_messages[index], theme);
                },
              ),
            ),

            // ── Quick action chips ─────────────────────────────────────────
            if (_messages.length <= 1)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: QuickChipsWidget(onChipTapped: _handleSend),
              ),

            // ── Input field ────────────────────────────────────────────────
            _buildInputBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Message bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft:
                          Radius.circular(msg.isUser ? 18 : 4),
                      bottomRight:
                          Radius.circular(msg.isUser ? 4 : 18),
                    ),
                  ),
                  child: msg.isUser
                      ? Text(
                          msg.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: msg.text,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              height: 1.5,
                            ),
                            strong: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            listBullet: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border(
                                left: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                          selectable: true,
                        ),
                ),

                // Embedded chart (AI responses only, when data available)
                if (!msg.isUser &&
                    msg.chartData != null &&
                    msg.chartData!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SpendingChartWidget(
                      data: msg.chartData!,
                      title: msg.chartTitle ?? 'Breakdown',
                    ),
                  ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTime(msg.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person_rounded,
                size: 16,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingBubble(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: const TypingIndicatorWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                hintText: 'Ask about spending, budgets, or goals...',
                hintStyle: TextStyle(
                  color: theme.hintColor,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                  borderSide:
                      BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filled(
            onPressed: _isTyping ? null : _handleSend,
            icon: _isTyping
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.day == now.day && dt.month == now.month && dt.year == now.year;
    if (isToday) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
