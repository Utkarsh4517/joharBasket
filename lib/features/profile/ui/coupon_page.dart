import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/coupon_model.dart';
import 'package:modular_ui/modular_ui.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  String coupon_type = 'flat off on order above';
  final couponController = TextEditingController();
  final flatOffController = TextEditingController();
  final onOrderAboveController = TextEditingController();
  final discountController = TextEditingController();
  final uptoController = TextEditingController();
  final ProfileBloc profileBloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    Stream<List<CouponModel>> couponStream = ProfileRepo.getCoupons();
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is CouponAddedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 15),
            child: FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Select Coupon type :'),
                                Container(
                                  width: double.infinity,
                                  child: DropdownButton<String>(
                                      value: coupon_type,
                                      items: <String>['flat off on order above', '% discount upto'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          coupon_type = value!;
                                        });
                                      }),
                                ),
                                MUIPrimaryInputField(
                                  hintText: 'Coupon code',
                                  controller: couponController,
                                  filledColor: Colors.white,
                                ),
                                if (coupon_type == 'flat off on order above') MUIPrimaryInputField(hintText: 'Flat off', controller: flatOffController, filledColor: Colors.white),
                                if (coupon_type == 'flat off on order above') MUIPrimaryInputField(hintText: 'On order above', controller: onOrderAboveController, filledColor: Colors.white),
                                if (coupon_type == '% discount upto') MUIPrimaryInputField(hintText: 'Discount in percentage', controller: discountController, filledColor: Colors.white),
                                if (coupon_type == '% discount upto') MUIPrimaryInputField(hintText: 'Upto', controller: uptoController, filledColor: Colors.white),
                                SizedBox(height: getScreenheight(context) * 0.05),
                                Center(
                                  child: MUISecondaryButton(
                                      text: 'Create Coupon',
                                      onPressed: () {
                                        if (coupon_type == 'flat off on order above') {
                                          profileBloc.add(AddCouponClickedEvent(
                                              type: coupon_type,
                                              couponCode: couponController.text,
                                              flatOff: double.parse(flatOffController.text),
                                              onOrderAbove: double.parse(onOrderAboveController.text),
                                              discount: 0,
                                              upto: 0));
                                        } else if (coupon_type == '% discount upto') {
                                          profileBloc.add(AddCouponClickedEvent(
                                            type: coupon_type,
                                            couponCode: couponController.text,
                                            flatOff: 0,
                                            onOrderAbove: 0,
                                            discount: double.parse(discountController.text),
                                            upto: double.parse(uptoController.text),
                                          ));
                                        }
                                      }),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    });
              },
              label: Text(
                'Create a coupon',
              ),
            ),
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
                            decoration: BoxDecoration(color: Colors.cyan.shade200, borderRadius: BorderRadius.circular(15)),
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
                                    Text('Coupon Code: ${coupon.couponCode}'),
                                    if (coupon.type == 'flat off on order above') Text('Flat off: ${coupon.flatOff} on order above ${coupon.onOrderAbove}'),
                                    if (coupon.type == '% discount upto') Text('Discount: ${coupon.discount}% on order upto ${coupon.upto}'),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      profileBloc.add(CouponDeleteClickedEvent(couponModel: coupon));
                                    },
                                    icon: Icon(Icons.delete))
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
