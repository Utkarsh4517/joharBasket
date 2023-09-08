import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:johar/model/grocery_model.dart';

class GroceryRepo {
  static Future<List<ProductDataModel>> fetchGroceries() async {
    List<ProductDataModel> groceries = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('grocery').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel grocery = ProductDataModel.fromMap(data);
        groceries.add(grocery);
      }

      return groceries;
    } catch (e) {
      return [];
    }
  }

  // add grocery to cart
  static Future<void> addGroceryToCartFromGroceryPage(
      ProductDataModel grocery) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart');
    // check if product is already in cart
    final existingCartItem = await userCartRef.doc(grocery.productId).get();
    if (existingCartItem.exists) {
      // increment the quantity (Nos)
      userCartRef
          .doc(grocery.productId)
          .update({'nos': FieldValue.increment(1)});
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
      });
    }
  }

  static Future<void> addGroceryToCartFromGroceryProductPage(
      ProductDataModel grocery, dynamic quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart');
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
      });
    }
  }
}
