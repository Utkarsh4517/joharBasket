import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';


class BodyText extends StatelessWidget {
  final String text;
  const BodyText({
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
            color: greyColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
