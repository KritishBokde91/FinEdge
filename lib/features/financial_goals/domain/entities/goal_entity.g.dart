// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalEntity _$GoalEntityFromJson(Map<String, dynamic> json) => _GoalEntity(
  id: json['id'] as String,
  title: json['title'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  currentAmount: (json['currentAmount'] as num).toDouble(),
  targetDate: DateTime.parse(json['targetDate'] as String),
  category: json['category'] as String,
);

Map<String, dynamic> _$GoalEntityToJson(_GoalEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'targetDate': instance.targetDate.toIso8601String(),
      'category': instance.category,
    };
