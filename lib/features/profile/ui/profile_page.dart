// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/ui/orders_page.dart';
import 'package:johar/features/profile/ui/product_page.dart';
import 'package:johar/features/profile/ui/stats_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final inStockController = TextEditingController();
  final priceController = TextEditingController();
  final gstController = TextEditingController();
  final sizeController = TextEditingController();

  final ProfileBloc profileBloc = ProfileBloc();
  int _selectedIndex = 0;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    inStockController.dispose();
    priceController.dispose();
    gstController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  String imageU = '';

  @override
  Widget build(BuildContext context) {
    bool toggle = false;
    // bool isImageUploaded = false;

    const List<Widget> pages = <Widget>[
      ProfileProductPage(),
      ProfileStatsPage(),
      ProfileOrderPage(),
    ];

    // String radioValue = 'grocery';
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: const EdgeInsets.all(16),
              selectedIndex: _selectedIndex,
              onTabChange: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.shopping_bag_outlined,
                  text: 'Products',
                ),
                GButton(
                  icon: Icons.pie_chart_rounded,
                  text: 'Stats',
                ),
                GButton(
                  icon: Icons.shopping_cart_checkout,
                  text: 'Orders',
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          body: pages[_selectedIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Add a new product',
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          DetailsTextField(
                              controller: nameController,
                              label: 'Complete Product Name'),

                          DetailsTextField(
                              controller: sizeController,
                              label: 'Product Size,'),
                          DetailsTextField(
                              controller: descriptionController,
                              label: 'Product Description'),
                          DetailsTextField(
                              controller: inStockController,
                              label: 'Current stock'),
                          DetailsTextField(
                              controller: priceController,
                              label: 'Price including gst'),
                          DetailsTextField(
                              controller: gstController,
                              label: 'GST in Rs on this product'),

                          // is featured product??
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getScreenWidth(context) * 0.07,
                                vertical: getScreenWidth(context) * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Featured Product?',
                                  style: GoogleFonts.publicSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getScreenWidth(context) * 0.04),
                                ),
                                Switch(
                                  value: toggle,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    setState(() {
                                      toggle = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(15)),
                          //   margin:
                          //       EdgeInsets.all(getScreenWidth(context) * 0.06),
                          //   padding:
                          //       EdgeInsets.all(getScreenWidth(context) * 0.02),
                          //   child: Column(
                          //     children: [
                          //       RadioListTile(
                          //         controlAffinity:
                          //             ListTileControlAffinity.trailing,
                          //         activeColor: Colors.green,
                          //         value: 'grocery',
                          //         groupValue: radioValue,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             radioValue = value.toString();
                          //           });
                          //         },
                          //         title: const SmallTextBody(
                          //             text: 'Grocery Product'),
                          //       ),
                          //       RadioListTile(
                          //         controlAffinity:
                          //             ListTileControlAffinity.trailing,
                          //         activeColor: Colors.green,
                          //         value: 'stationary',
                          //         groupValue: radioValue,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             radioValue = value.toString();
                          //           });
                          //         },
                          //         title: const SmallTextBody(
                          //             text: 'Stationary Product'),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          // Image  uploader
                          OutlinedButton(
                              onPressed: () async {
                                imageU = await ProfileRepo.uploadImage();
                                showErrorMessage();
                                const uuid = Uuid();
                                final productid = uuid.v1();
                                profileBloc.add(AddProductClickedEvent(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  imageUrl: imageU,
                                  inStock: double.parse(inStockController.text),
                                  price: double.parse(priceController.text),
                                  gst: double.parse(gstController.text),
                                  category: 'grocery',
                                  isFeatured: toggle,
                                  productId: productid,
                                  size: sizeController.text.toString(),
                                ));
                                showSuccessMessage();
                                Navigator.pop(context);
                              },
                              child: const Text('Upload image of product')),
                          SizedBox(height: getScreenWidth(context) * 0.1),
                        ],
                      ),
                    );
                  }, // SizedBox(height: getScreenWidth(context) * 0.04)
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('Admin Panel'),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  // show top snackbar
  showErrorMessage() {
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.info(
        message: "Please wait while we upload the image",
      ),
    );
  }

  showSuccessMessage() {
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(
        message: "Product added successfully",
      ),
    );
  }
}
