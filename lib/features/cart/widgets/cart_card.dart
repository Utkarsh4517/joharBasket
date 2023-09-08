import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/model/grocery_model.dart';

class CartCard extends StatefulWidget {
  final CartBloc bloc;
  final String productId;
  final dynamic nos;
  final dynamic inStock;
  final String imageUrl;
  final String name;
  final bool isFeatured;
  final dynamic price;
  final ProductDataModel productDataModel;
  final String description;
  final dynamic gst;
  final dynamic discountedPrice;
  final String size;
  const CartCard({
    required this.gst,
    required this.size,
    required this.bloc,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.productId,
    required this.inStock,
    required this.isFeatured,
    required this.description,
    required this.productDataModel,
    required this.nos,
    required this.discountedPrice,
    super.key,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  dynamic quantity = 0;
  dynamic productQuantity = 0;

  // fetch quantity from fb

  fetchQuantity() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cart')
        .doc(widget.productId)
        .get();
    if (doc.exists) {
      if (mounted) {
        setState(() {
          quantity = doc['nos'];
        });
      }
    }
  }

  // fetch the qauntity in products section
  fetchProductQuantity() async {
    final doc = await FirebaseFirestore.instance
        .collection('grocery')
        .doc(widget.productId)
        .get();
    if (doc.exists) {
      if (mounted) {
        setState(() {
          productQuantity = doc['inStock'];
        });
      }
    }
  }

  Timer? timer;

  @override
  void initState() {
    fetchQuantity();
    fetchProductQuantity();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchQuantity();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.06,
          vertical: getScreenWidth(context) * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: getScreenWidth(context) * 0.02),
            width: getScreenWidth(context) * 0.2,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getScreenWidth(context) * 0.425,
                alignment: Alignment.topLeft,
                child: Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.publicSans(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: getScreenWidth(context) * 0.425,
                alignment: Alignment.topLeft,
                child: Text(
                  widget.size,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.publicSans(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '₹ ${widget.discountedPrice}   ',
                      style: GoogleFonts.publicSans(
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: getScreenWidth(context) * 0.04,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '₹ ${widget.price}',
                      style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                          fontSize: getScreenWidth(context) * 0.03,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // -
              // if nos in firebase is > 2 then decrease quantity
              if (quantity != null && quantity >= 2)
                GestureDetector(
                  onTap: () {
                    widget.bloc.add(CartBillRefreshEvent());

                    widget.bloc.add(CartProductQuantityDecreaseEvent(
                        product: widget.productDataModel));
                    fetchQuantity();
                    widget.bloc.add(CartBillRefreshEvent());
                    widget.bloc.add(CartBillRefreshEvent());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getScreenWidth(context) * 0.01),
                    padding: EdgeInsets.all(getScreenWidth(context) * 0.025),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: linerGrd,
                    ),
                    child: const Text(
                      '-',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),

              // if nos in firebase is 1 then remove item from cart
              if (quantity != null && quantity < 2)
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          duration: Duration(milliseconds: 800),
                          content:
                              Text('Slide the item to remove it from cart!'))),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getScreenWidth(context) * 0.01),
                    padding: EdgeInsets.all(getScreenWidth(context) * 0.025),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: linerGrdBw,
                    ),
                    child: const Text(
                      '-',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),

              // quantity
              Text(quantity.toString(),
                  style: GoogleFonts.publicSans(
                      color: Colors.black, fontWeight: FontWeight.bold)),

              //+
              GestureDetector(
                onTap: () async {
                  if (quantity < productQuantity) {
                    widget.bloc.add(CartBillRefreshEvent());

                    widget.bloc.add(CartProductQuantityIncreaseEvent(
                        product: widget.productDataModel));
                    fetchQuantity();
                    widget.bloc.add(CartBillRefreshEvent());
                    widget.bloc.add(CartBillRefreshEvent());
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.01,
                  ),
                  padding: EdgeInsets.all(
                    getScreenWidth(context) * 0.025,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: linerGrd,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
