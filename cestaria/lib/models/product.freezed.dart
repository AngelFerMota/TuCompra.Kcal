// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id =>
      throw _privateConstructorUsedError; // EAN/código de barras u otro identificador
  String get name => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get quantity => throw _privateConstructorUsedError; // p.ej. "500 g"
  double? get price => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get nutrition => throw _privateConstructorUsedError;
  String? get nutriScore =>
      throw _privateConstructorUsedError; // A, B, C, D, E (calidad nutricional)
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String name,
    String? brand,
    String? quantity,
    double? price,
    String? imageUrl,
    Map<String, dynamic>? nutrition,
    String? nutriScore,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? brand = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? imageUrl = freezed,
    Object? nutrition = freezed,
    Object? nutriScore = freezed,
    Object? lastUpdated = freezed,
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
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            nutrition: freezed == nutrition
                ? _value.nutrition
                : nutrition // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            nutriScore: freezed == nutriScore
                ? _value.nutriScore
                : nutriScore // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? brand,
    String? quantity,
    double? price,
    String? imageUrl,
    Map<String, dynamic>? nutrition,
    String? nutriScore,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? brand = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? imageUrl = freezed,
    Object? nutrition = freezed,
    Object? nutriScore = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        nutrition: freezed == nutrition
            ? _value._nutrition
            : nutrition // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        nutriScore: freezed == nutriScore
            ? _value.nutriScore
            : nutriScore // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    required this.name,
    this.brand,
    this.quantity,
    this.price,
    this.imageUrl,
    final Map<String, dynamic>? nutrition,
    this.nutriScore,
    this.lastUpdated,
  }) : _nutrition = nutrition;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  // EAN/código de barras u otro identificador
  @override
  final String name;
  @override
  final String? brand;
  @override
  final String? quantity;
  // p.ej. "500 g"
  @override
  final double? price;
  @override
  final String? imageUrl;
  final Map<String, dynamic>? _nutrition;
  @override
  Map<String, dynamic>? get nutrition {
    final value = _nutrition;
    if (value == null) return null;
    if (_nutrition is EqualUnmodifiableMapView) return _nutrition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? nutriScore;
  // A, B, C, D, E (calidad nutricional)
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, brand: $brand, quantity: $quantity, price: $price, imageUrl: $imageUrl, nutrition: $nutrition, nutriScore: $nutriScore, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(
              other._nutrition,
              _nutrition,
            ) &&
            (identical(other.nutriScore, nutriScore) ||
                other.nutriScore == nutriScore) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    brand,
    quantity,
    price,
    imageUrl,
    const DeepCollectionEquality().hash(_nutrition),
    nutriScore,
    lastUpdated,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    required final String name,
    final String? brand,
    final String? quantity,
    final double? price,
    final String? imageUrl,
    final Map<String, dynamic>? nutrition,
    final String? nutriScore,
    final DateTime? lastUpdated,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id; // EAN/código de barras u otro identificador
  @override
  String get name;
  @override
  String? get brand;
  @override
  String? get quantity; // p.ej. "500 g"
  @override
  double? get price;
  @override
  String? get imageUrl;
  @override
  Map<String, dynamic>? get nutrition;
  @override
  String? get nutriScore; // A, B, C, D, E (calidad nutricional)
  @override
  DateTime? get lastUpdated;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
