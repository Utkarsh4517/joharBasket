import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';

class ProductBodyText extends StatelessWidget {
  final String text;
  const ProductBodyText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.publicSans(
          color: greyColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
