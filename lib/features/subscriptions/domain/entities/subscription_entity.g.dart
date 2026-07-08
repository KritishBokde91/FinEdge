// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionEntity _$SubscriptionEntityFromJson(Map<String, dynamic> json) =>
    _SubscriptionEntity(
      id: json['id'] as String,
      merchant: json['merchant'] as String,
      amount: (json['amount'] as num).toDouble(),
      billingCycle: json['billingCycle'] as String,
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SubscriptionEntityToJson(_SubscriptionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant': instance.merchant,
      'amount': instance.amount,
      'billingCycle': instance.billingCycle,
      'nextBillingDate': instance.nextBillingDate.toIso8601String(),
      'isActive': instance.isActive,
    };
