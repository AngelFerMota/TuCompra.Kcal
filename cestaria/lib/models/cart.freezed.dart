// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  String get id =>
      throw _privateConstructorUsedError; // Firestore doc id / local UUID
  String get name => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  List<CartItem> get items => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get lastModifiedBy =>
      throw _privateConstructorUsedError; // userId del último que modificó
  String? get store => throw _privateConstructorUsedError; // p.ej. "Mercadona"
  bool get isArchived => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    List<String> participantIds,
    List<CartItem> items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastModifiedBy,
    String? store,
    bool isArchived,
  });
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? participantIds = null,
    Object? items = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? store = freezed,
    Object? isArchived = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            participantIds: null == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastModifiedBy: freezed == lastModifiedBy
                ? _value.lastModifiedBy
                : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            store: freezed == store
                ? _value.store
                : store // ignore: cast_nullable_to_non_nullable
                      as String?,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
    _$CartImpl value,
    $Res Function(_$CartImpl) then,
  ) = __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    List<String> participantIds,
    List<CartItem> items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastModifiedBy,
    String? store,
    bool isArchived,
  });
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
    : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? participantIds = null,
    Object? items = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? store = freezed,
    Object? isArchived = null,
  }) {
    return _then(
      _$CartImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        participantIds: null == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastModifiedBy: freezed == lastModifiedBy
            ? _value.lastModifiedBy
            : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        store: freezed == store
            ? _value.store
            : store // ignore: cast_nullable_to_non_nullable
                  as String?,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl implements _Cart {
  const _$CartImpl({
    required this.id,
    required this.name,
    required this.ownerId,
    final List<String> participantIds = const <String>[],
    final List<CartItem> items = const <CartItem>[],
    this.createdAt,
    this.updatedAt,
    this.lastModifiedBy,
    this.store,
    this.isArchived = false,
  }) : _participantIds = participantIds,
       _items = items;

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final String id;
  // Firestore doc id / local UUID
  @override
  final String name;
  @override
  final String ownerId;
  final List<String> _participantIds;
  @override
  @JsonKey()
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final List<CartItem> _items;
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? lastModifiedBy;
  // userId del último que modificó
  @override
  final String? store;
  // p.ej. "Mercadona"
  @override
  @JsonKey()
  final bool isArchived;

  @override
  String toString() {
    return 'Cart(id: $id, name: $name, ownerId: $ownerId, participantIds: $participantIds, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, lastModifiedBy: $lastModifiedBy, store: $store, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    ownerId,
    const DeepCollectionEquality().hash(_participantIds),
    const DeepCollectionEquality().hash(_items),
    createdAt,
    updatedAt,
    lastModifiedBy,
    store,
    isArchived,
  );

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(this);
  }
}

abstract class _Cart implements Cart {
  const factory _Cart({
    required final String id,
    required final String name,
    required final String ownerId,
    final List<String> participantIds,
    final List<CartItem> items,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? lastModifiedBy,
    final String? store,
    final bool isArchived,
  }) = _$CartImpl;

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  String get id; // Firestore doc id / local UUID
  @override
  String get name;
  @override
  String get ownerId;
  @override
  List<String> get participantIds;
  @override
  List<CartItem> get items;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get lastModifiedBy; // userId del último que modificó
  @override
  String? get store; // p.ej. "Mercadona"
  @override
  bool get isArchived;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
