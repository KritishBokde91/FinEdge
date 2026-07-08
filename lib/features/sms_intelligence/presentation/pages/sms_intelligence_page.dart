import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../shared/widgets/sms/sms_message_card.dart';
import '../../../../shared/widgets/sms/parsed_sms_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/sms_entity.dart';
import '../../domain/services/sms_parser.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class SmsIntelligencePage extends ConsumerWidget {
  const SmsIntelligencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final smsRepository = ref.watch(smsRepositoryProvider);
    final txRepository = ref.watch(transactionRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SMS Intelligence Engine',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.h4,
                  Text(
                    'Analyzed financial incoming messages on-device',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<SmsEntity>>(
                stream: smsRepository.watchAllSms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No SMS messages registered yet.',
                        style: TextStyle(color: theme.hintColor),
                      ),
                    );
                  }

                  return StreamBuilder<List<TransactionEntity>>(
                    stream: txRepository.watchAllTransactions(),
                    builder: (context, txSnapshot) {
                      final transactions =
                          txSnapshot.data ?? const <TransactionEntity>[];
                      final transactionsBySmsId = <String, TransactionEntity>{};
                      for (final tx in transactions) {
                        final smsId = tx.smsId;
                        if (smsId != null) transactionsBySmsId[smsId] = tx;
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final sms = messages[index];
                          final transaction = transactionsBySmsId[sms.id];
                          final fallback = transaction == null
                              ? SmsParser.parseMessage(sms.sender, sms.body)
                              : null;
                          final hasFallback =
                              fallback != null &&
                              fallback.amount > 0 &&
                              fallback.transactionType != 'unknown';

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmsMessageCard(
                                  sender: sms.sender,
                                  messageBody: sms.body,
                                  timestamp: sms.timestamp,
                                ),
                                if (transaction != null || hasFallback) ...[
                                  AppSpacing.h8,
                                  ParsedSmsCard(
                                    rawText: sms.body,
                                    extractedMerchant:
                                        transaction?.merchant ??
                                        fallback!.merchant ??
                                        sms.sender,
                                    extractedAmount:
                                        transaction?.amount ?? fallback!.amount,
                                    category:
                                        transaction?.category ??
                                        fallback!.category,
                                    extractionConfidence: sms.confidence,
                                    isIncome:
                                        transaction?.isIncome ??
                                        fallback!.transactionType == 'credit',
                                  ),
                                ],
                                AppSpacing.h24,
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
