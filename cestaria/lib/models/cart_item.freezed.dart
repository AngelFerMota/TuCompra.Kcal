// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get productId =>
      throw _privateConstructorUsedError; // referencia a Product.id
  String get name =>
      throw _privateConstructorUsedError; // denormalizado para mostrar rápido
  double get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError; // ud, kg, g, L, etc.
  double? get unitPrice => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isChecked => throw _privateConstructorUsedError;
  bool get isPurchased =>
      throw _privateConstructorUsedError; // Marcado como comprado (carritos compartidos)
  String? get purchasedBy =>
      throw _privateConstructorUsedError; // ID del usuario que lo compró
  DateTime? get purchasedAt => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    String productId,
    String name,
    double quantity,
    String? unit,
    double? unitPrice,
    String? notes,
    bool isChecked,
    bool isPurchased,
    String? purchasedBy,
    DateTime? purchasedAt,
  });
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? notes = freezed,
    Object? isChecked = null,
    Object? isPurchased = null,
    Object? purchasedBy = freezed,
    Object? purchasedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitPrice: freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isChecked: null == isChecked
                ? _value.isChecked
                : isChecked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPurchased: null == isPurchased
                ? _value.isPurchased
                : isPurchased // ignore: cast_nullable_to_non_nullable
                      as bool,
            purchasedBy: freezed == purchasedBy
                ? _value.purchasedBy
                : purchasedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchasedAt: freezed == purchasedAt
                ? _value.purchasedAt
                : purchasedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String name,
    double quantity,
    String? unit,
    double? unitPrice,
    String? notes,
    bool isChecked,
    bool isPurchased,
    String? purchasedBy,
    DateTime? purchasedAt,
  });
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? notes = freezed,
    Object? isChecked = null,
    Object? isPurchased = null,
    Object? purchasedBy = freezed,
    Object? purchasedAt = freezed,
  }) {
    return _then(
      _$CartItemImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitPrice: freezed == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isChecked: null == isChecked
            ? _value.isChecked
            : isChecked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPurchased: null == isPurchased
            ? _value.isPurchased
            : isPurchased // ignore: cast_nullable_to_non_nullable
                  as bool,
        purchasedBy: freezed == purchasedBy
            ? _value.purchasedBy
            : purchasedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchasedAt: freezed == purchasedAt
            ? _value.purchasedAt
            : purchasedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl({
    required this.productId,
    required this.name,
    this.quantity = 1.0,
    this.unit,
    this.unitPrice,
    this.notes,
    this.isChecked = false,
    this.isPurchased = false,
    this.purchasedBy,
    this.purchasedAt,
  });

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String productId;
  // referencia a Product.id
  @override
  final String name;
  // denormalizado para mostrar rápido
  @override
  @JsonKey()
  final double quantity;
  @override
  final String? unit;
  // ud, kg, g, L, etc.
  @override
  final double? unitPrice;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isChecked;
  @override
  @JsonKey()
  final bool isPurchased;
  // Marcado como comprado (carritos compartidos)
  @override
  final String? purchasedBy;
  // ID del usuario que lo compró
  @override
  final DateTime? purchasedAt;

  @override
  String toString() {
    return 'CartItem(productId: $productId, name: $name, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, notes: $notes, isChecked: $isChecked, isPurchased: $isPurchased, purchasedBy: $purchasedBy, purchasedAt: $purchasedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked) &&
            (identical(other.isPurchased, isPurchased) ||
                other.isPurchased == isPurchased) &&
            (identical(other.purchasedBy, purchasedBy) ||
                other.purchasedBy == purchasedBy) &&
            (identical(other.purchasedAt, purchasedAt) ||
                other.purchasedAt == purchasedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    name,
    quantity,
    unit,
    unitPrice,
    notes,
    isChecked,
    isPurchased,
    purchasedBy,
    purchasedAt,
  );

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(this);
  }
}

abstract class _CartItem implements CartItem {
  const factory _CartItem({
    required final String productId,
    required final String name,
    final double quantity,
    final String? unit,
    final double? unitPrice,
    final String? notes,
    final bool isChecked,
    final bool isPurchased,
    final String? purchasedBy,
    final DateTime? purchasedAt,
  }) = _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get productId; // referencia a Product.id
  @override
  String get name; // denormalizado para mostrar rápido
  @override
  double get quantity;
  @override
  String? get unit; // ud, kg, g, L, etc.
  @override
  double? get unitPrice;
  @override
  String? get notes;
  @override
  bool get isChecked;
  @override
  bool get isPurchased; // Marcado como comprado (carritos compartidos)
  @override
  String? get purchasedBy; // ID del usuario que lo compró
  @override
  DateTime? get purchasedAt;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
