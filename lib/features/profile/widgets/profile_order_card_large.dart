import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/ui/profile_page.dart';
import 'package:johar/features/profile/widgets/profile_product_order_card.dart';
import 'package:johar/shared/button.dart';

class ProfileOrderCardLarge extends StatefulWidget {
  final List orderIdList;
  final ProfileOrderLoadedSuccessState successState;
  final ProfileBloc bloc;
  final int indexU;

  const ProfileOrderCardLarge({
    super.key,
    required this.orderIdList,
    required this.successState,
    required this.bloc,
    required this.indexU,
  });

  @override
  State<ProfileOrderCardLarge> createState() => _ProfileOrderCardLargeState();
}

class _ProfileOrderCardLargeState extends State<ProfileOrderCardLarge> {
  bool isOrderAccepted = false;
  bool isOrderDelivered = false;
  bool isPaymentReceived = false;
  String amountOfOrder = '';
  String userMobile = '';
  String userName = '';
  String address = '';
  String pincode = '';
  String userId = '';

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  final ProfileBloc profileBloc = ProfileBloc();

  fetchDetails() async {
    final isAccepted =
        await ProfileRepo.isOrderAccepted(widget.orderIdList[widget.indexU]);
    final isDelivered =
        await ProfileRepo.isOrderDelivered(widget.orderIdList[widget.indexU]);
    final isPay =
        await ProfileRepo.isPaymentReceived(widget.orderIdList[widget.indexU]);
    final amount =
        await ProfileRepo.fetchAmountOfOrder(widget.orderIdList[widget.indexU]);
    final mobileNo = await ProfileRepo.orderedByMobileNumber(
        widget.orderIdList[widget.indexU]);
    final name = await ProfileRepo.orderedBy(widget.orderIdList[widget.indexU]);

    final addr =
        await ProfileRepo.fetchAddress(widget.orderIdList[widget.indexU]);
    final pin =
        await ProfileRepo.fetchPincode(widget.orderIdList[widget.indexU]);
    final id = await ProfileRepo.fetchUserid(widget.orderIdList[widget.indexU]);

    if (mounted) {
      setState(() {
        isOrderAccepted = isAccepted;
        isOrderDelivered = isDelivered;
        isPaymentReceived = isPay;
        amountOfOrder = amount;
        userMobile = mobileNo;
        userName = name;
        address = addr;
        pincode = pin;
        userId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is ProfilePageShowAcceptOrderDialog) {
          final deliveryTimeController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                height: getScreenWidth(context) * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Enter the expected delivery time',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: getScreenWidth(context) * 0.04,
                      ),
                    ),
                    DetailsTextField(
                        controller: deliveryTimeController,
                        label: 'by date, time'),
                    GestureDetector(
                      onTap: () => profileBloc.add(ConfirmOrderClickedEvent(
                        orderId: widget.orderIdList[widget.indexU],
                        userId: userId,
                        deliveryTime: deliveryTimeController.text,
                      )),
                      child: const Button(
                        radius: 15,
                        text: 'Confirm',
                        paddingH: 0.28,
                        paddingV: 0.032,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is OrderAcceptedSuccessState) {
          Navigator.pop(context);
          fetchDetails();
        } else if (state is ConfirmDeliveryDialogState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                height: getScreenWidth(context) * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Do you want to complete the delivery?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: getScreenWidth(context) * 0.04,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => profileBloc.add(DeliveryConfirmedEvent(
                          orderId: state.orderId, userId: state.userId)),
                      child: const Button(
                        radius: 15,
                        text: 'Confirm',
                        paddingH: 0.25,
                        paddingV: 0.032,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is DeliveryConfirmedState) {
          Navigator.pop(context);
          fetchDetails();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (!isOrderDelivered) {
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.successState.orders[widget.indexU].length,
                    itemBuilder: (context, index) {
                      return ProfileProductOrderCard(
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
                        '${widget.orderIdList[widget.indexU]}',
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
                            color:
                                isPaymentReceived ? Colors.green : Colors.red,
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
                        userName,
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
                      const SmallTextBody(text: 'Mobile Number'),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            userMobile,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getScreenWidth(context) * 0.03,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.04,
                    vertical: getScreenWidth(context) * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Address'),
                      Container(
                        alignment: Alignment.centerRight,
                        width: getScreenWidth(context) * 0.5,
                        child: Text(
                          address,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getScreenWidth(context) * 0.03,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getScreenWidth(context) * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Pincode'),
                      Text(
                        pincode,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getScreenWidth(context) * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (!isOrderAccepted)
                  GestureDetector(
                    onTap: () {
                      profileBloc.add(AcceptOrderClickedEvent(
                        orderId: widget.orderIdList[widget.indexU],
                        userId: userId,
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: getScreenWidth(context) * 0.03),
                      alignment: Alignment.center,
                      child: const Button(
                        radius: 15,
                        text: 'Accept Order',
                        paddingH: 0.3,
                        paddingV: 0.04,
                      ),
                    ),
                  ),
                if (isOrderAccepted)
                  GestureDetector(
                    onTap: () {
                      profileBloc.add(ShowConfirmDeliveryDialogEvent(
                        orderId: widget.orderIdList[widget.indexU],
                        userId: userId,
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: getScreenWidth(context) * 0.03),
                      alignment: Alignment.center,
                      child: const Button(
                        radius: 15,
                        text: 'Confirm Delivery',
                        paddingH: 0.28,
                        paddingV: 0.04,
                      ),
                    ),
                  )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
