import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/ui/profile_page.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06),
      height: getScreenWidth(context) * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome',
                style: GoogleFonts.publicSans(
                  color: greyColor,
                  fontWeight: FontWeight.w600,
                  fontSize: getScreenWidth(context) * 0.04,
                ),
              ),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.publicSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: getScreenWidth(context) * 0.045,
                ),
              ),
            ],
          ),

          // profile pic
          // GestureDetector(
          //   // only if the user is admin
          //   onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const ProfilePage(),
          //     ),
          //   ),
          //   child: Container(
          //       width: getScreenWidth(context) * 0.12,
          //       height: getScreenWidth(context) * 0.12,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: Text('Admin')),
          // ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: const Text('Admin'),
          ),
        ],
      ),
    );
  }
}
