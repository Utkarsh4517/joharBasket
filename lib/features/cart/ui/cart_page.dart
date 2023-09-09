// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/features/cart/repo/cart_repo.dart';
import 'package:johar/features/cart/widgets/cart_card.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/shared/button.dart';
import 'package:lottie/lottie.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // razor pay instance

  // var _razorpay = Razorpay();

  final CartBloc cartBloc = CartBloc();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();

  bool? isDeliver;
  dynamic subTotal = 0;
  dynamic gst = 0;
  dynamic priceWithoutDiscount = 0;
  @override
  void initState() {
    cartBloc.add(CartInitialEvent());
    fetchSubtotalAndGST();
    fetchUserDetails();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Do something when payment succeeds
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Do something when payment fails
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet was selected
  // }

  fetchSubtotalAndGST() async {
    dynamic sub = await CartRepo.calculateSubTotal();
    dynamic gst1 = await CartRepo.calculateGst();
    dynamic prc = await CartRepo.calculateTotalWithoutDiscount();
    if (mounted) {
      setState(() {
        subTotal = sub;
        gst = gst1;
        priceWithoutDiscount = prc;
      });
    }
  }

  fetchUserDetails() async {
    String firstName = await CartRepo.getFirstUserName();
    String lastName = await CartRepo.getLastUserName();
    String mobile = await CartRepo.getUserMobile();
    String pincode = await CartRepo.getUserPin();
    String address = await CartRepo.getUserAddress();
    if (mounted) {
      setState(() {
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        mobileController.text = mobile;
        pincodeController.text = pincode;
        addressController.text = address;
      });
    }

    bool deliver =
        await CartRepo.doWeDeliverHere(pincodeController.text.toString());
    if (mounted) {
      setState(() {
        isDeliver = deliver;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    mobileController.dispose();
    // _razorpay.clear();
    super.dispose();
  }

  String radioValue = 'upi';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {
        if (state is CartBillRefreshState) {
          fetchSubtotalAndGST();
          fetchSubtotalAndGST();
          setState(() {
            subTotal = state.sum;
            priceWithoutDiscount = state.sumWithoutDiscount;
          });
        } else if (state is CartPlacingOrderLoadingState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    height: getScreenWidth(context) * 0.2,
                    width: getScreenWidth(context) * 0.2,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              });
        } else if (state is CartPagePlaceOrderSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order Placed Successfully')));
        } else if (state is CartEmptiedState) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        } else if (state is CartPageUserDetailsUpdatedSuccessState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User Details Updated!')));
          fetchUserDetails();
        } else if (state is BillRefreshEverySecondState) {
          fetchSubtotalAndGST();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case CartLoadingState:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case CartIsEmptyState:
            return Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                      child: Text(
                        'Your cart!',
                        style: GoogleFonts.publicSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: getScreenWidth(context) * 0.09),
                      ),
                    ),
                    SizedBox(height: getScreenheight(context) * 0.15),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Lottie.asset('assets/svgs/animation_cart1.json',
                          width: getScreenWidth(context) * 0.5),
                    ),
                  ],
                ),
              ),
            );

          case CartLoadedSuccessState:
            final successState = state as CartLoadedSuccessState;
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.all(getScreenWidth(context) * 0.06),
                          child: Text(
                            'Your cart!',
                            style: GoogleFonts.publicSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: getScreenWidth(context) * 0.09),
                          ),
                        ),
                        SizedBox(
                          height: (successState.products.length *
                                  0.3 *
                                  getScreenWidth(context))
                              .toDouble(),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: successState.products.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  cartBloc.add(CartRemoveProductEvent(
                                      product: successState.products[index]));
                                  setState(() {
                                    successState.products.removeAt(index);
                                  });
                                  cartBloc.add(CartBillRefreshEvent());
                                },
                                child: CartCard(
                                  size: successState.products[index].size!,
                                  discountedPrice: successState
                                      .products[index].discountedPrice,
                                  bloc: cartBloc,
                                  gst: successState.products[index].gst,
                                  name: successState.products[index].name,
                                  imageUrl:
                                      successState.products[index].imageUrl,
                                  price: successState.products[index].price,
                                  isFeatured:
                                      successState.products[index].isFeatured,
                                  inStock: successState.products[index].inStock,
                                  productId:
                                      successState.products[index].productId,
                                  productDataModel:
                                      successState.products[index],
                                  description:
                                      successState.products[index].description,
                                  nos: successState.products[index].nos,
                                ),
                              );
                            },
                          ),
                        ),

                        // Bill summary
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getScreenWidth(context) * 0.06),
                          child: Text(
                            'Bill summary',
                            style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: getScreenWidth(context) * 0.04,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(
                                  horizontal: getScreenWidth(context) * 0.08)
                              .copyWith(top: getScreenWidth(context) * 0.06),
                          child: Text(
                            'Get free delivery on order above ₹999',
                            style: GoogleFonts.publicSans(
                              color: greyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: getScreenWidth(context) * 0.03,
                            ),
                          ),
                        ),

                        Container(
                          margin:
                              EdgeInsets.all(getScreenWidth(context) * 0.06),
                          padding:
                              EdgeInsets.all(getScreenWidth(context) * 0.04),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(text: 'Total'),
                                  SmallTextBody(
                                      text: '₹ $priceWithoutDiscount'),
                                ],
                              ),

                              // discount

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(
                                    text: 'Total Savings',
                                    color: Colors.green,
                                  ),
                                  SmallTextBody(
                                    text:
                                        '₹ ${priceWithoutDiscount - subTotal}',
                                    color: Colors.green,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(text: 'Sub total'),
                                  SmallTextBody(text: '₹ $subTotal'),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     const SmallTextBody(text: 'GST (included)'),
                              //     SmallTextBody(text: '₹ $gst'),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(text: 'Delivery charges'),
                                  SmallTextBody(
                                      text: subTotal < 999 ? '₹ 49' : '₹ 0'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(text: 'Grand Total'),
                                  SmallTextBody(
                                      text:
                                          '₹ ${subTotal + (subTotal < 999 ? 49 : 0)}'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Delivery Details
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getScreenWidth(context) * 0.06),
                          child: Text(
                            'Delivery Details',
                            style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: getScreenWidth(context) * 0.04,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin:
                              EdgeInsets.all(getScreenWidth(context) * 0.06),
                          padding:
                              EdgeInsets.all(getScreenWidth(context) * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SmallTextBody(text: 'Deliver For'),
                              DetailsTextField(
                                  controller: firstNameController,
                                  label: 'First name',
                                  hMargin: 0,
                                  vMargin: 0.02),
                              DetailsTextField(
                                  controller: lastNameController,
                                  label: 'Last name',
                                  hMargin: 0,
                                  vMargin: 0.02),
                              const SmallTextBody(text: 'Contact'),
                              DetailsTextField(
                                  controller: mobileController,
                                  label: 'Contact number',
                                  hMargin: 0,
                                  vMargin: 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SmallTextBody(text: 'Pincode'),
                                  if (isDeliver != null && isDeliver == true)
                                    Text(
                                      'We deliver at this location',
                                      style: GoogleFonts.publicSans(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            getScreenWidth(context) * 0.03,
                                      ),
                                    ),
                                  if (isDeliver != null && isDeliver == false)
                                    Text(
                                      'Sorry! We do not deliver to this location yet',
                                      style: GoogleFonts.publicSans(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            getScreenWidth(context) * 0.025,
                                      ),
                                    ),
                                ],
                              ),
                              DetailsTextField(
                                  controller: pincodeController,
                                  label: 'Pincode',
                                  hMargin: 0,
                                  vMargin: 0.02),
                              const SmallTextBody(text: 'Delivery Address'),
                              DetailsTextField(
                                  controller: addressController,
                                  label: 'Address',
                                  hMargin: 0,
                                  vMargin: 0.02),
                            ],
                          ),
                        ),
                        //update details button
                        GestureDetector(
                          onTap: () => cartBloc.add(
                            CartPageUpdateDetailsClickedEvent(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              mobileNumber: mobileController.text,
                              pincode: pincodeController.text,
                              address: addressController.text,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Button(
                              radius: 10,
                              text: 'Update Details',
                              paddingH: 0.3,
                              paddingV: 0.035,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                                  horizontal: getScreenWidth(context) * 0.06)
                              .copyWith(
                            top: getScreenWidth(context) * 0.05,
                          ),
                          child: Text(
                            'Payment Details',
                            style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: getScreenWidth(context) * 0.04,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          margin:
                              EdgeInsets.all(getScreenWidth(context) * 0.06),
                          padding:
                              EdgeInsets.all(getScreenWidth(context) * 0.02),
                          child: Column(
                            children: [
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Colors.green,
                                value: 'upi',
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value.toString();
                                  });
                                },
                                title:
                                    const SmallTextBody(text: 'Pay Using UPI'),
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Colors.green,
                                value: 'cod',
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value.toString();
                                  });
                                },
                                title: const SmallTextBody(
                                    text: 'Cash on delivery'),
                              )
                            ],
                          ),
                        ),
                        if (isDeliver != null && isDeliver == false)
                          Container(
                              alignment: Alignment.center,
                              child: const Button(
                                  radius: 10,
                                  text: 'Please change the delivery location',
                                  grd: linerGrdR))

                        // Place Order
                        else if (isDeliver != null && isDeliver == true)
                          GestureDetector(
                            onTap: () {
                              if (radioValue == 'cod') {
                                cartBloc.add(
                                  CartPagePlaceOrderClickedEvent(
                                    products: successState.products,
                                    gst: '$gst',
                                    amount:
                                        '${subTotal + (subTotal < 999 ? 49 : 0)}',
                                  ),
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: const Button(
                                radius: 10,
                                text: 'Place your order',
                                grd: linerGrd,
                                paddingH: 0.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ));

          default:
            return Container();
        }
      },
    );
  }
}
