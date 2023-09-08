import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';

class ProfileStatsPageDeliveredOrderCard extends StatefulWidget {
  final StatsPageOrderDeliveredSuccessState successState;
  final int indexU;
  final int index;
  const ProfileStatsPageDeliveredOrderCard({
    super.key,
    required this.successState,
    required this.indexU,
    required this.index,
  });

  @override
  State<ProfileStatsPageDeliveredOrderCard> createState() =>
      _ProfileStatsPageDeliveredOrderCardState();
}

class _ProfileStatsPageDeliveredOrderCardState
    extends State<ProfileStatsPageDeliveredOrderCard> {
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
              imageUrl: widget
                  .successState.orders[widget.indexU][widget.index].imageUrl,
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
                  widget.successState.orders[widget.indexU][widget.index].name,
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
                  '₹ ${widget.successState.orders[widget.indexU][widget.index].price} x ${widget.successState.orders[widget.indexU][widget.index].nos}',
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
