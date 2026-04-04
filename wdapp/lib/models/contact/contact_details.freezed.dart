// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactDetails {
  int get age;
  String get gender;
  String get message;
  String get loc;
  String get location;
  String get name;
  int get timestamp;
  int get unread;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactDetailsCopyWith<ContactDetails> get copyWith =>
      _$ContactDetailsCopyWithImpl<ContactDetails>(
        this as ContactDetails,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactDetails &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.loc, loc) || other.loc == loc) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.unread, unread) || other.unread == unread));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    age,
    gender,
    message,
    loc,
    location,
    name,
    timestamp,
    unread,
  );

  @override
  String toString() {
    return 'ContactDetails(age: $age, gender: $gender, message: $message, loc: $loc, location: $location, name: $name, timestamp: $timestamp, unread: $unread)';
  }
}

/// @nodoc
abstract mixin class $ContactDetailsCopyWith<$Res> {
  factory $ContactDetailsCopyWith(
    ContactDetails value,
    $Res Function(ContactDetails) _then,
  ) = _$ContactDetailsCopyWithImpl;
  @useResult
  $Res call({
    int age,
    String gender,
    String message,
    String loc,
    String location,
    String name,
    int timestamp,
    int unread,
  });
}

/// @nodoc
class _$ContactDetailsCopyWithImpl<$Res>
    implements $ContactDetailsCopyWith<$Res> {
  _$ContactDetailsCopyWithImpl(this._self, this._then);

  final ContactDetails _self;
  final $Res Function(ContactDetails) _then;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? age = null,
    Object? gender = null,
    Object? message = null,
    Object? loc = null,
    Object? location = null,
    Object? name = null,
    Object? timestamp = null,
    Object? unread = null,
  }) {
    return _then(
      _self.copyWith(
        age: null == age
            ? _self.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        gender: null == gender
            ? _self.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        loc: null == loc
            ? _self.loc
            : loc // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        unread: null == unread
            ? _self.unread
            : unread // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ContactDetails].
extension ContactDetailsPatterns on ContactDetails {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ContactDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactDetails() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ContactDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactDetails():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ContactDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactDetails() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      int age,
      String gender,
      String message,
      String loc,
      String location,
      String name,
      int timestamp,
      int unread,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactDetails() when $default != null:
        return $default(
          _that.age,
          _that.gender,
          _that.message,
          _that.loc,
          _that.location,
          _that.name,
          _that.timestamp,
          _that.unread,
        );
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      int age,
      String gender,
      String message,
      String loc,
      String location,
      String name,
      int timestamp,
      int unread,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactDetails():
        return $default(
          _that.age,
          _that.gender,
          _that.message,
          _that.loc,
          _that.location,
          _that.name,
          _that.timestamp,
          _that.unread,
        );
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      int age,
      String gender,
      String message,
      String loc,
      String location,
      String name,
      int timestamp,
      int unread,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactDetails() when $default != null:
        return $default(
          _that.age,
          _that.gender,
          _that.message,
          _that.loc,
          _that.location,
          _that.name,
          _that.timestamp,
          _that.unread,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ContactDetails extends ContactDetails {
  const _ContactDetails({
    required this.age,
    required this.gender,
    required this.message,
    required this.loc,
    required this.location,
    required this.name,
    required this.timestamp,
    required this.unread,
  }) : super._();

  @override
  final int age;
  @override
  final String gender;
  @override
  final String message;
  @override
  final String loc;
  @override
  final String location;
  @override
  final String name;
  @override
  final int timestamp;
  @override
  final int unread;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ContactDetailsCopyWith<_ContactDetails> get copyWith =>
      __$ContactDetailsCopyWithImpl<_ContactDetails>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactDetails &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.loc, loc) || other.loc == loc) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.unread, unread) || other.unread == unread));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    age,
    gender,
    message,
    loc,
    location,
    name,
    timestamp,
    unread,
  );

  @override
  String toString() {
    return 'ContactDetails(age: $age, gender: $gender, message: $message, loc: $loc, location: $location, name: $name, timestamp: $timestamp, unread: $unread)';
  }
}

/// @nodoc
abstract mixin class _$ContactDetailsCopyWith<$Res>
    implements $ContactDetailsCopyWith<$Res> {
  factory _$ContactDetailsCopyWith(
    _ContactDetails value,
    $Res Function(_ContactDetails) _then,
  ) = __$ContactDetailsCopyWithImpl;
  @override
  @useResult
  $Res call({
    int age,
    String gender,
    String message,
    String loc,
    String location,
    String name,
    int timestamp,
    int unread,
  });
}

/// @nodoc
class __$ContactDetailsCopyWithImpl<$Res>
    implements _$ContactDetailsCopyWith<$Res> {
  __$ContactDetailsCopyWithImpl(this._self, this._then);

  final _ContactDetails _self;
  final $Res Function(_ContactDetails) _then;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? age = null,
    Object? gender = null,
    Object? message = null,
    Object? loc = null,
    Object? location = null,
    Object? name = null,
    Object? timestamp = null,
    Object? unread = null,
  }) {
    return _then(
      _ContactDetails(
        age: null == age
            ? _self.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        gender: null == gender
            ? _self.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        loc: null == loc
            ? _self.loc
            : loc // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        unread: null == unread
            ? _self.unread
            : unread // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
