import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_entity.freezed.dart';
part 'subscription_entity.g.dart';

@freezed
abstract class SubscriptionEntity with _$SubscriptionEntity {
  const factory SubscriptionEntity({
    required String id,
    required String merchant,
    required double amount,
    required String billingCycle,
    required DateTime nextBillingDate,
    required bool isActive,
  }) = _SubscriptionEntity;

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) => _$SubscriptionEntityFromJson(json);
}
