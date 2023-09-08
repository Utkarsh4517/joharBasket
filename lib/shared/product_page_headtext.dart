import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';

class ProductHeadText extends StatelessWidget {
  final String text;
  const ProductHeadText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getScreenWidth(context) * 0.06),
      width: getScreenWidth(context) * 0.65,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.publicSans(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: getScreenWidth(context) * 0.06),
      ),
    );
  }
}
