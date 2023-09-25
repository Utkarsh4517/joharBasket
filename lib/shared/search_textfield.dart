import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/model/grocery_model.dart';

class SearchTextField extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final GroceryLoadedSuccessState successState;
  const SearchTextField({
    required this.successState,
    required this.controller,
    super.key,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class _SearchTextFieldState extends State<SearchTextField> {
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

  void searchProducts(String query) {}

  @override
  Widget build(BuildContext context) {
    List<ProductDataModel> products = widget.successState.products;

    void searchProducts(String query) {
      final suggestions = widget.successState.products.where((product) {
        final productTitle = product.name.toLowerCase();
        final input = query.toLowerCase();
        return productTitle.contains(input);
      }).toList();

      setState(() {
        products = suggestions;
      });
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.055,
        vertical: getScreenWidth(context) * 0.04,
      ),
      child: Column(
        children: [
          // name and profile pic
          TextField(
            onChanged: searchProducts,
            controller: widget.controller,
            style: const TextStyle(color: greyColor),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                FeatherIcons.search,
                color: greyColor,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(14)),
              filled: true,
              labelText: 'Search Products',
              labelStyle: const TextStyle(color: greyColor),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: getScreenheight(context) * 0.8,
            child: ListView.builder(
              itemCount: widget.successState.products.length,
              itemBuilder: (context, index) {
                final product = widget.successState.products[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.02,
                    vertical: getScreenWidth(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        width: getScreenWidth(context) * 0.2,
                      ),
                      Text(
                        product.name,
                        style: GoogleFonts.publicSans(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' ',
                        style: GoogleFonts.publicSans(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.size!,
                        style: GoogleFonts.publicSans(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
