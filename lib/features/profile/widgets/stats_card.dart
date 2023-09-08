import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/dimensions.dart';

class StatsCard extends StatelessWidget {
  final String text;
  final Color color;
  final String data;
  final double sizeFactor;
  const StatsCard({
    required this.text,
    required this.color,
    required this.data,
    this.sizeFactor = 0.12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.045,
        vertical: getScreenWidth(context) * 0.02,
      ),
      padding: EdgeInsets.all(
        getScreenWidth(context) * 0.01,
      ),
      width: getScreenWidth(context) * 0.4,
      height: getScreenWidth(context) * 0.4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(getScreenWidth(context) * 0.02),
            child: Text(
              text,
              style: GoogleFonts.publicSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: getScreenWidth(context) * 0.035,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(getScreenWidth(context) * 0.02),
            child: Text(
              data,
              style: GoogleFonts.publicSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: getScreenWidth(context) * sizeFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
