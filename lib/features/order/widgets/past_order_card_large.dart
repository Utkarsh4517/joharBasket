import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/features/order/widgets/my_timeline.dart';

import 'package:johar/features/order/widgets/past_order_product_card.dart';
import 'package:modular_ui/modular_ui.dart';

class PastOrderCardLarge extends StatefulWidget {
  final List orderIdlist;
  final PastOrderLoadedSuccessState successState;
  final OrderBloc bloc;
  final int indexU;
  const PastOrderCardLarge({
    super.key,
    required this.bloc,
    required this.indexU,
    required this.orderIdlist,
    required this.successState,
  });

  @override
  State<PastOrderCardLarge> createState() => _PastOrderCardLargeState();
}

class _PastOrderCardLargeState extends State<PastOrderCardLarge> {
  String deliverdOn = '';
  String amount = '';
  // fetch product details
  fetchDetails() async {
    final delTime = await OrderRepo.fetchDeliveredOnTime(widget.orderIdlist[widget.indexU], FirebaseAuth.instance.currentUser!.uid);
    final formattedDate = DateFormat('dd MMMM yyyy').format(delTime);
    final amt = await OrderRepo.fetchPastOrderAmount(widget.orderIdlist[widget.indexU], FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      deliverdOn = formattedDate;
      amount = amt;
    });
  }

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06, vertical: getScreenWidth(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.successState.orders[widget.indexU].length * 0.3 * getScreenWidth(context),
            child: ListView.builder(
              itemCount: widget.successState.orders[widget.indexU].length,
              itemBuilder: (context, index) {
                return PastOrderProductCard(
                  successState: widget.successState,
                  indexU: widget.indexU,
                  index: index,
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Order ID'),
                SelectableText(
                  '${widget.orderIdlist[widget.indexU]}',
                  style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.025),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Total amount'),
                SelectableText(
                  '₹ $amount',
                  style: TextStyle(color: Colors.green, fontSize: getScreenWidth(context) * 0.04, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmallTextBody(text: 'Delivered on'),
                SelectableText(
                  deliverdOn.toString(),
                  style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.025, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: getScreenWidth(context) * 0.85),
            margin: EdgeInsets.only(top: getScreenWidth(context) * 0.1),
            alignment: Alignment.center,
            height: getScreenWidth(context) * 0.15,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTimeLine(isFirst: true, isLast: false, isPast: true, text: 'Ordered'),
                MyTimeLine(isFirst: false, isLast: false, isPast: true, text: 'Order Accepted'),
                MyTimeLine(
                  isFirst: false,
                  isLast: true,
                  isPast: true,
                  text: 'Delivered',
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                height: getScreenheight(context) * 0.1,
                child: MUISecondaryButton(
                  text: 'Return order',
                  onPressed: () {},
                  bgColor: Colors.grey.shade200,
                  textColor: Colors.red,
                  tappedBgColor: Colors.grey.shade300,
                  // borderColor: Colors.grey.shade200,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
