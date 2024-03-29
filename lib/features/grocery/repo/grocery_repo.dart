import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:johar/model/grocery_model.dart';

class GroceryRepo {
  static Future<List<ProductDataModel>> fetchGroceries() async {
    List<ProductDataModel> groceries = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('grocery').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel grocery = ProductDataModel.fromMap(data);
        groceries.add(grocery);
      }

      return groceries;
    } catch (e) {
      return [];
    }
  }

  static Future<List<ProductDataModel>> fetchStationaries() async {
    List<ProductDataModel> stationaries = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('stationary').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel stationary = ProductDataModel.fromMap(data);
        stationaries.add(stationary);
      }

      return stationaries;
    } catch (e) {
      return [];
    }
  }

  static Future<List<ProductDataModel>> fetchCosmetics() async {
    List<ProductDataModel> cosmetics = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('cosmetics').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel cosmetic = ProductDataModel.fromMap(data);
        cosmetics.add(cosmetic);
      }

      return cosmetics;
    } catch (e) {
      return [];
    }
  }

    static Future<List<ProductDataModel>> fetchPooja() async {
    List<ProductDataModel> poojaProdcuts = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pooja').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel pooja = ProductDataModel.fromMap(data);
        poojaProdcuts.add(pooja);
      }

      return poojaProdcuts;
    } catch (e) {
      return [];
    }
  }

  // add grocery to cart
  static Future<void> addGroceryToCartFromGroceryPage(ProductDataModel grocery) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart');
    // check if product is already in cart
    final existingCartItem = await userCartRef.doc(grocery.productId).get();
    if (existingCartItem.exists) {
      // increment the quantity (Nos)
      userCartRef.doc(grocery.productId).update({'nos': FieldValue.increment(1)});
    } else {
      // add the product to card
      userCartRef.doc(grocery.productId).set({
        'name': grocery.name,
        'productId': grocery.productId,
        'nos': 1,
        'price': grocery.price,
        'isFeatured': grocery.isFeatured,
        'imageUrl': grocery.imageUrl,
        'inStock': grocery.inStock,
        'description': grocery.description,
        'gst': grocery.gst,
        'size': grocery.size,
        'discountedPrice': grocery.discountedPrice,
      });
    }
  }

  static Future<void> addGroceryToCartFromGroceryProductPage(ProductDataModel grocery, dynamic quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart');
    // check if product is already in cart
    final existingCartItem = await userCartRef.doc(grocery.productId).get();
    if (existingCartItem.exists) {
      // increment the quantity (Nos)
      userCartRef.doc(grocery.productId).update({'nos': quantity});
    } else {
      // add the product to card
      userCartRef.doc(grocery.productId).set({
        'name': grocery.name,
        'productId': grocery.productId,
        'nos': quantity,
        'price': grocery.price,
        'isFeatured': grocery.isFeatured,
        'imageUrl': grocery.imageUrl,
        'inStock': grocery.inStock,
        'description': grocery.description,
        'gst': grocery.gst,
        'size': grocery.size,
        'discountedPrice': grocery.discountedPrice,
      });
    }
  }
}
