import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';

class HeadText extends StatelessWidget {
  final String text;
  const HeadText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenWidth(context) * 0.72,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.publicSans(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: getScreenWidth(context) * 0.094),
        ),
      ),
    );
  }
}
