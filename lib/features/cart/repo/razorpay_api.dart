import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:johar/constants/razorpay.dart';

class RazorpayAPI {
  static Future<String> createRazorpayOrder({required dynamic amount}) async {

    String keyId = key;
    String keySecret = secret;
    String apiUrl = 'https://api.razorpay.com/v1/orders';
    Map<String, dynamic> payload = {
      "amount": amount,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    String jsonPayload = jsonEncode(payload);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'content-type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$keyId:$keySecret'))}'
        },
        body: jsonPayload,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print(response.body);
        return responseData['id'].toString();
      } else {
        print(response.body);
        return '';

      }
    } catch (error) {
      print(error);
      return '';
    }
  }
}
