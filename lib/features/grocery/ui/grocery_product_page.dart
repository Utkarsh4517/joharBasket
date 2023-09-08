import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/ui/cart_page.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/shared/button.dart';
import 'package:johar/shared/product_page_bodytext.dart';
import 'package:johar/shared/product_page_headtext.dart';

class GroceryProductPage extends StatefulWidget {
  final ProductDataModel grocery;
  const GroceryProductPage({
    required this.grocery,
    super.key,
  });

  @override
  State<GroceryProductPage> createState() => _GroceryProductPageState();
}

class _GroceryProductPageState extends State<GroceryProductPage> {
  dynamic quantity = 1;
  bool isTouched1 = false;
  bool isTouched2 = false;

  void handleTap1() {
    setState(() {
      isTouched1 = !isTouched1;
    });
  }

  void increaseQuantity() {
    setState(() {
      quantity = quantity + 1;
    });
  }

  void decreaseQuantity() {
    if (quantity >= 2) {
      setState(() {
        quantity = quantity - 1;
      });
    }
  }

  void handleTap2() {
    setState(() {
      isTouched2 = !isTouched2;
    });
  }

  final GroceryBloc groceryBloc = GroceryBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroceryBloc, GroceryState>(
      bloc: groceryBloc,
      listenWhen: (previous, current) => current is GroceryActionState,
      buildWhen: (previous, current) => current is! GroceryActionState,
      listener: (context, state) {
        if (state is GroceryAddToCartButtonClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')));
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04),
            height: getScreenWidth(context) * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Price',
                      style: GoogleFonts.publicSans(
                        color: greyColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '₹ ${widget.grocery.price}',
                      style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: getScreenWidth(context) * 0.06),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.grocery.inStock > quantity) {
                      groceryBloc.add(GroceryProductPageAddToCardClickedEvent(
                        addToCartGrocery: widget.grocery,
                        quantity: quantity,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Item is out of stock!')));
                    }
                  },
                  child: const Button(
                    radius: 10,
                    text: 'Add to cart',
                    paddingH: 0.1,
                    paddingV: 0.045,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: getScreenWidth(context) * 0.05),
                Stack(
                  children: [
                    SizedBox(
                        width: getScreenWidth(context) * 1,
                        child: CachedNetworkImage(
                          imageUrl: widget.grocery.imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        )),
                    Positioned(
                      child: Row(
                        children: [
                          Container(
                            width: getScreenWidth(context),
                            height: getScreenWidth(context) * 0.15,
                            margin: EdgeInsets.symmetric(
                                vertical: getScreenWidth(context) * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTapDown: (_) {
                                    handleTap1();
                                  },
                                  onTapUp: (_) {
                                    Navigator.pop(context);
                                    handleTap1();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: getScreenWidth(context) * 0.08),
                                    padding: EdgeInsets.all(
                                        getScreenWidth(context) * 0.035),
                                    decoration: BoxDecoration(
                                        color: !isTouched1
                                            ? const Color(0xffFCF2E9)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_left.svg',
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTapDown: (_) {
                                    handleTap2();
                                  },
                                  onTapUp: (_) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CartPage()));
                                    handleTap2();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: getScreenWidth(context) * 0.08),
                                    padding: EdgeInsets.all(
                                        getScreenWidth(context) * 0.035),
                                    decoration: BoxDecoration(
                                        color: !isTouched2
                                            ? const Color(0xffFCF2E9)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SvgPicture.asset(
                                        'assets/icons/cart_icon.svg'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ProductHeadText(text: widget.grocery.name),
                ProductHeadText(text: widget.grocery.size!),
                SizedBox(height: getScreenWidth(context) * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: getScreenWidth(context) * 0.06),
                      child: Text(
                        'Description',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.publicSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: getScreenWidth(context) * 0.04),
                      ),
                    ),
                    // quantity selector
                    Row(
                      children: [
                        GestureDetector(
                          onTap: decreaseQuantity,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getScreenWidth(context) * 0.02),
                            padding:
                                EdgeInsets.all(getScreenWidth(context) * 0.035),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: quantity == 1 ? linerGrdBw : linerGrd,
                            ),
                            child: const Text(
                              '-',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: getScreenWidth(context) * 0.04),
                        ),
                        GestureDetector(
                          onTap: increaseQuantity,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                    horizontal: getScreenWidth(context) * 0.02)
                                .copyWith(
                                    right: getScreenWidth(context) * 0.06),
                            padding:
                                EdgeInsets.all(getScreenWidth(context) * 0.035),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: linerGrd,
                            ),
                            child: const Text(
                              '+',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: getScreenWidth(context) * 0.05),
                ProductBodyText(text: widget.grocery.description),
                SizedBox(height: getScreenWidth(context) * 0.05),
                if (widget.grocery.inStock > 10)
                  Container(
                    margin:
                        EdgeInsets.only(left: getScreenWidth(context) * 0.06),
                    width: getScreenWidth(context) * 0.65,
                    child: Text(
                      'In Stock',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.publicSans(
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                          fontSize: getScreenWidth(context) * 0.04),
                    ),
                  ),
                if (widget.grocery.inStock < 10 && widget.grocery.inStock > 0)
                  Container(
                    margin:
                        EdgeInsets.only(left: getScreenWidth(context) * 0.06),
                    width: getScreenWidth(context) * 0.65,
                    child: Text(
                      'Only Few Left!!',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.publicSans(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w800,
                          fontSize: getScreenWidth(context) * 0.04),
                    ),
                  ),
                if (widget.grocery.inStock == 0)
                  Container(
                    margin:
                        EdgeInsets.only(left: getScreenWidth(context) * 0.06),
                    width: getScreenWidth(context) * 0.65,
                    child: Text(
                      'Out of Stock !!',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.publicSans(
                          color: Colors.red,
                          fontWeight: FontWeight.w800,
                          fontSize: getScreenWidth(context) * 0.04),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
