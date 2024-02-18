import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/bill/service/bill_service.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/ui/profile_page.dart';
import 'package:johar/features/profile/widgets/profile_product_order_card.dart';
import 'package:johar/shared/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String otp = '';
  final otpController = TextEditingController();

  final billService = BillService();

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  final ProfileBloc profileBloc = ProfileBloc();

  fetchDetails() async {
    final isAccepted = await ProfileRepo.isOrderAccepted(widget.orderIdList[widget.indexU]);
    final isDelivered = await ProfileRepo.isOrderDelivered(widget.orderIdList[widget.indexU]);
    final isPay = await ProfileRepo.isPaymentReceived(widget.orderIdList[widget.indexU]);
    final amount = await ProfileRepo.fetchAmountOfOrder(widget.orderIdList[widget.indexU]);
    final mobileNo = await ProfileRepo.orderedByMobileNumber(widget.orderIdList[widget.indexU]);
    final name = await ProfileRepo.orderedBy(widget.orderIdList[widget.indexU]);

    final addr = await ProfileRepo.fetchAddress(widget.orderIdList[widget.indexU]);
    final pin = await ProfileRepo.fetchPincode(widget.orderIdList[widget.indexU]);
    final id = await ProfileRepo.fetchUserid(widget.orderIdList[widget.indexU]);
    final otpGen = await OrderRepo.fetchOTP(widget.orderIdList[widget.indexU], id);

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
        otp = otpGen;
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(74, 81, 248, 1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(74, 81, 248, 1), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 6, DateTime.now().day),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
          _selectDate(context).then((_) {
            profileBloc.add(ConfirmOrderClickedEvent(
              orderId: widget.orderIdList[widget.indexU],
              userId: userId,
              deliveryTime: DateFormat('dd MMM').format(_selectedDate!),
            ));
          });

          // showDialog(
          //   context: context,
          //   builder: (context) => Dialog(
          //     child: SizedBox(
          //       height: getScreenWidth(context) * 0.75,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Text(
          //             'Enter the expected delivery time',
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: getScreenWidth(context) * 0.04,
          //             ),
          //           ),
          //           DetailsTextField(controller: deliveryTimeController, label: 'by date, time'),
          //           GestureDetector(
          //             onTap: () => profileBloc.add(ConfirmOrderClickedEvent(
          //               orderId: widget.orderIdList[widget.indexU],
          //               userId: userId,
          //               deliveryTime: deliveryTimeController.text,
          //             )),
          //             child: const Button(
          //               radius: 15,
          //               text: 'Confirm',
          //               paddingH: 0.28,
          //               paddingV: 0.032,
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        } else if (state is OrderAcceptedSuccessState) {
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: "Order Accepted",
            ),
          );
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
                    DetailsTextField(
                      controller: otpController,
                      label: 'Enter OTP',
                      keyboardType: TextInputType.number,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (otpController.text == otp) {
                          profileBloc.add(DeliveryConfirmedEvent(orderId: state.orderId, userId: state.userId));
                          print('state user id is ${state.userId}');
                          print('state orderId is ${state.orderId}');
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.success(
                              message: "Delivery Confirmed",
                            ),
                          );
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.error(
                              message: "Please enter the correct OTP",
                            ),
                          );
                        }
                      },
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
        } else if (state is ProfilePageShowCancelOrderDialogBoxState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Do you want to cancel this order?'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: GoogleFonts.publicSans(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          profileBloc.add(ConfirmCancelOrderEvent(orderId: state.orderId, userId: userId));
                          // orderBloc.add(
                          //     ConfirmCancelOrderEvent(orderId: state.orderId));
                        },
                        child: Text(
                          'Cancel Order',
                          style: GoogleFonts.publicSans(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        } else if (state is ProfilePageOrderCancelSuccessfulState) {
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06, vertical: getScreenWidth(context) * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget.successState.orders[widget.indexU].length * 0.3 * getScreenWidth(context),
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
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Order ID'),
                      SelectableText(
                        '${widget.orderIdList[widget.indexU]}',
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
                        '₹ $amountOfOrder',
                        style: TextStyle(color: isPaymentReceived ? Colors.green : Colors.red, fontSize: getScreenWidth(context) * 0.04, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Ordered by'),
                      SelectableText(
                        userName,
                        style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.03, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Mobile Number'),
                      TextButton(
                          onPressed: () {
                            Uri phoneno = Uri.parse('tel:$userMobile');
                            launchUrl(phoneno);
                          },
                          child: Text(
                            userMobile,
                            style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.03, fontWeight: FontWeight.bold),
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
                          style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.03, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmallTextBody(text: 'Pincode'),
                      Text(
                        pincode,
                        style: TextStyle(color: Colors.black, fontSize: getScreenWidth(context) * 0.03, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (isOrderAccepted)
                  Container(
                    margin: EdgeInsets.only(left: getScreenWidth(context) * 0.02),
                    child: TextButton(
                      onPressed: () async {
                        final data = await billService.generatePdfAdminPanel(
                          orderIdList: widget.orderIdList,
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
                if (!isOrderAccepted)
                  GestureDetector(
                    onTap: () {
                      profileBloc.add(AcceptOrderClickedEvent(
                        orderId: widget.orderIdList[widget.indexU],
                        userId: userId,
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.03),
                      alignment: Alignment.center,
                      child: const Button(
                        radius: 15,
                        text: 'Accept Order',
                        paddingH: 0.3,
                        paddingV: 0.04,
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    profileBloc.add(CancelOrderClickedEvent(
                      orderId: widget.orderIdList[widget.indexU],
                      userId: userId,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.03),
                    alignment: Alignment.center,
                    child: const Button(
                      grd: linerGrdR,
                      radius: 15,
                      text: 'Cancel Order',
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
                      print('user id is $userId');
                      print(widget.orderIdList[widget.indexU]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.03),
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
