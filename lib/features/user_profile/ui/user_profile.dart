import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/features/cart/repo/cart_repo.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/shared/button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final houseNoController = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  bool? isDeliver;
  final CartBloc cartBloc = CartBloc();
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  fetchUserDetails() async {
    String firstName = await CartRepo.getFirstUserName();
    String lastName = await CartRepo.getLastUserName();
    String mobile = await CartRepo.getUserMobile();
    String pincode = await CartRepo.getUserPin();
    String address = await CartRepo.getUserAddress();
    String house = await CartRepo.getUserHouseNo();
    String landmark = await CartRepo.getUserLandmark();
    String city = await CartRepo.getUserCity();
    if (mounted) {
      setState(() {
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        mobileController.text = mobile;
        pincodeController.text = pincode;
        areaController.text = address;
        houseNoController.text = house;
        landmarkController.text = landmark;
        cityController.text = city;
      });
    }

    bool deliver = await CartRepo.doWeDeliverHere(pincodeController.text.toString());
    if (mounted) {
      setState(() {
        isDeliver = deliver;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06),
                  child: Text(
                    'User Details',
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
                  margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                  padding: EdgeInsets.all(getScreenWidth(context) * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailsTextField(controller: firstNameController, label: 'First name', hMargin: 0, vMargin: 0.02),
                      DetailsTextField(controller: lastNameController, label: 'Last name', hMargin: 0, vMargin: 0.02),
                      const SmallTextBody(text: 'Contact'),
                      DetailsTextField(controller: mobileController, label: 'Contact number', hMargin: 0, vMargin: 0.02),
                      //update user details button
                      GestureDetector(
                        onTap: () {
                          cartBloc.add(
                            CartPageUpdateUserDetailsClickedEvent(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              mobileNumber: mobileController.text,
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Button(
                            radius: 10,
                            text: 'Update Details',
                            paddingH: 0.25,
                            paddingV: 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                  padding: EdgeInsets.all(getScreenWidth(context) * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallTextBody(text: 'Pincode'),
                          if (isDeliver != null && isDeliver == true)
                            Text(
                              'We deliver at this location',
                              style: GoogleFonts.publicSans(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: getScreenWidth(context) * 0.03,
                              ),
                            ),
                          if (isDeliver != null && isDeliver == false)
                            Text(
                              'Sorry! We do not deliver to this location yet',
                              style: GoogleFonts.publicSans(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: getScreenWidth(context) * 0.025,
                              ),
                            ),
                        ],
                      ),
                      DetailsTextField(controller: pincodeController, label: 'Pincode', hMargin: 0, vMargin: 0.02),
                      const SmallTextBody(text: 'Area, Street, Sector, Village'),
                      DetailsTextField(controller: areaController, label: 'Address', hMargin: 0, vMargin: 0.02),
                      const SmallTextBody(text: 'Flat, House no, Building, Apartment'),
                      DetailsTextField(controller: houseNoController, label: 'House No', hMargin: 0, vMargin: 0.02),
                      const SmallTextBody(text: 'Landmark'),
                      DetailsTextField(controller: landmarkController, label: 'Landmark', hMargin: 0, vMargin: 0.02),
                      const SmallTextBody(text: 'Town/City'),
                      DetailsTextField(controller: cityController, label: 'City', hMargin: 0, vMargin: 0.02),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartBloc.add(
                      CartPageUpdateUserAddressClickedEvent(
                        address: areaController.text,
                        city: cityController.text,
                        houseNo: houseNoController.text,
                        landmark: landmarkController.text,
                        pincode: pincodeController.text
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Button(
                      radius: 10,
                      text: 'Update Address',
                      paddingH: 0.3,
                      paddingV: 0.035,
                    ),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
