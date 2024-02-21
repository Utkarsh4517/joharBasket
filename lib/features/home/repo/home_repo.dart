import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:johar/model/grocery_model.dart';

class HomeRepo {
  static Future<List<ProductDataModel>> fetchAllProducts() async {
    List<ProductDataModel> products = [];

    try {
      QuerySnapshot grocerySnapshot = await FirebaseFirestore.instance.collection('grocery').get();

      for (QueryDocumentSnapshot documentSnapshot in grocerySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel grocery = ProductDataModel.fromMap(data);
        products.add(grocery);
      }

      QuerySnapshot cosmeticSnapshot = await FirebaseFirestore.instance.collection('cosmetics').get();

      for (QueryDocumentSnapshot documentSnapshot in cosmeticSnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel cosmetic = ProductDataModel.fromMap(data);
        products.add(cosmetic);
      }

      QuerySnapshot stationarySnapshot = await FirebaseFirestore.instance.collection('stationary').get();

      for (QueryDocumentSnapshot documentSnapshot in stationarySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel stationary = ProductDataModel.fromMap(data);
        products.add(stationary);
      }
      QuerySnapshot poojaSnapshot = await FirebaseFirestore.instance.collection('stationary').get();

      for (QueryDocumentSnapshot documentSnapshot in poojaSnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel pooja = ProductDataModel.fromMap(data);
        products.add(pooja);
      }

      return products;
    } catch (e) {
      return [];
    }
  }
}
