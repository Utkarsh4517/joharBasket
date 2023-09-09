import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';

class GroceryCardSmall extends StatelessWidget {
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
  Widget build(BuildContext context) {
    void clicked() {
      bloc.add(GroceryCardClickedEvent(clickedGrocery: groceryUiDataModel));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroceryProductPage(
                    grocery: groceryUiDataModel,
                  )));
    }

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.05,
          vertical: getScreenWidth(context) * 0.01),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          // width: getScreenWidth(context) * 0.2,
          //  height: getScreenWidth(context) * 0.62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      clicked();
                    },
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: getScreenWidth(context) * 0.18,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      clicked();
                    },
                    child: Container(
                      width: getScreenWidth(context) * 0.2,
                      margin: EdgeInsets.symmetric(
                          horizontal: getScreenWidth(context) * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.publicSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: getScreenWidth(context) * 0.025),
                          ),
                          Text(
                            size,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.publicSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: getScreenWidth(context) * 0.028),
                          ),
                          SizedBox(height: getScreenWidth(context) * 0.02),
                          Text(
                            '₹ $discountedPrice',
                            style: GoogleFonts.publicSans(
                                color: const Color(0xff57C373),
                                fontWeight: FontWeight.w900,
                                fontSize: getScreenWidth(context) * 0.037),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => bloc.add(GroceryCardCartButtonClickedEvent(
                        cartClickedGrocery: groceryUiDataModel)),
                    child: Container(
                      width: getScreenWidth(context) * 0.1,
                      height: getScreenWidth(context) * 0.1,
                      decoration: const BoxDecoration(
                        color: Color(0xffFF8615),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
