// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionEntity {

 String get id; String? get smsId; double get amount; String get merchant; String get category; DateTime get timestamp; bool get isIncome; String get accountSource; String? get reference; String get currency;
/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionEntityCopyWith<TransactionEntity> get copyWith => _$TransactionEntityCopyWithImpl<TransactionEntity>(this as TransactionEntity, _$identity);

  /// Serializes this TransactionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.smsId, smsId) || other.smsId == smsId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.category, category) || other.category == category)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.accountSource, accountSource) || other.accountSource == accountSource)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,smsId,amount,merchant,category,timestamp,isIncome,accountSource,reference,currency);

@override
String toString() {
  return 'TransactionEntity(id: $id, smsId: $smsId, amount: $amount, merchant: $merchant, category: $category, timestamp: $timestamp, isIncome: $isIncome, accountSource: $accountSource, reference: $reference, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $TransactionEntityCopyWith<$Res>  {
  factory $TransactionEntityCopyWith(TransactionEntity value, $Res Function(TransactionEntity) _then) = _$TransactionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String? smsId, double amount, String merchant, String category, DateTime timestamp, bool isIncome, String accountSource, String? reference, String currency
});




}
/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._self, this._then);

  final TransactionEntity _self;
  final $Res Function(TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? smsId = freezed,Object? amount = null,Object? merchant = null,Object? category = null,Object? timestamp = null,Object? isIncome = null,Object? accountSource = null,Object? reference = freezed,Object? currency = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,smsId: freezed == smsId ? _self.smsId : smsId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,accountSource: null == accountSource ? _self.accountSource : accountSource // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionEntity].
extension TransactionEntityPatterns on TransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _TransactionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? smsId,  double amount,  String merchant,  String category,  DateTime timestamp,  bool isIncome,  String accountSource,  String? reference,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
return $default(_that.id,_that.smsId,_that.amount,_that.merchant,_that.category,_that.timestamp,_that.isIncome,_that.accountSource,_that.reference,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? smsId,  double amount,  String merchant,  String category,  DateTime timestamp,  bool isIncome,  String accountSource,  String? reference,  String currency)  $default,) {final _that = this;
switch (_that) {
case _TransactionEntity():
return $default(_that.id,_that.smsId,_that.amount,_that.merchant,_that.category,_that.timestamp,_that.isIncome,_that.accountSource,_that.reference,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? smsId,  double amount,  String merchant,  String category,  DateTime timestamp,  bool isIncome,  String accountSource,  String? reference,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
return $default(_that.id,_that.smsId,_that.amount,_that.merchant,_that.category,_that.timestamp,_that.isIncome,_that.accountSource,_that.reference,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionEntity implements TransactionEntity {
  const _TransactionEntity({required this.id, required this.smsId, required this.amount, required this.merchant, required this.category, required this.timestamp, required this.isIncome, required this.accountSource, this.reference, this.currency = 'INR'});
  factory _TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);

@override final  String id;
@override final  String? smsId;
@override final  double amount;
@override final  String merchant;
@override final  String category;
@override final  DateTime timestamp;
@override final  bool isIncome;
@override final  String accountSource;
@override final  String? reference;
@override@JsonKey() final  String currency;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionEntityCopyWith<_TransactionEntity> get copyWith => __$TransactionEntityCopyWithImpl<_TransactionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.smsId, smsId) || other.smsId == smsId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.category, category) || other.category == category)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.accountSource, accountSource) || other.accountSource == accountSource)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,smsId,amount,merchant,category,timestamp,isIncome,accountSource,reference,currency);

@override
String toString() {
  return 'TransactionEntity(id: $id, smsId: $smsId, amount: $amount, merchant: $merchant, category: $category, timestamp: $timestamp, isIncome: $isIncome, accountSource: $accountSource, reference: $reference, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$TransactionEntityCopyWith<$Res> implements $TransactionEntityCopyWith<$Res> {
  factory _$TransactionEntityCopyWith(_TransactionEntity value, $Res Function(_TransactionEntity) _then) = __$TransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String? smsId, double amount, String merchant, String category, DateTime timestamp, bool isIncome, String accountSource, String? reference, String currency
});




}
/// @nodoc
class __$TransactionEntityCopyWithImpl<$Res>
    implements _$TransactionEntityCopyWith<$Res> {
  __$TransactionEntityCopyWithImpl(this._self, this._then);

  final _TransactionEntity _self;
  final $Res Function(_TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? smsId = freezed,Object? amount = null,Object? merchant = null,Object? category = null,Object? timestamp = null,Object? isIncome = null,Object? accountSource = null,Object? reference = freezed,Object? currency = null,}) {
  return _then(_TransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,smsId: freezed == smsId ? _self.smsId : smsId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,accountSource: null == accountSource ? _self.accountSource : accountSource // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
