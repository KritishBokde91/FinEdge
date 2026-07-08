// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmsEntity _$SmsEntityFromJson(Map<String, dynamic> json) => _SmsEntity(
  id: json['id'] as String,
  sender: json['sender'] as String,
  body: json['body'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isProcessed: json['isProcessed'] as bool,
  confidence: (json['confidence'] as num).toDouble(),
);

Map<String, dynamic> _$SmsEntityToJson(_SmsEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'body': instance.body,
      'timestamp': instance.timestamp.toIso8601String(),
      'isProcessed': instance.isProcessed,
      'confidence': instance.confidence,
    };
