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
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, navigate to the home screen
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
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
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
  }) async {

    // get fcm token
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'address': address,
      'pincode': pinCode,
      'userExists': true,
      'fcm': fcmToken,
    });
  }


}
