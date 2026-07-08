import '../../../../core/error/result.dart';
import '../entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Stream<List<SubscriptionEntity>> watchAllSubscriptions();
  Future<Result<void>> insertSubscription(SubscriptionEntity subscription);
  Future<Result<void>> updateSubscription(SubscriptionEntity subscription);
  Future<Result<void>> deleteSubscription(String id);
}
