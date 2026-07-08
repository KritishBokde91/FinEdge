// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetEntity {

 String get id; String get category; double get limitAmount; DateTime get startDate; DateTime get endDate;
/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetEntityCopyWith<BudgetEntity> get copyWith => _$BudgetEntityCopyWithImpl<BudgetEntity>(this as BudgetEntity, _$identity);

  /// Serializes this BudgetEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,limitAmount,startDate,endDate);

@override
String toString() {
  return 'BudgetEntity(id: $id, category: $category, limitAmount: $limitAmount, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $BudgetEntityCopyWith<$Res>  {
  factory $BudgetEntityCopyWith(BudgetEntity value, $Res Function(BudgetEntity) _then) = _$BudgetEntityCopyWithImpl;
@useResult
$Res call({
 String id, String category, double limitAmount, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$BudgetEntityCopyWithImpl<$Res>
    implements $BudgetEntityCopyWith<$Res> {
  _$BudgetEntityCopyWithImpl(this._self, this._then);

  final BudgetEntity _self;
  final $Res Function(BudgetEntity) _then;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? limitAmount = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as double,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetEntity].
extension BudgetEntityPatterns on BudgetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetEntity value)  $default,){
final _that = this;
switch (_that) {
case _BudgetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  double limitAmount,  DateTime startDate,  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
return $default(_that.id,_that.category,_that.limitAmount,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  double limitAmount,  DateTime startDate,  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _BudgetEntity():
return $default(_that.id,_that.category,_that.limitAmount,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  double limitAmount,  DateTime startDate,  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
return $default(_that.id,_that.category,_that.limitAmount,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetEntity implements BudgetEntity {
  const _BudgetEntity({required this.id, required this.category, required this.limitAmount, required this.startDate, required this.endDate});
  factory _BudgetEntity.fromJson(Map<String, dynamic> json) => _$BudgetEntityFromJson(json);

@override final  String id;
@override final  String category;
@override final  double limitAmount;
@override final  DateTime startDate;
@override final  DateTime endDate;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetEntityCopyWith<_BudgetEntity> get copyWith => __$BudgetEntityCopyWithImpl<_BudgetEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,limitAmount,startDate,endDate);

@override
String toString() {
  return 'BudgetEntity(id: $id, category: $category, limitAmount: $limitAmount, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$BudgetEntityCopyWith<$Res> implements $BudgetEntityCopyWith<$Res> {
  factory _$BudgetEntityCopyWith(_BudgetEntity value, $Res Function(_BudgetEntity) _then) = __$BudgetEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, double limitAmount, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class __$BudgetEntityCopyWithImpl<$Res>
    implements _$BudgetEntityCopyWith<$Res> {
  __$BudgetEntityCopyWithImpl(this._self, this._then);

  final _BudgetEntity _self;
  final $Res Function(_BudgetEntity) _then;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? limitAmount = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_BudgetEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as double,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
