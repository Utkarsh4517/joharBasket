import 'package:flutter/material.dart';
import 'package:johar/constants/dimensions.dart';

class DetailsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double hMargin;
  final double vMargin;
  const DetailsTextField({
    required this.controller,
    required this.label,
    this.hMargin = 0.07,
    this.vMargin = 0.04,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * hMargin,
        vertical: getScreenWidth(context) * vMargin,
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8)),
            filled: true,
            labelText: label,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white))),
      ),
    );
  }
}
