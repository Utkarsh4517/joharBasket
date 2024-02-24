import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/features/auth/service/auth_service.dart';
import 'package:johar/shared/button.dart';

import '../../../constants/dimensions.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  bool isOtpSent = false;
  String vId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getScreenheight(context) * 0.05),
            // Container(
            //   alignment: Alignment.center,
            //   child: SvgPicture.asset(
            //     'assets/svgs/shopping_bag.svg',
            //     width: getScreenWidth(context) * 1,
            //   ),
            // ),
            SizedBox(height: getScreenWidth(context) * 0.15),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Welcome to\nJohar Basket !',
                textAlign: TextAlign.start,
                style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w900, fontSize: getScreenWidth(context) * 0.084),
              ),
            ),
            SizedBox(height: getScreenWidth(context) * 0.1),

            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 10),
              child: Text(
                !isOtpSent ? 'Enter your mobile number' : 'Enter OTP',
                textAlign: TextAlign.start,
                style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w900, fontSize: getScreenWidth(context) * 0.054),
              ),
            ),
            if (!isOtpSent)
              Container(
                alignment: Alignment.center,
                height: 50,
                child: OtpTextField(
                  numberOfFields: 10,
                  borderColor: Color(0xFF512DA8),
                  showFieldAsBox: false,
                  fieldWidth: 25,

                  onCodeChanged: (String code) {},
                  onSubmit: (String phoneNumber) async {
                    await sendOTP(context, phoneNumber);
                  }, // end onSubmit
                ),
              ),
            SizedBox(height: getScreenWidth(context) * 0.1),
            if (isOtpSent)
              Container(
                alignment: Alignment.center,
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  showFieldAsBox: true,
                  fieldWidth: 45,
                  borderRadius: BorderRadius.circular(12),
                  autoFocus: true,

                  onCodeChanged: (String code) {},
                  onSubmit: (String code) async {
                    await verifyOTP(context, code);
                  }, // end onSubmit
                ),
              ),
            // GestureDetector(
            //   onTapUp: (details) async {
            //     // await AuthService().continueWithGoogle(context);
            //     await AuthService().verifyPhone('9135447086', context);
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     child: const Button(
            //       text: 'Continue With Google',
            //       radius: 15,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> sendOTP(BuildContext context, String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacementNamed(context, 'authLoadingPage');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          vId = verificationId;
          isOtpSent = true;
          print(isOtpSent);
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTP(BuildContext context, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: vId,
      smsCode: otp,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacementNamed(context, 'authLoadingPage');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
