// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:johar/constants/dimensions.dart';

class MyTimeLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String text;
  const MyTimeLine({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      beforeLineStyle:
          LineStyle(color: isPast ? Colors.green : Colors.green[100]!),
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
          color: isPast ? Colors.green : Colors.green[100]!,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: isPast ? Colors.white : Colors.green,
          )),
      endChild: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05),
        child: Text(
          text,
          style: GoogleFonts.publicSans(
              color: isPast ? Colors.green : Colors.black,
              fontWeight: isPast ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
