import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/model/grocery_model.dart';

class OrderProductCard extends StatefulWidget {
  final OrderBloc orderBloc;
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
  final String size;
  final dynamic discountedPrice;

  const OrderProductCard({
    required this.orderBloc,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.productId,
    required this.inStock,
    required this.isFeatured,
    required this.description,
    required this.productDataModel,
    required this.size,
    required this.discountedPrice,
    required this.nos,
    required this.gst,
    super.key,
  });

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getScreenWidth(context) * 0.03,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: getScreenWidth(context) * 0.02),
            width: getScreenWidth(context) * 0.17,
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
                margin: EdgeInsets.only(
                    top: getScreenWidth(context) * 0.02,
                    left: getScreenWidth(context) * 0.04),
                child: Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.publicSans(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(
                  horizontal: getScreenWidth(context) * 0.04,
                  vertical: getScreenWidth(context) * 0.01,
                ),
                child: Text(
                  '₹ ${widget.discountedPrice} x ${widget.nos}',
                  style: GoogleFonts.publicSans(
                    color: Colors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: getScreenWidth(context) * 0.03,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
