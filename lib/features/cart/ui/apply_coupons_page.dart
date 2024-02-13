import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/coupon_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ApplyCouponsPage extends StatefulWidget {
  final CartBloc cartBloc;
  const ApplyCouponsPage({
    super.key,
    required this.cartBloc,
  });

  @override
  State<ApplyCouponsPage> createState() => _ApplyCouponsPageState();
}

class _ApplyCouponsPageState extends State<ApplyCouponsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<List<CouponModel>> couponStream = ProfileRepo.getCoupons();
    return BlocConsumer<CartBloc, CartState>(
      bloc: widget.cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Coupons for you'),
            centerTitle: true,
          ),
          body: Center(
              child: SizedBox(
            height: getScreenheight(context) * 0.8,
            child: StreamBuilder(
                stream: couponStream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    List<CouponModel> coupons = snapshot.data!;
                    print(coupons.length);
                    return ListView.builder(
                        itemCount: coupons.length,
                        itemBuilder: (context, index) {
                          CouponModel coupon = coupons[index];
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05).copyWith(
                              bottom: 5,
                            ),
                            padding: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.04, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${coupon.couponCode}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (coupon.type == 'flat off on order above') Text('Get Flat off: ₹${coupon.flatOff} on order above ₹${coupon.onOrderAbove}'),
                                    if (coupon.type == '% discount upto') Text('Discount: ${coupon.discount}% on order upto ₹${coupon.upto}'),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      widget.cartBloc.add(CouponCodeApplyClickedEvent(couponCode: '${coupon.couponCode}'));
                                      Navigator.pop(context);
                                    },
                                    child: Text('Apply'))
                              ],
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {}
                  return Container();
                }),
          )),
        );
      },
    );
  }
}
