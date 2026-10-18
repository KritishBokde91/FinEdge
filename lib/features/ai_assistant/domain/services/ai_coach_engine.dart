import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../budget_planner/domain/entities/budget_entity.dart';
import '../../../financial_goals/domain/entities/goal_entity.dart';
import '../../../../core/repositories/llm_repository.dart';

/// Data available to the AI coach from local repositories.
class AiDataContext {
  final List<TransactionEntity> transactions;
  final List<BudgetEntity> budgets;
  final List<GoalEntity> goals;

  const AiDataContext({
    required this.transactions,
    required this.budgets,
    required this.goals,
  });
}

/// AI coach engine using Groq tool/function-calling for minimal token usage.
///
/// Instead of dumping all data into the prompt, the AI declares which tool
/// it needs (e.g. get_spending_summary, get_budget_status), and the engine
/// executes that tool locally using Dart to compute the answer, then passes
/// only the compact JSON result back to Groq for the final reply.
class AiCoachEngine {
  final LlmRepository _llmRepo;
  final AiDataContext _context;

  const AiCoachEngine({
    required this._llmRepo,
    required this._context,
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Tool Schemas (sent to Groq — tells it what functions it can call)
  // ─────────────────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _tools = [
    {
      'type': 'function',
      'function': {
        'name': 'get_spending_summary',
        'description':
            'Get total income, expenses, and net savings for a period.',
        'parameters': {
          'type': 'object',
          'properties': {
            'period': {
              'type': 'string',
              'enum': ['current_month', 'last_month', 'last_3_months', 'all_time'],
              'description': 'The time period to summarize.',
            }
          },
          'required': ['period'],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_top_categories',
        'description': 'Get top spending categories ranked by amount.',
        'parameters': {
          'type': 'object',
          'properties': {
            'period': {
              'type': 'string',
              'enum': ['current_month', 'last_month', 'last_3_months'],
            },
            'limit': {
              'type': 'integer',
              'description': 'Number of categories to return (default 5)',
            },
          },
          'required': ['period'],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_budget_status',
        'description':
            'Get current budget utilization for all categories (spent vs limit).',
        'parameters': {
          'type': 'object',
          'properties': <String, dynamic>{},
          'required': <String>[],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_goal_progress',
        'description': 'Get progress towards all savings goals.',
        'parameters': {
          'type': 'object',
          'properties': <String, dynamic>{},
          'required': <String>[],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_spending_trend',
        'description': 'Get monthly expense totals for the last N months.',
        'parameters': {
          'type': 'object',
          'properties': {
            'months': {
              'type': 'integer',
              'description': 'Number of months of history (1–6)',
            }
          },
          'required': ['months'],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_merchant_breakdown',
        'description': 'Get top merchants by spending amount for a period.',
        'parameters': {
          'type': 'object',
          'properties': {
            'period': {
              'type': 'string',
              'enum': ['current_month', 'last_month'],
            },
            'limit': {'type': 'integer'},
          },
          'required': ['period'],
        },
      },
    },
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Tool Execution — local Dart computation, zero extra API calls
  // ─────────────────────────────────────────────────────────────────────────

  List<TransactionEntity> _filterByPeriod(String period) {
    final now = DateTime.now();
    return _context.transactions.where((tx) {
      switch (period) {
        case 'current_month':
          return tx.timestamp.year == now.year &&
              tx.timestamp.month == now.month;
        case 'last_month':
          final last = DateTime(now.year, now.month - 1);
          return tx.timestamp.year == last.year &&
              tx.timestamp.month == last.month;
        case 'last_3_months':
          return tx.timestamp
              .isAfter(now.subtract(const Duration(days: 92)));
        case 'all_time':
          return true;
        default:
          return tx.timestamp.year == now.year &&
              tx.timestamp.month == now.month;
      }
    }).toList();
  }

  String _executeTool(String name, Map<String, dynamic> args) {
    switch (name) {
      case 'get_spending_summary':
        return _spendingSummary(args['period'] as String);
      case 'get_top_categories':
        return _topCategories(
          args['period'] as String,
          limit: (args['limit'] as int?) ?? 5,
        );
      case 'get_budget_status':
        return _budgetStatus();
      case 'get_goal_progress':
        return _goalProgress();
      case 'get_spending_trend':
        return _spendingTrend((args['months'] as int?) ?? 3);
      case 'get_merchant_breakdown':
        return _merchantBreakdown(
          args['period'] as String,
          limit: (args['limit'] as int?) ?? 5,
        );
      default:
        return '{"error":"Unknown tool $name"}';
    }
  }

  String _spendingSummary(String period) {
    final txns = _filterByPeriod(period);
    double income = 0, expenses = 0;
    for (final tx in txns) {
      if (tx.isIncome) {
        income += tx.amount;
      } else {
        expenses += tx.amount;
      }
    }
    return jsonEncode({
      'period': period,
      'total_income_inr': income.toStringAsFixed(2),
      'total_expenses_inr': expenses.toStringAsFixed(2),
      'net_savings_inr': (income - expenses).toStringAsFixed(2),
      'transaction_count': txns.length,
    });
  }

  String _topCategories(String period, {int limit = 5}) {
    final txns = _filterByPeriod(period).where((tx) => !tx.isIncome);
    final Map<String, double> catMap = {};
    for (final tx in txns) {
      catMap[tx.category] = (catMap[tx.category] ?? 0) + tx.amount;
    }
    final sorted = catMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return jsonEncode({
      'period': period,
      'categories': sorted.take(limit).map((e) => {
            'category': e.key,
            'total_inr': e.value.toStringAsFixed(2),
          }).toList(),
    });
  }

  String _budgetStatus() {
    final catSpend = <String, double>{};
    for (final tx in _filterByPeriod('current_month').where((t) => !t.isIncome)) {
      catSpend[tx.category] = (catSpend[tx.category] ?? 0) + tx.amount;
    }
    return jsonEncode({
      'budgets': _context.budgets.map((b) {
        final spent = catSpend[b.category] ?? 0;
        final pct =
            b.limitAmount > 0 ? (spent / b.limitAmount * 100) : 0.0;
        return {
          'category': b.category,
          'limit_inr': b.limitAmount.toStringAsFixed(2),
          'spent_inr': spent.toStringAsFixed(2),
          'percent_used': pct.toStringAsFixed(1),
          'status': spent > b.limitAmount
              ? 'OVER_BUDGET'
              : (pct > 80 ? 'WARNING' : 'OK'),
        };
      }).toList(),
    });
  }

  String _goalProgress() {
    return jsonEncode({
      'goals': _context.goals.map((g) {
        final pct =
            g.targetAmount > 0 ? (g.currentAmount / g.targetAmount * 100) : 0.0;
        return {
          'title': g.title,
          'target_inr': g.targetAmount.toStringAsFixed(2),
          'saved_inr': g.currentAmount.toStringAsFixed(2),
          'percent_complete': pct.toStringAsFixed(1),
          'status': g.currentAmount >= g.targetAmount
              ? 'COMPLETED'
              : 'IN_PROGRESS',
        };
      }).toList(),
    });
  }

  String _spendingTrend(int months) {
    final now = DateTime.now();
    final trend = <Map<String, dynamic>>[];
    for (int i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final total = _context.transactions
          .where((tx) =>
              tx.timestamp.year == month.year &&
              tx.timestamp.month == month.month &&
              !tx.isIncome)
          .fold<double>(0, (sum, tx) => sum + tx.amount);
      trend.add({
        'month': DateFormat('MMM yyyy').format(month),
        'expenses_inr': total.toStringAsFixed(2),
      });
    }
    return jsonEncode({'trend': trend});
  }

  String _merchantBreakdown(String period, {int limit = 5}) {
    final txns = _filterByPeriod(period).where((tx) => !tx.isIncome);
    final Map<String, double> merchantMap = {};
    for (final tx in txns) {
      final key = tx.merchant.isNotEmpty ? tx.merchant : 'Unknown';
      merchantMap[key] = (merchantMap[key] ?? 0) + tx.amount;
    }
    final sorted = merchantMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return jsonEncode({
      'period': period,
      'merchants': sorted.take(limit).map((e) => {
            'merchant': e.key,
            'total_inr': e.value.toStringAsFixed(2),
          }).toList(),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Main entry point — Groq tool-calling loop
  // ─────────────────────────────────────────────────────────────────────────

  /// Processes user query with Groq tool-calling RAG.
  /// Falls back to local engine if API unavailable.
  Future<String> processQueryWithLLM(String userQuery) async {
    // Initial messages
    final messages = <LlmMessage>[
      LlmMessage(role: 'system', content: _llmRepo.getSystemPrompt()),
      LlmMessage(role: 'user', content: userQuery),
    ];

    // Pass 1: Groq decides which tools to call
    var result = await _llmRepo.sendMessage(
      messages: messages,
      tools: _tools,
    );

    // Tool-calling loop — Groq can chain multiple tool calls
    int maxIterations = 4;
    while (result.isToolCall && maxIterations-- > 0) {
      final toolCalls = result.toolCalls!;

      // Build assistant tool_calls message (Groq requires this in the history)
      final assistantMsg = LlmMessage(
        role: 'assistant',
        rawJson: {
          'role': 'assistant',
          'content': null,
          'tool_calls': toolCalls
              .map((tc) => {
                    'id': tc.id,
                    'type': 'function',
                    'function': {
                      'name': tc.name,
                      'arguments': jsonEncode(tc.arguments),
                    },
                  })
              .toList(),
        },
      );

      // Execute each tool locally and build tool result messages
      final toolResultMsgs = toolCalls.map((tc) {
        final resultJson = _executeTool(tc.name, tc.arguments);
        return LlmMessage(
          role: 'tool',
          content: resultJson,
          toolCallId: tc.id,
          name: tc.name,
        );
      }).toList();

      // Build the full updated conversation
      final updatedMessages = [
        ...messages,
        assistantMsg,
        ...toolResultMsgs,
      ];

      // Pass 2+: Groq generates final answer (or more tool calls)
      result = await _llmRepo.sendMessage(
        messages: updatedMessages,
        tools: _tools,
      );
    }

    return result.text ?? _offlineFallback(userQuery);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Offline fallback — works with zero API calls
  // ─────────────────────────────────────────────────────────────────────────

  String _offlineFallback(String query) {
    return _OfflineEngine(_context).process(query);
  }
}

/// Offline fallback engine — rule-based, no API needed.
class _OfflineEngine {
  final AiDataContext _ctx;
  _OfflineEngine(this._ctx);

  String process(String query) {
    final normalized = query.toLowerCase();
    final fmt = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);
    final now = DateTime.now();

    final monthTx = _ctx.transactions
        .where((tx) =>
            tx.timestamp.year == now.year && tx.timestamp.month == now.month)
        .toList();

    double income = 0, expenses = 0;
    final Map<String, double> catMap = {};
    for (final tx in monthTx) {
      if (tx.isIncome) {
        income += tx.amount;
      } else {
        expenses += tx.amount;
        catMap[tx.category] = (catMap[tx.category] ?? 0) + tx.amount;
      }
    }
    final balance = income - expenses;

    if (normalized.contains('spend') ||
        normalized.contains('expense') ||
        normalized.contains('outflow')) {
      if (expenses == 0) {
        return 'No expenses recorded this month yet. Pull to refresh on the dashboard to import SMS messages.';
      }
      final sorted = catMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.isNotEmpty ? sorted.first : null;
      return '## Expenses This Month\n\n'
          'Total: **${fmt.format(expenses)}**\n\n'
          '${top != null ? '**Top category**: ${top.key} — ${fmt.format(top.value)}' : ''}\n\n'
          '_Connect to Groq AI for deeper category breakdowns and advice._';
    }

    if (normalized.contains('income') ||
        normalized.contains('salary') ||
        normalized.contains('earn')) {
      return '## Income This Month\n\n'
          'Total income: **${fmt.format(income)}**\n'
          'Net savings: **${fmt.format(balance)}**';
    }

    if (normalized.contains('budget')) {
      if (_ctx.budgets.isEmpty) {
        return 'No budgets set yet. Go to the **Budgets** tab to create category limits!';
      }
      final buf = StringBuffer('## Budget Status\n');
      for (final b in _ctx.budgets) {
        final spent = catMap[b.category] ?? 0;
        final pct = (spent / b.limitAmount * 100).toStringAsFixed(0);
        buf.write(
            '\n- **${b.category}**: ${fmt.format(spent)} / ${fmt.format(b.limitAmount)} ($pct%)');
        if (spent > b.limitAmount) buf.write(' ⚠️ OVER BUDGET');
      }
      return buf.toString();
    }

    if (normalized.contains('goal') || normalized.contains('saving')) {
      if (_ctx.goals.isEmpty) {
        return 'No savings goals set. Create one in the **Goals** tab!';
      }
      final buf = StringBuffer('## Savings Goals\n');
      for (final g in _ctx.goals) {
        final pct =
            (g.currentAmount / g.targetAmount * 100).toStringAsFixed(0);
        buf.write(
            '\n- **${g.title}**: ${fmt.format(g.currentAmount)} / ${fmt.format(g.targetAmount)} ($pct%)');
        if (g.currentAmount >= g.targetAmount) buf.write(' 🎉 Complete!');
      }
      return buf.toString();
    }

    if (normalized.contains('summary') ||
        normalized.contains('status') ||
        normalized.contains('how am i')) {
      return '## Financial Summary — ${DateFormat('MMMM yyyy').format(now)}\n\n'
          '- **Income**: ${fmt.format(income)}\n'
          '- **Expenses**: ${fmt.format(expenses)}\n'
          '- **Net**: ${fmt.format(balance)}\n\n'
          '${balance >= 0 ? '✅ Positive cash flow! Keep it up.' : '⚠️ Spending exceeds income this month. Review your budgets.'}';
    }

    final tips = [
      'Pay yourself first — save 10–20% of income as soon as it arrives.',
      'Track small expenses. ₹150/day coffee = ₹4,500/month.',
      'Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings.',
      'Before any purchase over ₹2,000, wait 24 hours to avoid impulse buys.',
    ]..shuffle();

    return '💡 **Tip:** ${tips.first}\n\n'
        'Ask me about your **spending**, **income**, **budgets**, or **goals**.';
  }
}
