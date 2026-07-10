import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/repository_providers.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/services/ai_coach_engine.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

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

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            'Hello! I am your FinSight AI coach. I analyze your transaction history on-device to help you manage your budget, track your goals, and discover savings.\n\nTry asking me something like:\n• "How much did I spend this month?"\n• "Give me a financial summary"\n• "Check my budgets"',
        isUser: false,
      ),
    );
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

  Future<void> _handleSend() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // Fetch live data from repositories/usecases to generate the dynamic response
    final txRepository = ref.read(transactionRepositoryProvider);
    final txSnapshot = await txRepository.watchAllTransactions().first;

    final budgetUseCase = ref.read(manageBudgetUseCaseProvider);
    final budgets = await budgetUseCase.watchBudgets().first;

    final goalUseCase = ref.read(manageGoalUseCaseProvider);
    final goals = await goalUseCase.watchGoals().first;

    // Simulate natural typing delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    const engine = AiCoachEngine();
    final responseText = engine.processQuery(
      query: query,
      transactions: txSnapshot,
      budgets: budgets,
      goals: goals,
    );

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(text: responseText, isUser: false));
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Financial Coach',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'On-device Offline Intelligence',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
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
            // --- Chat Bubble Feed ---
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.auto_awesome, size: 16),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            'FinSight AI is analyzing...',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: msg.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isUser) ...[
                          const CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.auto_awesome, size: 16),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(
                                  msg.isUser ? 16 : 0,
                                ),
                                bottomRight: Radius.circular(
                                  msg.isUser ? 0 : 16,
                                ),
                              ),
                              border: msg.isUser
                                  ? null
                                  : Border.all(color: theme.dividerColor),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                height: 1.4,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        if (msg.isUser) ...[
                          const SizedBox(width: AppSpacing.md),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white12,
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- Input Field Area ---
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask about spending, budgets, or goals...',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.borderLg,
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        filled: true,
                        fillColor: theme.cardColor,
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  IconButton.filled(
                    onPressed: _handleSend,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
