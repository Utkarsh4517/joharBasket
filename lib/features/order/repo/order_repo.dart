import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/grocery_model.dart';

class OrderRepo {
  static Future<List<List<ProductDataModel>>> fetchCurrentOrders() async {
    List<List<ProductDataModel>> allOrders = [];

    try {
      // get list of orderIDs from user..

      DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orderDetails')
          .doc('orders')
          .get();
      if (orderListSnapshot.exists) {
        List<dynamic> currentList = orderListSnapshot.get('orderList');

        for (int i = 0; i < currentList.length;) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('order')
              .doc('myOrders')
              .collection(currentList[i])
              .get();

          List<ProductDataModel> orders = [];

          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            if (documentSnapshot.id != 'orderDetails') {
              // print(documentSnapshot.id);
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


  static Future<List<dynamic>> fetchOrderIdList() async {
    DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orderDetails')
        .doc('orders')
        .get();
    List<dynamic> currentList = orderListSnapshot.get('orderList');
    return currentList;
  }

  // fetch past order Id list

  static Future<List<dynamic>> fetchPastOrderIdList() async {
    DocumentSnapshot orderListSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orderDetails')
        .doc('pastOrderList')
        .get();
    List<dynamic> currentList = orderListSnapshot.get('pastOrdersList');
    return currentList;
  }

  // fetch amount
  static Future<String> fetchAmountOfOrder(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    String amount = documentSnapshot['amount'];
    return amount;
  }

  // check if order is accepted or not
  static Future<bool> isOrderAccepted(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool isOrderAccepted = documentSnapshot['isAccepted'];
    return isOrderAccepted;
  }

  // check if order is delivered or not
  static Future<bool> isOrderDelivered(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool isOrderDelivered = documentSnapshot['isDelivered'];
    return isOrderDelivered;
  }

  // check if payment is done or not
  static Future<bool> isPaymentReceived(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    bool idPaymentReceived = documentSnapshot['payment'];
    return idPaymentReceived;
  }

  // if order is accepted fetch expected deilvery time

  // cancel order
  static Future<void> cancelOrder(String orderId) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId);

    // get username
    DocumentSnapshot userRef =
        await collectionReference.doc('orderDetails').get();
    final userName = userRef.get('userName');
    // send the order notification to admin..
    // get the admin fcm token...
    DocumentSnapshot adminFcmSnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('adminFcm')
        .get();
    List<dynamic> adminFcmList = adminFcmSnapshot.get('adminFcms');
    for (var fcm in adminFcmList) {
      ProfileRepo.sendPushMessage(
          token: fcm,
          body: 'An order has been cancelled by $userName',
          title: 'User Cancelled Order');
    }

    QuerySnapshot querySnapshot = await collectionReference.get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }

    // delete orderId from user orderList
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orderDetails')
        .doc('orders');
    await docRef.update({
      'orderList': FieldValue.arrayRemove([orderId])
    });

    await cancelOrderGlobally(orderId);

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
  }

  //  copy the order collection from newOrders doc to cancelledOrders doc, then delete it from newOrders.

  static Future<void> cancelOrderGlobally(String orderId) async {
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

  // fetch expected delivery date
  static Future<String> fetchDeliveryTime(String orderId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    if (documentSnapshot['isAccepted'] == true) {
      String deliveryTime = documentSnapshot['time'] ?? '';
      return deliveryTime;
    } else {
      return '';
    }
  }

  // show otp
  static Future<String> fetchOTP(String orderId, String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('order')
        .doc('myOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    if (documentSnapshot['isAccepted'] == true) {
      String otp = documentSnapshot['otp'] ?? '';
      return otp;
    } else {
      return '';
    }
  }

  // fetch delivery time for past orders
  static Future<DateTime> fetchDeliveredOnTime(
      String orderId, String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('order')
        .doc('pastOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
    Timestamp date = documentSnapshot['deliveryTime'];
    return date.toDate();
  }

  // fetch past order amount
  static Future<dynamic> fetchPastOrderAmount(String orderId, String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('order')
        .doc('pastOrders')
        .collection(orderId)
        .doc('orderDetails')
        .get();
        return documentSnapshot['amount'];
  }

  // fetch past orders...
  static Future<List<List<ProductDataModel>>> fetchPastOrders() async {
    List<List<ProductDataModel>> allOrders = [];

    try {
      // get list of orderIDs from user..

      DocumentSnapshot pastOrderListSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orderDetails')
          .doc('pastOrderList')
          .get();
      if (pastOrderListSnapshot.exists) {
        List<dynamic> currentList = pastOrderListSnapshot.get('pastOrdersList');

        for (int i = 0; i < currentList.length;) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('order')
              .doc('pastOrders')
              .collection(currentList[i])
              .get();

          List<ProductDataModel> orders = [];

          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            if (documentSnapshot.id != 'orderDetails') {
              // print(documentSnapshot.id);
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

  // fetch delivery time
}
