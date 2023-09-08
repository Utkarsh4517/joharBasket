import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductDataModel {
  final String productId;
  final dynamic nos;
  final dynamic inStock;
  final String imageUrl;
  final String name;
  final bool isFeatured;
  final String description;
  final dynamic price;
  final dynamic gst;
  final String? size;
  ProductDataModel({
    required this.gst,
    required this.imageUrl,
    required this.name,
    required this.isFeatured,
    required this.price,
    required this.productId,
    required this.nos,
    required this.description,
    required this.inStock,
    required this.size,
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
      'size': size,
    };
  }

  factory ProductDataModel.fromMap(Map<String, dynamic> map) {
    return ProductDataModel(
      productId: map['productId'] as String,
      nos: map['nos'] as dynamic,
      inStock: map['inStock'] as dynamic,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      isFeatured: map['isFeatured'] as bool,
      description: map['description'] as String,
      price: map['price'] as dynamic,
      gst: map['gst'] as dynamic,
      size: map['size'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDataModel.fromJson(String source) => ProductDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
