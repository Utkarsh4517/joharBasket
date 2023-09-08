import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';

class Button extends StatelessWidget {
  final String text;
  final double radius;
  final double paddingH;
  final double paddingV;
  final Gradient grd;
  const Button({
    this.grd = linerGrd,
    this.paddingH = 0.15,
    this.paddingV = 0.065,
    required this.radius,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getScreenWidth(context) * paddingV,
        horizontal: getScreenWidth(context) * paddingH,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        gradient: grd
      ),
      child: Text(
        text,
        style: GoogleFonts.publicSans(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
