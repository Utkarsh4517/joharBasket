// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  continueWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, navigate to the home screen
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacementNamed(context, 'authLoadingPage');
      }
      return user;
    } else {
      // Handle sign in errors
      return null;
    }
  }

  // check if user exists or not
  doesUserExists(String userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      if (snapshot.data()!.containsKey('userExists')) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // upload user details to firestore database
  Future<void> uploadUserDetails({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String address,
    required String pinCode,
    required String houseNo,
    required String landmark,
    required String city,
  }) async {
    // get fcm token
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'address': address,
      'landmark': landmark,
      'city': city,
      'houseNo': houseNo,
      'pincode': pinCode,
      'userExists': true,
      'fcm': fcmToken,
    });
  }

  verifyPhone(String phoneNumber, BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (e.g., on Android devices)
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Handle OTP code sent
        // Typically, you would store verificationId to use later
        String smsCode = '999999'; // Enter the received OTP manually
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacementNamed(context, 'authLoadingPage');
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout for auto-retrieval of OTP
      },
    );
  }
}
