import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:shimmer/shimmer.dart';

class GroceryCardSmall extends StatefulWidget {
  final GroceryBloc bloc;
  final String productId;
  final dynamic nos;
  final dynamic inStock;
  final String imageUrl;
  final String name;
  final bool isFeatured;
  final dynamic price;
  final ProductDataModel groceryUiDataModel;
  final String description;
  final dynamic gst;
  final String size;
  final dynamic discountedPrice;

  const GroceryCardSmall({
    required this.gst,
    required this.bloc,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.productId,
    required this.inStock,
    required this.isFeatured,
    required this.description,
    required this.groceryUiDataModel,
    required this.size,
    required this.discountedPrice,
    this.nos,
    super.key,
  });

  @override
  State<GroceryCardSmall> createState() => _GroceryCardSmallState();
}

class _GroceryCardSmallState extends State<GroceryCardSmall> {
  bool isCartButtonTapped = false;
  @override
  Widget build(BuildContext context) {
    dynamic discountPercentage = (((widget.price - widget.discountedPrice) / widget.price) * 100);
    discountPercentage = discountPercentage.round();
    void clicked() {
      widget.bloc.add(GroceryCardClickedEvent(clickedGrocery: widget.groceryUiDataModel));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroceryProductPage(
                    grocery: widget.groceryUiDataModel,
                  )));
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(getScreenWidth(context) * 0.04),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 187, 187, 187).withOpacity(1),
              offset: Offset(0, 18),
              blurRadius: 10,
              spreadRadius: 3,
            )
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: clicked,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: getScreenWidth(context) * 0.2,
                      height: 140,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Container(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getScreenheight(context) * 0.01),
              GestureDetector(
                onTap: clicked,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                      ),
                      Text(
                        widget.size,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                      ),
                      SizedBox(height: getScreenWidth(context) * 0.01),
                      Text(
                        '₹ ${widget.price}',
                        style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '₹ ${widget.discountedPrice}',
                        style: GoogleFonts.publicSans(color: const Color(0xff57C373), fontWeight: FontWeight.w900, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                alignment: Alignment.bottomCenter,
                child: MUISecondaryOutlinedButton(
                    hapticsEnabled: true,
                    bgColor:Colors.orange,
                    textColor: Colors.white,
                    
                    // tappedBgColor: Colors.green.shade800,
                    borderColor: blackColor,
                    
                    animationDuration: 100,
                    text: 'Add to cart',
                    onPressed: () {
                      widget.bloc.add(GroceryCardCartButtonClickedEvent(cartClickedGrocery: widget.groceryUiDataModel));
                    }),
              )
            ],
          ),
        ),
        if (discountPercentage != 0)
          Positioned(
            left: getScreenWidth(context) * 0.04,
            top: getScreenheight(context) * 0.02,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(0),
                  bottom: Radius.circular(12),
                ).copyWith(topLeft: Radius.circular(10)),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                ' $discountPercentage%\nOFF',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      ],
    );
  }
}
