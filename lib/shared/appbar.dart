import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/widgets/topbar.dart';
import 'package:johar/features/search/ui/grocery_search_page.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final GroceryLoadedSuccessState successState;
  const CustomAppbar({
    required this.controller,
    required this.successState,
    super.key,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class _CustomAppbarState extends State<CustomAppbar> {

  @override
  void initState() {
    getUserName();
    super.initState();
  }


  String firstName = '';
  String lastName = '';

  void getUserName() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      String name1 = snapshot.get('firstName');
      String name2 = snapshot.get('lastName');
      setState(() {
        firstName = name1;
        lastName = name2;
      });
    }
  }

  void updateList(String value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.055,
          vertical: getScreenWidth(context) * 0.04,
        ).copyWith(bottom: 0),
        child: Column(
          children: [
            SizedBox(height: getScreenWidth(context) * 0.05),
            TopBar(
              firstName: firstName,
              lastName: lastName,
            ),
            SizedBox(height: getScreenWidth(context) * 0.05),
            GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          successState: widget.successState,
                        ),
                      ),
                    ),
                child: Container(
                  margin: EdgeInsets.all(getScreenWidth(context) * 0.01),
                  padding: EdgeInsets.all(getScreenWidth(context) * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search Products',
                        style: TextStyle(
                          color: greyColor,
                        ),
                      ),
                      Icon(
                        FeatherIcons.search,
                        color: greyColor,
                      )
                    ],
                  ),
                )
            
                ),
          ],
        ));
  }
}
