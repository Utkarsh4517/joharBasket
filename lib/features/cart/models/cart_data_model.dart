// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartDataModel {
  final String productId;
  final dynamic nos;
  final dynamic inStock;
  final String imageUrl;
  final String name;
  final bool isFeatured;
  final String description;
  final dynamic price;
  final dynamic gst;
  CartDataModel({
    required this.gst,
    required this.imageUrl,
    required this.name,
    required this.isFeatured,
    required this.price,
    required this.productId,
    required this.nos,
    required this.description,
    required this.inStock,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'nos': nos,
      'inStock': inStock,
      'imageUrl': imageUrl,
      'name': name,
      'isFeatured': isFeatured,
      'description': description,
      'price': price,
      'gst': gst,
    };
  }

  factory CartDataModel.fromMap(Map<String, dynamic> map) {
    return CartDataModel(
      productId: map['productId'] as String,
      nos: map['nos'] as dynamic,
      inStock: map['inStock'] as dynamic,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      isFeatured: map['isFeatured'] as bool,
      description: map['description'] as String,
      price: map['price'] as dynamic,
      gst: map['gst'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartDataModel.fromJson(String source) =>
      CartDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
