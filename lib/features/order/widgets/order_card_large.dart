import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/bill/repo/bill_repo.dart';
import 'package:johar/features/bill/service/bill_service.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/features/order/widgets/my_timeline.dart';
import 'package:johar/features/order/widgets/order_product_card.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCardLarge extends StatefulWidget {
  const OrderCardLarge({
    super.key,
    required this.orderIdList,
    required this.successState,
    required this.bloc,
    required this.indexU,
  });

  final List orderIdList;
  final OrderLoadedSuccessState successState;
  final OrderBloc bloc;
  final int indexU;

  @override
  State<OrderCardLarge> createState() => _OrderCardLargeState();
}

class _OrderCardLargeState extends State<OrderCardLarge> {
  bool isOrderAccepted = false;
  bool isOrderDelivered = false;
  bool isPaymentReceived = false;
  String amountOfOrder = '';
  String deliveryTime = '';
  String otp = '';
  String invoice = '';

  final billService = BillService();

  @override
  void initState() {
    fetchCurrentDetails();
    super.initState();
  }

  // check for booleans
  fetchCurrentDetails() async {
    final isAccepted = await OrderRepo.isOrderAccepted(widget.orderIdList[widget.indexU]);
    final isDelivered = await OrderRepo.isOrderDelivered(widget.orderIdList[widget.indexU]);
    final isPay = await OrderRepo.isPaymentReceived(widget.orderIdList[widget.indexU]);
    final amount = await OrderRepo.fetchAmountOfOrder(widget.orderIdList[widget.indexU]);
    final time = await OrderRepo.fetchDeliveryTime(widget.orderIdList[widget.indexU]);
    final otpGen = await OrderRepo.fetchOTP(
      widget.orderIdList[widget.indexU],
      FirebaseAuth.instance.currentUser!.uid,
    );
    final invoiceNo = await BillRepo.getInvoiceNo();

    if (mounted) {
      setState(() {
        isOrderAccepted = isAccepted;
        isOrderDelivered = isDelivered;
        isPaymentReceived = isPay;
        amountOfOrder = amount;
        deliveryTime = time;
        otp = otpGen;
        invoice = invoiceNo.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOrderDelivered) {
      return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06, vertical: getScreenWidth(context) * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ordered products list
            SizedBox(
              height: (widget.successState.orders[widget.indexU].length * 0.3 * getScreenWidth(context)).toDouble(),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.successState.orders[widget.indexU].length,
                itemBuilder: (context, index) {
                  return OrderProductCard(
                    size: widget.successState.orders[widget.indexU][index].size!,
                    discountedPrice: widget.successState.orders[widget.indexU][index].discountedPrice,
                    orderBloc: widget.bloc,
                    gst: widget.successState.orders[widget.indexU][index].gst,
                    name: widget.successState.orders[widget.indexU][index].name,
                    imageUrl: widget.successState.orders[widget.indexU][index].imageUrl,
                    price: widget.successState.orders[widget.indexU][index].price,
                    isFeatured: widget.successState.orders[widget.indexU][index].isFeatured,
                    inStock: widget.successState.orders[widget.indexU][index].inStock,
                    productId: widget.successState.orders[widget.indexU][index].productId,
                    productDataModel: widget.successState.orders[widget.indexU][index],
                    description: widget.successState.orders[widget.indexU][index].description,
                    nos: widget.successState.orders[widget.indexU][index].nos,
                  );
                },
              ),
            ),
            // end of ordered prodcuts

            // give order Details here..
            Container(
              margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SmallTextBody(text: 'Order ID'),
                  SelectableText(
                    '${widget.orderIdList[widget.indexU]}',
                    style: TextStyle(color: Colors.black, fontSize: 8),
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
                    '₹ $amountOfOrder',
                    style: TextStyle(color: isPaymentReceived ? Colors.green : Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            if (!isOrderDelivered && isOrderAccepted)
              Container(
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SmallTextBody(text: 'OTP'),
                    SelectableText(
                      otp,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

            if (!isOrderDelivered && isOrderAccepted)
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Expected delivery time',
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      deliveryTime,
                      style: TextStyle(fontSize: 8),
                    )
                  ],
                ),
              ),

            if (isOrderDelivered)
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                child: Text(
                  'Your Order has been deliverd!',
                  style: GoogleFonts.publicSans(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 10),
                ),
              ),

            if (isOrderAccepted)
              Container(
                margin: EdgeInsets.only(left: getScreenWidth(context) * 0.02),
                child: TextButton(
                  onPressed: () async {
                    final data = await billService.generatePdfCustomer(
                      orderIdList: widget.orderIdList,
                      bloc: widget.bloc,
                      indexU: widget.indexU,
                      successState: widget.successState,
                      total: amountOfOrder,
                    );
                    billService.savePdfFile(filename: 'johar_bill', byteList: data);
                  },
                  child: Text(
                    'View receipt',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),

            Container(
              constraints: BoxConstraints(maxWidth: getScreenWidth(context) * 0.85),
              margin: EdgeInsets.only(top: getScreenWidth(context) * 0.1),
              alignment: Alignment.center,
              height: getScreenWidth(context) * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyTimeLine(isFirst: true, isLast: false, isPast: true, text: 'Ordered'),
                  MyTimeLine(isFirst: false, isLast: false, isPast: isOrderAccepted, text: 'Order Accepted'),
                  MyTimeLine(
                    isFirst: false,
                    isLast: true,
                    isPast: isOrderDelivered,
                    text: 'Delivered',
                  )
                ],
              ),
            ),
            // cancel order and Call us
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Uri phoneno = Uri.parse('tel:8226830570');
                    launchUrl(phoneno);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.call, color: Colors.green),
                        SizedBox(width: getScreenWidth(context) * 0.03),
                        Text(
                          'Call us',
                          style: GoogleFonts.publicSans(color: Colors.green, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.04),
                        )
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.bloc.add(CancelOrderEvent(orderId: widget.orderIdList[widget.indexU]));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: getScreenWidth(context) * 0.03),
                        Text(
                          'Cancel Order',
                          style: GoogleFonts.publicSans(color: Colors.red, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.04),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
