import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/ui/cart_page.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
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
    bool isPackagingOptions = false;
    return BlocConsumer<GroceryBloc, GroceryState>(
      bloc: groceryBloc,
      listenWhen: (previous, current) => current is GroceryActionState,
      buildWhen: (previous, current) => current is! GroceryActionState,
      listener: (context, state) {
        if (state is GroceryAddToCartButtonClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')));
        } else if (state is ProductOptionChangedState) {}
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Price     ',
                          style: GoogleFonts.publicSans(
                            color: greyColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Save ₹${widget.grocery.price - widget.grocery.discountedPrice}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getScreenWidth(context) * 0.03,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹ ${widget.grocery.discountedPrice}  ',
                          style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: getScreenWidth(context) * 0.06),
                        ),
                        Text(
                          '₹ ${widget.grocery.price}',
                          style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: getScreenWidth(context) * 0.05,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
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

                // different size optionss
                // list view
                Visibility(
                  visible: isPackagingOptions,
                  child: Padding(
                    padding: EdgeInsets.all(getScreenWidth(context) * 0.06)
                        .copyWith(bottom: 0),
                    child: const SmallTextBody(
                      text: 'Packaging Options',
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('grocery')
                      .where('name', isEqualTo: widget.grocery.name)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final optionProducts = snapshot.data!.docs
                        .map((doc) => ProductDataModel.fromMap(
                            doc.data() as Map<String, dynamic>))
                        .toList();

                    if (optionProducts.length > 1) {
                      return SizedBox(
                        height: 0.6 * getScreenWidth(context),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: optionProducts.length,
                          itemBuilder: (context, index) {
                            final optionProduct = optionProducts[index];
                            final discount = optionProduct.price -
                                optionProduct.discountedPrice;

                            return GestureDetector(
                              onTap: () {
                                groceryBloc.add(GroceryCardClickedEvent(
                                    clickedGrocery: optionProduct));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GroceryProductPage(
                                              grocery: optionProduct,
                                            )));
                              },
                              child: Container(
                                width: getScreenWidth(context) * 0.3,
                                height: getScreenWidth(context) * 0.4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: getScreenWidth(context) * 0.04,
                                    vertical: getScreenWidth(context) * 0.073),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          getScreenWidth(context) * 0.02),
                                      width: getScreenWidth(context) * 0.3,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 216, 216, 216),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(13),
                                              topRight: Radius.circular(13))),
                                      child: Text(
                                        optionProduct.size.toString(),
                                        style: GoogleFonts.publicSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                          getScreenWidth(context) * 0.01),
                                      child: Text(
                                        '₹ ${optionProduct.discountedPrice}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getScreenWidth(context) * 0.04),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getScreenWidth(context) * 0.01),
                                      child: Row(
                                        children: [
                                          const Text('MRP '),
                                          Text(
                                            '₹ ${optionProduct.price}',
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                          getScreenWidth(context) * 0.01).copyWith(bottom: getScreenWidth(context) * 0.004),
                                      child: Text(
                                        'Save ₹$discount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getScreenWidth(context) * 0.03,
                                            color: Colors.green),
                                      ),
                                    ),
                                    // in stock or out of stock
                                    if (optionProduct.inStock > 10)
                                      Container(
                                        padding: EdgeInsets.all(
                                            getScreenWidth(context) * 0.02),
                                        child: const Text(
                                          'In Stock',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    if (optionProduct.inStock < 10 &&
                                        optionProduct.inStock > 0)
                                      Container(
                                        padding: EdgeInsets.all(
                                            getScreenWidth(context) * 0.02),
                                        child: const Text(
                                          'Only few left!!',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                    if (optionProduct.inStock == 0)
                                      Container(
                                        padding: EdgeInsets.all(
                                            getScreenWidth(context) * 0.02),
                                        child: const Text(
                                          'Out of stock',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),

                                    // Add to cart button
                                    GestureDetector(
                                      onTap: () => groceryBloc.add(
                                          GroceryProductPageAddToCardClickedEvent(
                                              addToCartGrocery: optionProduct,
                                              quantity: quantity)),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: getScreenWidth(context) *
                                                0.0163),
                                        alignment: Alignment.bottomCenter,
                                        width: getScreenWidth(context) * 0.3,
                                        decoration: const BoxDecoration(
                                            gradient: linerGrd,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(13),
                                                bottomRight:
                                                    Radius.circular(13))),
                                        child: Text(
                                          'Add to cart',
                                          style: GoogleFonts.publicSans(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: getScreenWidth(context) * 0.1),
              ],
            ),
          ),
        );
      },
    );
  }
}
