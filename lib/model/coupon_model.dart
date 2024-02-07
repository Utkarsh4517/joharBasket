import 'dart:convert';

class CouponModel {
  final String type;
  final String couponCode;
  final double discount;
  final double onOrderAbove;
  final double flatOff;
  final double upto;
  CouponModel({
    required this.type,
    required this.couponCode,
    required this.discount,
    required this.onOrderAbove,
    required this.flatOff,
    required this.upto,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'couponCode': couponCode,
      'discount': discount,
      'onOrderAbove': onOrderAbove,
      'flatOff': flatOff,
      'upto': upto,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      type: map['type'] ?? '',
      couponCode: map['couponCode'] ?? '',
      discount: map['discount']?.toDouble() ?? 0.0,
      onOrderAbove: map['onOrderAbove']?.toDouble() ?? 0.0,
      flatOff: map['flatOff']?.toDouble() ?? 0.0,
      upto: map['upto']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) => CouponModel.fromMap(json.decode(source));
}
