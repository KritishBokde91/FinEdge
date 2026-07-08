// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmsEntity {

 String get id; String get sender; String get body; DateTime get timestamp; bool get isProcessed; double get confidence;
/// Create a copy of SmsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsEntityCopyWith<SmsEntity> get copyWith => _$SmsEntityCopyWithImpl<SmsEntity>(this as SmsEntity, _$identity);

  /// Serializes this SmsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isProcessed, isProcessed) || other.isProcessed == isProcessed)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,body,timestamp,isProcessed,confidence);

@override
String toString() {
  return 'SmsEntity(id: $id, sender: $sender, body: $body, timestamp: $timestamp, isProcessed: $isProcessed, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $SmsEntityCopyWith<$Res>  {
  factory $SmsEntityCopyWith(SmsEntity value, $Res Function(SmsEntity) _then) = _$SmsEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sender, String body, DateTime timestamp, bool isProcessed, double confidence
});




}
/// @nodoc
class _$SmsEntityCopyWithImpl<$Res>
    implements $SmsEntityCopyWith<$Res> {
  _$SmsEntityCopyWithImpl(this._self, this._then);

  final SmsEntity _self;
  final $Res Function(SmsEntity) _then;

/// Create a copy of SmsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sender = null,Object? body = null,Object? timestamp = null,Object? isProcessed = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isProcessed: null == isProcessed ? _self.isProcessed : isProcessed // ignore: cast_nullable_to_non_nullable
as bool,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsEntity].
extension SmsEntityPatterns on SmsEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsEntity value)  $default,){
final _that = this;
switch (_that) {
case _SmsEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SmsEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sender,  String body,  DateTime timestamp,  bool isProcessed,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsEntity() when $default != null:
return $default(_that.id,_that.sender,_that.body,_that.timestamp,_that.isProcessed,_that.confidence);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sender,  String body,  DateTime timestamp,  bool isProcessed,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _SmsEntity():
return $default(_that.id,_that.sender,_that.body,_that.timestamp,_that.isProcessed,_that.confidence);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sender,  String body,  DateTime timestamp,  bool isProcessed,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _SmsEntity() when $default != null:
return $default(_that.id,_that.sender,_that.body,_that.timestamp,_that.isProcessed,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmsEntity implements SmsEntity {
  const _SmsEntity({required this.id, required this.sender, required this.body, required this.timestamp, required this.isProcessed, required this.confidence});
  factory _SmsEntity.fromJson(Map<String, dynamic> json) => _$SmsEntityFromJson(json);

@override final  String id;
@override final  String sender;
@override final  String body;
@override final  DateTime timestamp;
@override final  bool isProcessed;
@override final  double confidence;

/// Create a copy of SmsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsEntityCopyWith<_SmsEntity> get copyWith => __$SmsEntityCopyWithImpl<_SmsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isProcessed, isProcessed) || other.isProcessed == isProcessed)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,body,timestamp,isProcessed,confidence);

@override
String toString() {
  return 'SmsEntity(id: $id, sender: $sender, body: $body, timestamp: $timestamp, isProcessed: $isProcessed, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$SmsEntityCopyWith<$Res> implements $SmsEntityCopyWith<$Res> {
  factory _$SmsEntityCopyWith(_SmsEntity value, $Res Function(_SmsEntity) _then) = __$SmsEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sender, String body, DateTime timestamp, bool isProcessed, double confidence
});




}
/// @nodoc
class __$SmsEntityCopyWithImpl<$Res>
    implements _$SmsEntityCopyWith<$Res> {
  __$SmsEntityCopyWithImpl(this._self, this._then);

  final _SmsEntity _self;
  final $Res Function(_SmsEntity) _then;

/// Create a copy of SmsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sender = null,Object? body = null,Object? timestamp = null,Object? isProcessed = null,Object? confidence = null,}) {
  return _then(_SmsEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isProcessed: null == isProcessed ? _self.isProcessed : isProcessed // ignore: cast_nullable_to_non_nullable
as bool,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
