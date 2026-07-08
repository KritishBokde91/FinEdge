import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_entity.freezed.dart';
part 'budget_entity.g.dart';

@freezed
abstract class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String id,
    required String category,
    required double limitAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) = _BudgetEntity;

  factory BudgetEntity.fromJson(Map<String, dynamic> json) =>
      _$BudgetEntityFromJson(json);
}
