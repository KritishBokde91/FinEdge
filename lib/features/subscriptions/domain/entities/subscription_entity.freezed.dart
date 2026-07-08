// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionEntity {

 String get id; String get merchant; double get amount; String get billingCycle; DateTime get nextBillingDate; bool get isActive;
/// Create a copy of SubscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionEntityCopyWith<SubscriptionEntity> get copyWith => _$SubscriptionEntityCopyWithImpl<SubscriptionEntity>(this as SubscriptionEntity, _$identity);

  /// Serializes this SubscriptionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.billingCycle, billingCycle) || other.billingCycle == billingCycle)&&(identical(other.nextBillingDate, nextBillingDate) || other.nextBillingDate == nextBillingDate)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchant,amount,billingCycle,nextBillingDate,isActive);

@override
String toString() {
  return 'SubscriptionEntity(id: $id, merchant: $merchant, amount: $amount, billingCycle: $billingCycle, nextBillingDate: $nextBillingDate, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $SubscriptionEntityCopyWith<$Res>  {
  factory $SubscriptionEntityCopyWith(SubscriptionEntity value, $Res Function(SubscriptionEntity) _then) = _$SubscriptionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String merchant, double amount, String billingCycle, DateTime nextBillingDate, bool isActive
});




}
/// @nodoc
class _$SubscriptionEntityCopyWithImpl<$Res>
    implements $SubscriptionEntityCopyWith<$Res> {
  _$SubscriptionEntityCopyWithImpl(this._self, this._then);

  final SubscriptionEntity _self;
  final $Res Function(SubscriptionEntity) _then;

/// Create a copy of SubscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchant = null,Object? amount = null,Object? billingCycle = null,Object? nextBillingDate = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,billingCycle: null == billingCycle ? _self.billingCycle : billingCycle // ignore: cast_nullable_to_non_nullable
as String,nextBillingDate: null == nextBillingDate ? _self.nextBillingDate : nextBillingDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionEntity].
extension SubscriptionEntityPatterns on SubscriptionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchant,  double amount,  String billingCycle,  DateTime nextBillingDate,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionEntity() when $default != null:
return $default(_that.id,_that.merchant,_that.amount,_that.billingCycle,_that.nextBillingDate,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchant,  double amount,  String billingCycle,  DateTime nextBillingDate,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionEntity():
return $default(_that.id,_that.merchant,_that.amount,_that.billingCycle,_that.nextBillingDate,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchant,  double amount,  String billingCycle,  DateTime nextBillingDate,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionEntity() when $default != null:
return $default(_that.id,_that.merchant,_that.amount,_that.billingCycle,_that.nextBillingDate,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionEntity implements SubscriptionEntity {
  const _SubscriptionEntity({required this.id, required this.merchant, required this.amount, required this.billingCycle, required this.nextBillingDate, required this.isActive});
  factory _SubscriptionEntity.fromJson(Map<String, dynamic> json) => _$SubscriptionEntityFromJson(json);

@override final  String id;
@override final  String merchant;
@override final  double amount;
@override final  String billingCycle;
@override final  DateTime nextBillingDate;
@override final  bool isActive;

/// Create a copy of SubscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionEntityCopyWith<_SubscriptionEntity> get copyWith => __$SubscriptionEntityCopyWithImpl<_SubscriptionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.billingCycle, billingCycle) || other.billingCycle == billingCycle)&&(identical(other.nextBillingDate, nextBillingDate) || other.nextBillingDate == nextBillingDate)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchant,amount,billingCycle,nextBillingDate,isActive);

@override
String toString() {
  return 'SubscriptionEntity(id: $id, merchant: $merchant, amount: $amount, billingCycle: $billingCycle, nextBillingDate: $nextBillingDate, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionEntityCopyWith<$Res> implements $SubscriptionEntityCopyWith<$Res> {
  factory _$SubscriptionEntityCopyWith(_SubscriptionEntity value, $Res Function(_SubscriptionEntity) _then) = __$SubscriptionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchant, double amount, String billingCycle, DateTime nextBillingDate, bool isActive
});




}
/// @nodoc
class __$SubscriptionEntityCopyWithImpl<$Res>
    implements _$SubscriptionEntityCopyWith<$Res> {
  __$SubscriptionEntityCopyWithImpl(this._self, this._then);

  final _SubscriptionEntity _self;
  final $Res Function(_SubscriptionEntity) _then;

/// Create a copy of SubscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchant = null,Object? amount = null,Object? billingCycle = null,Object? nextBillingDate = null,Object? isActive = null,}) {
  return _then(_SubscriptionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,billingCycle: null == billingCycle ? _self.billingCycle : billingCycle // ignore: cast_nullable_to_non_nullable
as String,nextBillingDate: null == nextBillingDate ? _self.nextBillingDate : nextBillingDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
