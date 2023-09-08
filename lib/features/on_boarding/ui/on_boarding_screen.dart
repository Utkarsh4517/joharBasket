import 'package:flutter/material.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/on_boarding/ui/widgets/body_text.dart';
import 'package:johar/shared/button.dart';
import 'package:johar/features/on_boarding/ui/widgets/head_text.dart';
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
      body: Stack(
        children: [
          Positioned(
            left: -getScreenWidth(context) * 0.15,
            top: -getScreenheight(context) * 0.03,
            child: Image.asset(
              'assets/img/girl 1.png',
              scale: 1.15,
            ),
          ),
          Positioned(
            top: getScreenheight(context) * 0.5,
            left: -getScreenWidth(context) * 0.5,
            child: Container(
              width: getScreenWidth(context) * 2,
              height: getScreenWidth(context) * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getScreenWidth(context) * 0.12),
                  const HeadText(text: 'Buy Groceries Easily With Us'),
                  SizedBox(height: getScreenWidth(context) * 0.05),
                  const BodyText(
                    text:
                        'Your One-Stop Haven for Stationary and Grocery Delights – Discover Convenience at Johar Basket!',
                  ),
                  SizedBox(height: getScreenWidth(context) * 0.15),
                  GestureDetector(
                    // onTapUp: (details) => _completeOnboarding(),
                    onTapUp: (details) {
                      // _completeOnboarding();
                       Navigator.pushReplacementNamed(context, 'googleSignIn');
                    },

                    child: const Button(
                      text: 'Get Started',
                      radius: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
