import 'package:cloud_firestore/cloud_firestore.dart';

class BillRepo {
  static Future<void> invoiceUpdate() async {
    final invoiceRef =
        FirebaseFirestore.instance.collection('invoice').doc('invoice');

    final invoice = await invoiceRef.get();

    if (invoice.exists) {
      invoiceRef.update({'nos': FieldValue.increment(1)});
    }
  }

  static Future<dynamic> getInvoiceNo() async {
    final invoiceRef =
        FirebaseFirestore.instance.collection('invoice').doc('invoice');

    final invoice = await invoiceRef.get();

    if (invoice.exists) {
      return invoice['nos'];
    }
  }
}
