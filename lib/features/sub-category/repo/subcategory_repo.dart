import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:johar/model/grocery_model.dart';

class SubCategoryRepo {
  static Future<List<ProductDataModel>> getSubCategoryProducts(String subCategory) async {
    List<ProductDataModel> filteredProducts = [];
    try {
      QuerySnapshot cosmeticsQuerySnapshot = await FirebaseFirestore.instance.collection('cosmetics').where('subCategory', isEqualTo: subCategory).get();
      QuerySnapshot groceryQuerySnapshot = await FirebaseFirestore.instance.collection('grocery').where('subCategory', isEqualTo: subCategory).get();
      QuerySnapshot poojaQuerySnapshot = await FirebaseFirestore.instance.collection('pooja').where('subCategory', isEqualTo: subCategory).get();
      QuerySnapshot stationaryQuerySnapshot = await FirebaseFirestore.instance.collection('stationary').where('subCategory', isEqualTo: subCategory).get();

      filteredProducts.addAll(_convertQuerySnapshotToProductDataModels(cosmeticsQuerySnapshot));
      filteredProducts.addAll(_convertQuerySnapshotToProductDataModels(groceryQuerySnapshot));
      filteredProducts.addAll(_convertQuerySnapshotToProductDataModels(poojaQuerySnapshot));
      filteredProducts.addAll(_convertQuerySnapshotToProductDataModels(stationaryQuerySnapshot));

      return filteredProducts;
    } catch (e) {
      throw e;
    }
  }

  static List<ProductDataModel> _convertQuerySnapshotToProductDataModels(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return ProductDataModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
