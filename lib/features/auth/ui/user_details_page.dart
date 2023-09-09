import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/service/auth_service.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/shared/button.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // heading text
            Container(
              margin: EdgeInsets.all(getScreenWidth(context) * 0.07),
              child: Text(
                'Complete your profile',
                style: GoogleFonts.chivo(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: getScreenWidth(context) * 0.07,
                ),
              ),
            ),
            // textfields
            DetailsTextField(
                controller: firstNameController, label: 'First name'),
            DetailsTextField(
                controller: lastNameController, label: 'Last name'),
            DetailsTextField(
              controller: mobileController,
              label: 'Mobile Number',
              keyboardType: TextInputType.number,
            ),
            DetailsTextField(controller: addressController, label: 'Address'),
            DetailsTextField(
              controller: pinController,
              label: 'Pin code',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: getScreenWidth(context) * 0.07),
            TextButton(
              onPressed: () async {
                await AuthService().uploadUserDetails(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  mobileNumber: mobileController.text,
                  address: addressController.text,
                  pinCode: pinController.text,
                );
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Container(
                alignment: Alignment.center,
                child: const Button(
                  radius: 15,
                  text: 'Proceed',
                  paddingH: 0.35,
                  paddingV: 0.05,
                ),
              ),
            ),

            SizedBox(height: getScreenWidth(context) * 0.15),
          ],
        ),
      )),
    );
  }
}
