import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_entity.freezed.dart';
part 'sms_entity.g.dart';

@freezed
abstract class SmsEntity with _$SmsEntity {
  const factory SmsEntity({
    required String id,
    required String sender,
    required String body,
    required DateTime timestamp,
    required bool isProcessed,
    required double confidence,
  }) = _SmsEntity;

  factory SmsEntity.fromJson(Map<String, dynamic> json) =>
      _$SmsEntityFromJson(json);
}
