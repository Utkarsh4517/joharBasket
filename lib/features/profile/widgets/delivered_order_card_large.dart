import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/order/widgets/my_timeline.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/widgets/delivered_product_order_card.dart';

class ProfileDeliveredOrderCardLarge extends StatefulWidget {
  final List orderIdlist;
  final StatsPageOrderDeliveredSuccessState successState;
  final ProfileBloc bloc;
  final int indexU;
  const ProfileDeliveredOrderCardLarge({
    super.key,
    required this.orderIdlist,
    required this.successState,
    required this.bloc,
    required this.indexU,
  });

  @override
  State<ProfileDeliveredOrderCardLarge> createState() =>
      _ProfileDeliveredOrderCardLargeState();
}

class _ProfileDeliveredOrderCardLargeState
    extends State<ProfileDeliveredOrderCardLarge> {
  String amountOfOrder = '';
  String orderedBy = '';
  String deliveredOn = '';

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  // fetch details
  fetchDetails() async {
    final amount = await ProfileRepo.fetchOrderAmountDelivered(
        widget.orderIdlist[widget.indexU]);
    final name = await ProfileRepo.fetchUsernameDelivered(
        widget.orderIdlist[widget.indexU]);
    final delTime = await ProfileRepo.fetchDeliveredOnTime(
        widget.orderIdlist[widget.indexU]);
    final formattedDate = DateFormat('dd MMMM yyyy').format(delTime);
    if (mounted) {
      setState(() {
        deliveredOn = formattedDate;
        orderedBy = name;
        amountOfOrder = amount;
      });
    }
  }

  final ProfileBloc profileBloc = ProfileBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.06,
          vertical: getScreenWidth(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.successState.orders[widget.indexU].length *
                0.3 *
                getScreenWidth(context),
            child: ListView.builder(
              itemCount: widget.successState.orders[widget.indexU].length,
              itemBuilder: (context, index) {
                return ProfileStatsPageDeliveredOrderCard(
                  successState: widget.successState,
                  indexU: widget.indexU,
                  index: index,
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Order ID'),
                SelectableText(
                  '${widget.orderIdlist[widget.indexU]}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getScreenWidth(context) * 0.025),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Total amount'),
                SelectableText(
                  '₹ $amountOfOrder',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: getScreenWidth(context) * 0.04,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Ordered by'),
                SelectableText(
                  orderedBy,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getScreenWidth(context) * 0.03,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
           Container(
            margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Delivered On'),
                SelectableText(
                  deliveredOn,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getScreenWidth(context) * 0.03,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: getScreenWidth(context) * 0.1),
            alignment: Alignment.center,
            height: getScreenWidth(context) * 0.15,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTimeLine(
                    isFirst: true,
                    isLast: false,
                    isPast: true,
                    text: 'Ordered'),
                MyTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    text: 'Order Accepted'),
                MyTimeLine(
                  isFirst: false,
                  isLast: true,
                  isPast: true,
                  text: 'Delivered',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
