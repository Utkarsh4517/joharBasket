import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getScreenWidth(context) * 0.3),
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/svgs/shopping_bag.svg',
              width: getScreenWidth(context) * 1,
            ),
          ),
          SizedBox(height: getScreenWidth(context) * 0.15),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Welcome to\nJohar Basket !',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: getScreenWidth(context) * 0.084),
            ),
          ),
          SizedBox(height: getScreenWidth(context) * 0.15),
          GestureDetector(
            onTapUp: (details) async {
              await AuthService().continueWithGoogle(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: const Button(
                text: 'Continue With Mobile!',
                radius: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
