import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';

class SmallTextBody extends StatelessWidget {
  final String text;
  const SmallTextBody({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.publicSans(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: getScreenWidth(context) * 0.03,
      ),
    );
  }
}
