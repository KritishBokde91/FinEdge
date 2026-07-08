// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalEntity {

 String get id; String get title; double get targetAmount; double get currentAmount; DateTime get targetDate; String get category;
/// Create a copy of GoalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalEntityCopyWith<GoalEntity> get copyWith => _$GoalEntityCopyWithImpl<GoalEntity>(this as GoalEntity, _$identity);

  /// Serializes this GoalEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,targetAmount,currentAmount,targetDate,category);

@override
String toString() {
  return 'GoalEntity(id: $id, title: $title, targetAmount: $targetAmount, currentAmount: $currentAmount, targetDate: $targetDate, category: $category)';
}


}

/// @nodoc
abstract mixin class $GoalEntityCopyWith<$Res>  {
  factory $GoalEntityCopyWith(GoalEntity value, $Res Function(GoalEntity) _then) = _$GoalEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, double targetAmount, double currentAmount, DateTime targetDate, String category
});




}
/// @nodoc
class _$GoalEntityCopyWithImpl<$Res>
    implements $GoalEntityCopyWith<$Res> {
  _$GoalEntityCopyWithImpl(this._self, this._then);

  final GoalEntity _self;
  final $Res Function(GoalEntity) _then;

/// Create a copy of GoalEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? targetAmount = null,Object? currentAmount = null,Object? targetDate = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as double,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as double,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalEntity].
extension GoalEntityPatterns on GoalEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalEntity value)  $default,){
final _that = this;
switch (_that) {
case _GoalEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GoalEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  double targetAmount,  double currentAmount,  DateTime targetDate,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalEntity() when $default != null:
return $default(_that.id,_that.title,_that.targetAmount,_that.currentAmount,_that.targetDate,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  double targetAmount,  double currentAmount,  DateTime targetDate,  String category)  $default,) {final _that = this;
switch (_that) {
case _GoalEntity():
return $default(_that.id,_that.title,_that.targetAmount,_that.currentAmount,_that.targetDate,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  double targetAmount,  double currentAmount,  DateTime targetDate,  String category)?  $default,) {final _that = this;
switch (_that) {
case _GoalEntity() when $default != null:
return $default(_that.id,_that.title,_that.targetAmount,_that.currentAmount,_that.targetDate,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalEntity implements GoalEntity {
  const _GoalEntity({required this.id, required this.title, required this.targetAmount, required this.currentAmount, required this.targetDate, required this.category});
  factory _GoalEntity.fromJson(Map<String, dynamic> json) => _$GoalEntityFromJson(json);

@override final  String id;
@override final  String title;
@override final  double targetAmount;
@override final  double currentAmount;
@override final  DateTime targetDate;
@override final  String category;

/// Create a copy of GoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalEntityCopyWith<_GoalEntity> get copyWith => __$GoalEntityCopyWithImpl<_GoalEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,targetAmount,currentAmount,targetDate,category);

@override
String toString() {
  return 'GoalEntity(id: $id, title: $title, targetAmount: $targetAmount, currentAmount: $currentAmount, targetDate: $targetDate, category: $category)';
}


}

/// @nodoc
abstract mixin class _$GoalEntityCopyWith<$Res> implements $GoalEntityCopyWith<$Res> {
  factory _$GoalEntityCopyWith(_GoalEntity value, $Res Function(_GoalEntity) _then) = __$GoalEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double targetAmount, double currentAmount, DateTime targetDate, String category
});




}
/// @nodoc
class __$GoalEntityCopyWithImpl<$Res>
    implements _$GoalEntityCopyWith<$Res> {
  __$GoalEntityCopyWithImpl(this._self, this._then);

  final _GoalEntity _self;
  final $Res Function(_GoalEntity) _then;

/// Create a copy of GoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? targetAmount = null,Object? currentAmount = null,Object? targetDate = null,Object? category = null,}) {
  return _then(_GoalEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as double,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as double,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
