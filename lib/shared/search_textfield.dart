import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenWidth(context) * 0.15,
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.055,
        vertical: getScreenWidth(context) * 0.04,
      ),
      child: TextField(
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
                borderSide: const BorderSide(color: Colors.white))),
      ),
    );
  }
}
