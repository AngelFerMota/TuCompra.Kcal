// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      productId: json['productId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      isChecked: json['isChecked'] as bool? ?? false,
      isPurchased: json['isPurchased'] as bool? ?? false,
      purchasedBy: json['purchasedBy'] as String?,
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unitPrice': instance.unitPrice,
      'notes': instance.notes,
      'isChecked': instance.isChecked,
      'isPurchased': instance.isPurchased,
      'purchasedBy': instance.purchasedBy,
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
    };
