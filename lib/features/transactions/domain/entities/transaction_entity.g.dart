// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) =>
    _TransactionEntity(
      id: json['id'] as String,
      smsId: json['smsId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'] as String,
      category: json['category'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isIncome: json['isIncome'] as bool,
      accountSource: json['accountSource'] as String,
    );

Map<String, dynamic> _$TransactionEntityToJson(_TransactionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'smsId': instance.smsId,
      'amount': instance.amount,
      'merchant': instance.merchant,
      'category': instance.category,
      'timestamp': instance.timestamp.toIso8601String(),
      'isIncome': instance.isIncome,
      'accountSource': instance.accountSource,
    };
