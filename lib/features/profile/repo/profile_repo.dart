import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:johar/model/grocery_model.dart';

class ProfileRepo {
  static Future<String> uploadImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) return '';

    try {
      final File imageFile = File(file.path);

      // Compress the image
      final decodedImage = img.decodeImage(imageFile.readAsBytesSync());
      final compressedImage = img.encodeJpg(decodedImage!,
          quality: 15); // Adjust the quality as needed

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference referenceRoot = FirebaseStorage.instance.ref();
      final Reference referenceDirImage = referenceRoot.child('images');
      final Reference referenceImageToUpload =
          referenceDirImage.child('$fileName.jpg');

      await referenceImageToUpload
          .putData(compressedImage); // Use putData instead of putFile

      final String imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  static Future<void> addNewProduct({
    required String collectionName,
    required String name,
    required String description,
    required String imageUrl,
    required double inStock,
    required double price,
    required double gst,
    required bool isFeatured,
    required String productId,
    required String size,
    required dynamic discountedPrice,
  }) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(productId);
    Map<String, dynamic> product = {
      'productId': productId,
      'inStock': inStock,
      'imageUrl': imageUrl,
      'name': name,
      'isFeatured': isFeatured,
      'description': description,
      'price': price,
      'gst': gst,
      'size': size,
      'discountedPrice': discountedPrice
    };
    documentReference.set(product);
  }

  // stream builder to show groceries
  static Stream<List<ProductDataModel>> getProducts() {
    final collection = FirebaseFirestore.instance.collection('grocery');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductDataModel(
          gst: data['gst'],
          imageUrl: data['imageUrl'],
          name: data['name'],
          isFeatured: data['isFeatured'],
          price: data['price'],
          productId: data['productId'],
          nos: 0,
          description: data['description'],
          inStock: data['inStock'],
          size: data['size'],
          discountedPrice: data['discountedPrice'],
        );
      }).toList();
    });
  }

  static Stream<List<ProductDataModel>> getStationaryProducts() {
    final collection = FirebaseFirestore.instance.collection('stationary');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductDataModel(
          gst: data['gst'],
          imageUrl: data['imageUrl'],
          name: data['name'],
          isFeatured: data['isFeatured'],
          price: data['price'],
          productId: data['productId'],
          nos: 0,
          description: data['description'],
          inStock: data['inStock'],
          size: data['size'],
          discountedPrice: data['discountedPrice'],
        );
      }).toList();
    });
  }

  static Stream<List<ProductDataModel>> getCosmeticProducts() {
    final collection = FirebaseFirestore.instance.collection('stationary');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductDataModel(
          gst: data['gst'],
          imageUrl: data['imageUrl'],
          name: data['name'],
          isFeatured: data['isFeatured'],
          price: data['price'],
          productId: data['productId'],
          nos: 0,
          description: data['description'],
          inStock: data['inStock'],
          size: data['size'],
          discountedPrice: data['discountedPrice'],
        );
      }).toList();
    });
  }

  // update product details
  static Future<void> updateProductDetails(
      {required ProductDataModel productDataModel,
      required double inStock,
      required String name,
      required bool isFeatured,
      required String description,
      required double price,
      required double gst,
      required String size,
      required double discountedPrice}) async {
    final document = FirebaseFirestore.instance
        .collection('grocery')
        .doc(productDataModel.productId);

    await document.update({
      'inStock': inStock,
      'name': name,
      'isFeatured': isFeatured,
      'description': description,
      'price': price,
      'gst': gst,
      'size': size,
      'discountedPrice': discountedPrice
    });
  }

  // update stationary details
  static Future<void> updateStationaryDetails(
      {required ProductDataModel productDataModel,
      required double inStock,
      required String name,
      required bool isFeatured,
      required String description,
      required double price,
      required double gst,
      required String size,
      required double discountedPrice}) async {
    final document = FirebaseFirestore.instance
        .collection('stationary')
        .doc(productDataModel.productId);

    await document.update({
      'inStock': inStock,
      'name': name,
      'isFeatured': isFeatured,
      'description': description,
      'price': price,
      'gst': gst,
      'size': size,
      'discountedPrice': discountedPrice
    });
  }

  // update cosmetics
  static Future<void> updateCosmeticsDetails(
      {required ProductDataModel productDataModel,
      required double inStock,
      required String name,
      required bool isFeatured,
      required String description,
      required double price,
      required double gst,
      required String size,
      required double discountedPrice}) async {
    final document = FirebaseFirestore.instance
        .collection('cosmetics')
        .doc(productDataModel.productId);

    await document.update({
      'inStock': inStock,
      'name': name,
      'isFeatured': isFeatured,
      'description': description,
      'price': price,
      'gst': gst,
      'size': size,
      'discountedPrice': discountedPrice
    });
  }

  // delete product ....
  static Future<void> deleteProduct(
      {required ProductDataModel productDataModel}) async {
    final document = FirebaseFirestore.instance
        .collection('grocery')
        .doc(productDataModel.productId);

    await document.delete();
  }

  // delete stationary ....
  static Future<void> deleteStationary(
      {required ProductDataModel productDataModel}) async {
    final document = FirebaseFirestore.instance
        .collection('stationary')
        .doc(productDataModel.productId);

    await document.delete();
  }

  // delete stationary ....
  static Future<void> deleteCosmetic(
      {required ProductDataModel productDataModel}) async {
    final document = FirebaseFirestore.instance
        .collection('cosmetics')
        .doc(productDataModel.productId);

    await document.delete();
  }

  // fetch new orders
  static Future<List<List<ProductDataModel>>> fetchCurrentOrders() async {
    List<List<ProductDataModel>> allOrders = [];

    try {
      DocumentSnapshot allOrderListSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc('orderList')
          .get();
      if (allOrderListSnapshot.exists) {
        List<dynamic> currentList = allOrderListSnapshot.get('ordersList');
        for (int i = 0; i < currentList.length;) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .doc('newOrders')
              .collection(currentList[i])
              .get();
          List<ProductDataModel> orders = [];
          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            if (documentSnapshot.id != 'orderDetails') {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              ProductDataModel order = ProductDataModel.fromMap(data);
              orders.add(order);
            }
          }
          allOrders.add(orders);
          i++;
        }
        return allOrders;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // fetch orderId list
  static Future<List<dynamic>> fetchOrderIdList() async {
    DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('orderList')
        .get();
    List<dynamic> currentList = orderListSnapshot.get('ordersList');
    return currentList;
  }

  // fetch amount
  static Future<String> fetchAmountOfOrder(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String amount = documentSnapshot['amount'];
    return amount;
  }

  // check if order is accepted or not
  static Future<bool> isOrderAccepted(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool isOrderAccepted = documentSnapshot['isAccepted'];
    return isOrderAccepted;
  }

  // check if order is delivered or not
  static Future<bool> isOrderDelivered(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool isOrderDelivered = documentSnapshot['isDelivered'];
    return isOrderDelivered;
  }

  // check if payment is done or not
  static Future<bool> isPaymentReceived(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool idPaymentReceived = documentSnapshot['payment'];
    return idPaymentReceived;
  }

  // ordered by name
  static Future<String> orderedBy(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String userName = documentSnapshot['userName'];
    return userName;
  }

  static Future<String> orderedByMobileNumber(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String mobileNumber = documentSnapshot['mobileNumber'];
    return mobileNumber;
  }

  // fetch address

  static Future<String> fetchAddress(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String address = documentSnapshot['address'];
    return address;
  }

  static Future<String> fetchPincode(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String address = documentSnapshot['pincode'];
    return address;
  }

  // fetch userid
  static Future<String> fetchUserid(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String userid = documentSnapshot['userId'];
    return userid;
  }

  // order accepted by admin
  static Future<void> orderAccepted(
      String userId, String orderid, String deliveryTime) async {
    // generate otp
    final random = Random();
    final code = random.nextInt(900000) + 100000;
    final otp = code.toString();

    final userOrderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc('myOrders')
        .collection(orderid);
    final globalOrderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderid);

    final orderRef = await userOrderRef.doc('orderDetails').get();
    final gOrderRef = await globalOrderRef.doc('orderDetails').get();
    if (orderRef.exists) {
      userOrderRef
          .doc('orderDetails')
          .update({'isAccepted': true, 'time': deliveryTime, 'otp': otp});
    }
    if (gOrderRef.exists) {
      globalOrderRef
          .doc('orderDetails')
          .update({'isAccepted': true, 'time': deliveryTime, 'otp': otp});
    }

    // get the user fcm token....
    DocumentSnapshot fcmSnap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final fcmToken = fcmSnap['fcm'];

    // send notification to the user that his order has been accepted....
    await sendPushMessage(
      token: fcmToken,
      body: 'Your order has been accepted',
      title: 'Order Accepted',
    );
  }

  // Send Order Accepted Push Notification
  static sendPushMessage(
      {required String token,
      required String body,
      required String title}) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA0aFkqfQ:APA91bHMuvfIXpdTLfKjyRP92h7YNtrHoHUZW0_lN8hdjN9QyXkCz8Mdpzfv_48HaM6dmOiSeHkES2KyHO_LWoqP95BtWKq6lqQT6UQGix4YAfm1oTSdjQLvUOZYPyTZAM2SvVT_zA5G'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "johar"
            },
            "to": token
          }));
    } catch (e) {
      print(e.toString());
    }
  }

  // delivery confirmed
  static Future<void> orderDelivered(String userId, String orderid) async {
    final userOrderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc('myOrders')
        .collection(orderid);
    final globalOrderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderid);

    final orderRef = await userOrderRef.doc('orderDetails').get();
    final gOrderRef = await globalOrderRef.doc('orderDetails').get();
    if (orderRef.exists) {
      userOrderRef.doc('orderDetails').update({
        'isDelivered': true,
        'payment': true,
      });
    }
    if (gOrderRef.exists) {
      globalOrderRef.doc('orderDetails').update({
        'isDelivered': true,
        'payment': true,
      });
    }
    moveOrderToPastOrderUser(orderid);
    moveOrderToPastOrderGlobal(orderid);

    // get the user fcm token....
    DocumentSnapshot fcmSnap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final fcmToken = fcmSnap['fcm'];

    // send notification to the user that his order has been accepted....
    await sendPushMessage(
      token: fcmToken,
      body: 'Your order has been delivered',
      title: 'Order Delivered',
    );
  }

  // move order to past order for user
  static Future<void> moveOrderToPastOrderUser(String orderId) async {
    // Source collection reference
    CollectionReference sourceCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId);
    // get the documents from source collection
    QuerySnapshot sourceQuerySnapshot = await sourceCollection.get();

    // Iterate through the documents and copy them to the target location

    for (QueryDocumentSnapshot sourceDocument in sourceQuerySnapshot.docs) {
      // get the data from the source document
      Map<String, dynamic> data = sourceDocument.data() as Map<String, dynamic>;

      // get the document ID of the source document

      String documentID = sourceDocument.id;

      // create a reference to the target location

      DocumentReference targetDocument = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('order')
          .doc('pastOrders')
          .collection(orderId)
          .doc(documentID);
      await targetDocument.set(data);

      // delete source documents
      await sourceDocument.reference.delete();
    }

    // move orderId from orderDetails, order to pastOrderList
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orderDetails')
        .doc('orders');
    DocumentReference docRefPast = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orderDetails')
        .doc('pastOrderList');
    final docRefPastGet = await docRefPast.get();
    if (docRefPastGet.exists) {
      List<dynamic> currentList = docRefPastGet.get('pastOrdersList');
      currentList.add(orderId);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orderDetails')
          .doc('pastOrderList')
          .update({
        'pastOrdersList': currentList,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orderDetails')
          .doc('pastOrderList')
          .set({
        'pastOrdersList': [orderId],
      });
    }
    await docRef.update({
      'orderList': FieldValue.arrayRemove([orderId]),
    });
  }

  static Future<void> moveOrderToPastOrderGlobal(String orderId) async {
    // source collection
    CollectionReference sourceCollection = FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId);

    // get the documents from source collection
    QuerySnapshot sourceQuerySnapshot = await sourceCollection.get();

    // Iterate through the documents and copy them to the target location
    for (QueryDocumentSnapshot sourceDocument in sourceQuerySnapshot.docs) {
      Map<String, dynamic> data = sourceDocument.data() as Map<String, dynamic>;
      String documentID = sourceDocument.id;
      DocumentReference targetDocument = FirebaseFirestore.instance
          .collection('orders')
          .doc('pastOrders')
          .collection(orderId)
          .doc(documentID);

      await targetDocument.set(data);
      await sourceDocument.reference.delete();
    }

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('orders').doc('orderList');

    DocumentReference docRefPast =
        FirebaseFirestore.instance.collection('orders').doc('pastOrderList');

    final docRefPastGet = await docRefPast.get();
    if (docRefPastGet.exists) {
      List<dynamic> currentGlobalList = docRefPastGet.get('pastOrdersList');
      currentGlobalList.add(orderId);

      await FirebaseFirestore.instance
          .collection('orders')
          .doc('pastOrderList')
          .update({
        'pastOrdersList': currentGlobalList,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc('pastOrderList')
          .set({
        'pastOrdersList': [orderId],
      });
    }
    await docRef.update({
      'ordersList': FieldValue.arrayRemove([orderId]),
    });
  }

  // fetch number of delivered orders
  static Future<int> getDeliveredOrdersLength() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('orders').doc('pastOrderList');
    final doc = await documentReference.get();
    if (doc.exists) {
      final List<dynamic> list = doc.get('pastOrdersList');
      return list.length;
    } else {
      return 0;
    }
  }

  // fetch number of pending orders
  static Future<int> getPendingOrdersLength() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('orders').doc('orderList');
    final doc = await documentReference.get();
    if (doc.exists) {
      final List<dynamic> list = doc.get('ordersList');
      return list.length;
    } else {
      return 0;
    }
  }

  // fetch number of canncelled orders
  static Future<int> getCancelledOrdersLength() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('orders')
        .doc('cancelledOrderList');
    final doc = await documentReference.get();
    if (doc.exists) {
      final List<dynamic> list = doc.get('cancelledOrdersList');
      return list.length;
    } else {
      return 0;
    }
  }

  // fetch total sales
  static Future<dynamic> getTotalSales() async {
    double totalAmount = 0;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('orders').doc('pastOrderList');
    final doc = await documentReference.get();
    if (doc.exists) {
      final List<dynamic> pastOrdersList = doc.get('pastOrdersList');
      for (String orderId in pastOrdersList) {
        var amounFieldReference = FirebaseFirestore.instance
            .collection('orders')
            .doc('pastOrders')
            .collection(orderId)
            .doc('orderDetails')
            .get()
            .then((DocumentSnapshot document) {
          if (document.exists) {
            double amount = double.parse(document.get('amount'));
            totalAmount += amount;
          }
        });
        await amounFieldReference;
      }
      return totalAmount;
    } else {
      return 0;
    }
  }

  // fetch total sales
  static Future<dynamic> getTotalGST() async {
    double totalAmount = 0;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('orders').doc('pastOrderList');
    final doc = await documentReference.get();
    if (doc.exists) {
      final List<dynamic> pastOrdersList = doc.get('pastOrdersList');
      for (String orderId in pastOrdersList) {
        var amounFieldReference = FirebaseFirestore.instance
            .collection('orders')
            .doc('pastOrders')
            .collection(orderId)
            .doc('orderDetails')
            .get()
            .then((DocumentSnapshot document) {
          if (document.exists) {
            double amount = double.parse(document.get('gst'));
            totalAmount += amount;
          }
        });
        await amounFieldReference;
      }
      return totalAmount;
    } else {
      return 0;
    }
  }

  //fetch delivered orders
  static Future<List<List<ProductDataModel>>> fetchPastOrders() async {
    List<List<ProductDataModel>> allOrders = [];

    try {
      DocumentSnapshot allOrderListSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc('pastOrderList')
          .get();
      if (allOrderListSnapshot.exists) {
        List<dynamic> currentList = allOrderListSnapshot.get('pastOrdersList');
        for (int i = 0; i < currentList.length;) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .doc('pastOrders')
              .collection(currentList[i])
              .get();
          List<ProductDataModel> orders = [];
          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            if (documentSnapshot.id != 'orderDetails') {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              ProductDataModel order = ProductDataModel.fromMap(data);
              orders.add(order);
            }
          }
          allOrders.add(orders);
          i++;
        }
        return allOrders;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // fetch past order id list
  static Future<List<dynamic>> fetchPastOrderIdList() async {
    DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('pastOrderList')
        .get();
    List<dynamic> currentList = orderListSnapshot.get('pastOrdersList');
    return currentList;
  }

  // fetch amount of delivered order
  static Future<String> fetchOrderAmountDelivered(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('pastOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String amount = documentSnapshot['amount'];
    return amount;
  }

  // fetch username of delivered order
  static Future<String> fetchUsernameDelivered(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc('pastOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String name = documentSnapshot['userName'];
    return name;
  }

  // cancel order ************************************
  static Future<void> cancelOrder(String orderId, String userId) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order')
        .doc('myOrders')
        .collection(orderId);

    QuerySnapshot querySnapshot = await collectionReference.get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }

    // delete orderId from user orderList
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orderDetails')
        .doc('orders');
    await docRef.update({
      'orderList': FieldValue.arrayRemove([orderId])
    });

    await cancelOrderGlobally(orderId, userId);

    // Managing cancel order id globally

    DocumentReference globalDocRef =
        FirebaseFirestore.instance.collection('orders').doc('orderList');

    DocumentReference globalDocRefCancelled = FirebaseFirestore.instance
        .collection('orders')
        .doc('cancelledOrderList');

    // create a new cancelledOrderList and add orderId there (global)

    final globalDocRefGet = await globalDocRefCancelled.get();
    if (globalDocRefGet.exists) {
      List<dynamic> currentGlobalList =
          globalDocRefGet.get('cancelledOrdersList');
      currentGlobalList.add(orderId);

      await FirebaseFirestore.instance
          .collection('orders')
          .doc('cancelledOrderList')
          .update({'cancelledOrdersList': currentGlobalList});
    } else {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc('cancelledOrderList')
          .set({
        'cancelledOrdersList': [orderId]
      });
    }

    // delete orderId from global orderList
    await globalDocRef.update({
      'ordersList': FieldValue.arrayRemove([orderId])
    });
    // get the user fcm token....
    DocumentSnapshot fcmSnap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final fcmToken = fcmSnap['fcm'];

    // send notification to the user that his order has been accepted....
    await sendPushMessage(
      token: fcmToken,
      body: 'Your order has been cancelled',
      title: 'Order cancelled',
    );
  }

  static Future<void> cancelOrderGlobally(String orderId, String userId) async {
    // source collection
    CollectionReference sourceCollection = FirebaseFirestore.instance
        .collection('orders')
        .doc('newOrders')
        .collection(orderId);

    // get the documents from source collection
    QuerySnapshot sourceQuerySnapshot = await sourceCollection.get();

    // Iterate through the documents and copy them to the target location

    for (QueryDocumentSnapshot sourceDocument in sourceQuerySnapshot.docs) {
      //get the data from the source document
      Map<String, dynamic> data = sourceDocument.data() as Map<String, dynamic>;

      // Get the document ID of the source document
      String documentId = sourceDocument.id;

      // create a reference to the target location
      DocumentReference targetDocument = FirebaseFirestore.instance
          .collection('orders')
          .doc('cancelledOrders')
          .collection(orderId)
          .doc(documentId);

      await targetDocument.set(data);

      // delete source documents
      await sourceDocument.reference.delete();
    }
  }
}
