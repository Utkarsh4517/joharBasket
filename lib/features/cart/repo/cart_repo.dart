// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/coupon_model.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:uuid/uuid.dart';

class CartRepo {
  // fetch cart Items
  static Future<List<ProductDataModel>> fetchProducts() async {
    List<ProductDataModel> products = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('cart').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        ProductDataModel product = ProductDataModel.fromMap(data);
        products.add(product);
      }
      return products;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // increase the quantity
  static Future<void> increaseQuantity(ProductDataModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart');

    final existingCartItem = await userCartRef.doc(product.productId).get();

    if (existingCartItem.exists) {
      userCartRef.doc(product.productId).update({'nos': FieldValue.increment(1)});
    }
  }

  // decrease the quantity
  static Future<void> decreaseQuantity(ProductDataModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart');

    final existingCartItem = await userCartRef.doc(product.productId).get();

    if (existingCartItem.exists) {
      userCartRef.doc(product.productId).update({'nos': FieldValue.increment(-1)});
    }
  }

  // fetch quantity
  static Future<dynamic> fetchQuantity(ProductDataModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    final userCartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart');

    final existingCartItem = await userCartRef.doc(product.productId).get();

    if (existingCartItem.exists) {
      return existingCartItem['nos'];
    }
  }

  // delete product from cart
  static Future<void> deleteProduct(ProductDataModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart').doc(product.productId).delete();
  }

  static Future<dynamic> calculateSubTotal() async {
    dynamic sum = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('cart');

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (var document in querySnapshot.docs) {
      dynamic price = document['discountedPrice'] ?? 0.0;
      dynamic nos = document['nos'] ?? 0.0;
      sum += (price * nos);
    }
    return sum;
  }

  static Future<dynamic> calculateTotalWithoutDiscount() async {
    dynamic sum = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('cart');

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (var document in querySnapshot.docs) {
      dynamic price = document['price'] ?? 0.0;
      dynamic nos = document['nos'] ?? 0.0;
      sum += (price * nos);
    }
    return sum;
  }

  static Future<dynamic> calculateGst() async {
    dynamic sum = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('cart');

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (var document in querySnapshot.docs) {
      dynamic gst = document['gst'] ?? 0.0;
      dynamic nos = document['nos'] ?? 0.0;
      sum += (gst * nos);
    }
    return sum;
  }

  // get user name
  static Future<String> getFirstUserName() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['firstName'];
    } else {
      return 'Name not found';
    }
  }

  static Future<String> getLastUserName() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['lastName'];
    } else {
      return 'Name not found';
    }
  }

  // get user mobile

  static Future<String> getUserMobile() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['mobileNumber'];
    } else {
      return 'Mobile not found';
    }
  }

  // get  user pincode

  static Future<String> getUserPin() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['pincode'];
    } else {
      return 'Pincode not found';
    }
  }

  // get user addresss

  static Future<String> getUserAddress() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['address'];
    } else {
      return 'Address not found';
    }
  }

  static Future<String> getUserHouseNo() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['houseNo'];
    } else {
      return 'House not found';
    }
  }

  static Future<String> getUserLandmark() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['landmark'];
    } else {
      return 'Landmark not found';
    }
  }

  static Future<String> getUserCity() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['city'];
    } else {
      return 'City not found';
    }
  }

  // check the pincode from the
  static Future<bool> doWeDeliverHere(String userPin) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('billing').doc('acceptablePincode').get();
    if (documentSnapshot.exists) {
      List<dynamic> docs = documentSnapshot.get('pincode');
      if (docs.contains(userPin)) {
        return true;
      } else {
        return false;
      }
      // print(docs);
      // return true;
    } else {
      print('false');
      return false;
    }
  }

  // add cart products to order
  static Future<void> addProductsToOrder(List<ProductDataModel> products, String amount, String gst, bool isPaid) async {
    var uuid = const Uuid();
    final orderId = uuid.v1();
    print(orderId);

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('order').doc('myOrders').collection(orderId);

    // admin collection reference
    CollectionReference adminOrderCollectionRef = FirebaseFirestore.instance.collection('orders').doc('newOrders').collection(orderId);

    for (ProductDataModel product in products) {
      await collectionReference.doc(product.productId).set({
        'name': product.name,
        'productId': product.productId,
        'nos': product.nos,
        'price': product.price,
        'isFeatured': product.isFeatured,
        'imageUrl': product.imageUrl,
        'inStock': product.inStock,
        'description': product.description,
        'gst': product.gst,
        'size': product.size,
        'discountedPrice': product.discountedPrice,
      });
    }

    for (ProductDataModel product in products) {
      // admin one
      await adminOrderCollectionRef.doc(product.productId).set({
        'name': product.name,
        'productId': product.productId,
        'nos': product.nos,
        'price': product.price,
        'isFeatured': product.isFeatured,
        'imageUrl': product.imageUrl,
        'inStock': product.inStock,
        'description': product.description,
        'gst': product.gst,
        'size': product.size,
        'discountedPrice': product.discountedPrice,
      });
    }

    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    // add user details
    if (userDocumentSnapshot.exists) {
      await collectionReference.doc('orderDetails').set({
        'isAccepted': false,
        'isDelivered': false,
        'payment': isPaid,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'userName': userDocumentSnapshot['firstName'] + userDocumentSnapshot['lastName'],
        'mobileNumber': userDocumentSnapshot['mobileNumber'],
        'pincode': userDocumentSnapshot['pincode'],
        'address': userDocumentSnapshot['address'],
        'amount': amount,
        'gst': gst,
        'orderTime': FieldValue.serverTimestamp()
      });

      await adminOrderCollectionRef.doc('orderDetails').set({
        'isAccepted': false,
        'isDelivered': false,
        'payment': isPaid,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'userName': userDocumentSnapshot['firstName'] + userDocumentSnapshot['lastName'],
        'mobileNumber': userDocumentSnapshot['mobileNumber'],
        'pincode': userDocumentSnapshot['pincode'],
        'address': userDocumentSnapshot['address'],
        'amount': amount,
        'gst': gst,
        'orderTime': FieldValue.serverTimestamp()
      });
    }

    // add orderid to orderlist of user

    DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('orderDetails').doc('orders').get();

    if (orderListSnapshot.exists) {
      List<dynamic> currentList = orderListSnapshot.get('orderList');
      currentList.add(orderId);

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('orderDetails').doc('orders').update({'orderList': currentList});
    } else {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('orderDetails').doc('orders').set({
        'orderList': [orderId]
      });
    }

    // add orderId to global orderList
    DocumentSnapshot globalOrdereList = await FirebaseFirestore.instance.collection('orders').doc('orderList').get();

    if (globalOrdereList.exists) {
      // List<dynamic> currentGlobalList = orderListSnapshot.get('orderList');
      List<dynamic> currentGlobalList = globalOrdereList.get('ordersList');
      currentGlobalList.add(orderId);

      await FirebaseFirestore.instance.collection('orders').doc('orderList').update({'ordersList': currentGlobalList});
    } else {
      await FirebaseFirestore.instance.collection('orders').doc('orderList').set({
        'ordersList': [orderId]
      });
    }

    // send the order notification to admin..
    final usrref = await collectionReference.doc('orderDetails').get();
    final usrName = usrref.get('userName');
    // get the admin fcm token...
    DocumentSnapshot adminFcmSnapshot = await FirebaseFirestore.instance.collection('admin').doc('adminFcm').get();
    List<dynamic> adminFcmList = adminFcmSnapshot.get('adminFcms');
    for (var fcm in adminFcmList) {
      ProfileRepo.sendPushMessage(
        token: fcm,
        body: 'A new order has been placed by $usrName',
        title: 'New Order',
      );
    }

    // Reduce inStock....

    // loop inside three collection
    // create three collection list
    List collectionsToLoop = ['cosmetics', 'grocery', 'stationary'];
    for (var collection in collectionsToLoop) {
      for (var product in products) {
        final docId = product.productId;
        final quantity = product.nos;

        // fetch the document with the matching product id
        final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
        final doc = await docRef.get();

        if (doc.exists) {
          final currentStock = doc.get('inStock');
          final newStock = currentStock - quantity;

          // update the inStock of that document ...
          try {
            await FirebaseFirestore.instance.collection(collection).doc(docId).update({
              'inStock': newStock,
            });
          } catch (e) {
            print(e.toString());
          }
        }
      }
    }
  }

  // empty cart
  static Future<void> emptyCart() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('cart');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  static Future<void> updateUserDetails({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    // required String address,
    // required String pinCode,
  }) async {
    // get fcm token
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      // 'address': address,
      // 'pincode': pinCode,
      'userExists': true,
      'fcm': fcmToken,
    });
  }

  static Future<void> updateUserAddress({
    required String pincode,
    required String address,
    required String houseNo,
    required String city,
    required String landmark,
  }) async {
    // get fcm token
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'address': address,
      'pincode': pincode,
      'houseNo': houseNo,
      'city': city,
      'landmark': landmark,
      'userExists': true,
      'fcm': fcmToken,
    });
  }

  static Future<CouponModel?> verifyCoupon({required String couponCode}) async {
    CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');

    try {
      var docSnapshot = await coupons.doc(couponCode).get();
      if (docSnapshot.exists) {
        return CouponModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching coupon: $e');
      return null;
    }
  }
}
