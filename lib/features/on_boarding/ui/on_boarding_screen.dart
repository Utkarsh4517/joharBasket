import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/shared/button.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, 'googleSignIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 226, 245, 251),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/svgs/animation_1.json',
                      height: getScreenheight(context) * 0.5),
                ],
              ),
              Text(
                'Johar Basket',
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: getScreenWidth(context) * 0.1,
                ),
              ),
              SizedBox(height: getScreenWidth(context) * 0.05),
              Text(
                'Your One Stop Shop for Groceries to Stationery and Cosmetic Products',
                textAlign: TextAlign.center,
                style: GoogleFonts.leagueSpartan(
                  color: greyColor,
                  fontWeight: FontWeight.w600,
                  fontSize: getScreenWidth(context) * 0.07,
                ),
              ),
              SizedBox(height: getScreenWidth(context) * 0.1),
              TextButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, 'googleSignIn');
                  _completeOnboarding();
                },
                child: const Button(radius: 40, text: 'Get Started'),
              ),
            ],
          ),
        ));
  }
}
