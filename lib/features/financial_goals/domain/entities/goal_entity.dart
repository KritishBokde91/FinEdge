import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_entity.freezed.dart';
part 'goal_entity.g.dart';

@freezed
abstract class GoalEntity with _$GoalEntity {
  const factory GoalEntity({
    required String id,
    required String title,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required String category,
  }) = _GoalEntity;

  factory GoalEntity.fromJson(Map<String, dynamic> json) => _$GoalEntityFromJson(json);
}
