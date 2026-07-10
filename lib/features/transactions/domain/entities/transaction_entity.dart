import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required String? smsId,
    required double amount,
    required String merchant,
    required String category,
    required DateTime timestamp,
    required bool isIncome,
    required String accountSource,
    String? reference,
    @Default('INR') String currency,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
