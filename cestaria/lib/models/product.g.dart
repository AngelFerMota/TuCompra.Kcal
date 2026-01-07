// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      quantity: json['quantity'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      nutrition: json['nutrition'] as Map<String, dynamic>?,
      nutriScore: json['nutriScore'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'quantity': instance.quantity,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'nutrition': instance.nutrition,
      'nutriScore': instance.nutriScore,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
