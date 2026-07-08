// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetEntity _$BudgetEntityFromJson(Map<String, dynamic> json) =>
    _BudgetEntity(
      id: json['id'] as String,
      category: json['category'] as String,
      limitAmount: (json['limitAmount'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$BudgetEntityToJson(_BudgetEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'limitAmount': instance.limitAmount,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
