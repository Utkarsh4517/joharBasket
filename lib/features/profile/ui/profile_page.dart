// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/ui/coupon_page.dart';
import 'package:johar/features/profile/ui/orders_page.dart';
import 'package:johar/features/profile/ui/product_page.dart';
import 'package:johar/features/profile/ui/stats_page.dart';
import 'package:johar/shared/button.dart';
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
  final discountedPriceController = TextEditingController();

  // open a bottom sheet to send notificaton
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ProfileBloc profileBloc = ProfileBloc();
  int _selectedIndex = 0;

  String? subCategory;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    inStockController.dispose();
    priceController.dispose();
    gstController.dispose();
    sizeController.dispose();
    discountedPriceController.dispose();
    super.dispose();
  }

  String imageU = '';

  @override
  Widget build(BuildContext context) {
    bool toggle = false;

    const List<Widget> pages = <Widget>[
      ProfileProductPage(),
      ProfileStatsPage(),
      ProfileOrderPage(),
      CouponPage(),
    ];

    String radioValue = 'grocery';
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is NotificationButtonClickedState) {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    height: getScreenheight(context) * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DetailsTextField(controller: _titleController, label: 'Notification title'),
                        DetailsTextField(controller: _descriptionController, label: 'Description'),
                        GestureDetector(
                            onTap: () {
                              profileBloc.add(SendNotification(notfTitle: _titleController.text, notfDesc: _descriptionController.text));
                            },
                            child: Button(radius: 10, text: 'Send Notification'))
                      ],
                    ),
                  ),
                );
              });
        } else if (state is NotificationSentState) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: "Notification sent to all the users",
            ),
          );
          Navigator.pop(context);
        }
      },
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
                GButton(
                  icon: Icons.discount,
                  text: 'Coupons',
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
                isScrollControlled: true,
                enableDrag: true,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Add a new product',
                              style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),

                          DetailsTextField(controller: nameController, label: 'Complete Product Name'),

                          DetailsTextField(controller: sizeController, label: 'Product Size'),
                          DetailsTextField(controller: descriptionController, label: 'Product Description'),
                          DetailsTextField(controller: inStockController, label: 'Current stock'),
                          DetailsTextField(controller: priceController, label: 'Price including gst'),
                          DetailsTextField(controller: discountedPriceController, label: 'Price after discount'),
                          DetailsTextField(controller: gstController, label: 'GST in Rs on this product'),
                          Container(
                            height: getScreenheight(context) * 0.07,
                            width: getScreenWidth(context),
                            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.07),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('subcategories').snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                List<DocumentSnapshot> documents = snapshot.data!.docs;

                                List<String> docNames = documents.map((doc) => doc.id).toList();

                                return DropdownButton2(
                                  hint: Text('Select a category'),
                                  value: subCategory,
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: getScreenWidth(context) * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all<double>(6),
                                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(left: 14, right: 14),
                                  ),
                                  items: docNames.map((String docName) {
                                    return DropdownMenuItem(
                                      value: docName,
                                      child: Text(docName),
                                    );
                                  }).toList(),
                                  onChanged: (selectedDoc) {
                                    setState(() {
                                      subCategory = selectedDoc;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          // is featured product??
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.07, vertical: getScreenWidth(context) * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Featured Product?',
                                  style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.04),
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
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                            padding: EdgeInsets.all(getScreenWidth(context) * 0.02),
                            child: Column(
                              children: [
                                RadioListTile(
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  activeColor: Colors.green,
                                  value: 'grocery',
                                  groupValue: radioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      radioValue = value.toString();
                                    });
                                  },
                                  title: const SmallTextBody(text: 'Grocery Product'),
                                ),
                                RadioListTile(
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  activeColor: Colors.green,
                                  value: 'stationary',
                                  groupValue: radioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      radioValue = value.toString();
                                    });
                                  },
                                  title: const SmallTextBody(text: 'Stationary Product'),
                                ),
                                RadioListTile(
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  activeColor: Colors.green,
                                  value: 'cosmetics',
                                  groupValue: radioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      radioValue = value.toString();
                                    });
                                  },
                                  title: const SmallTextBody(text: 'Cosmetic Product'),
                                ),
                                RadioListTile(
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  activeColor: Colors.green,
                                  value: 'pooja',
                                  groupValue: radioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      radioValue = value.toString();
                                    });
                                  },
                                  title: const SmallTextBody(text: 'Pooja Product'),
                                ),
                              ],
                            ),
                          ),

                          // Image  uploader

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                  onPressed: () async {
                                    imageU = await ProfileRepo.selectImage();

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
                                      discountedPrice: double.parse(discountedPriceController.text),
                                      category: radioValue,
                                      isFeatured: toggle,
                                      productId: productid,
                                      size: sizeController.text.toString(),
                                      subCategory: subCategory!
                                    ));
                                    showSuccessMessage();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Select Image')),
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
                                      discountedPrice: double.parse(discountedPriceController.text),
                                      category: radioValue,
                                      isFeatured: toggle,
                                      productId: productid,
                                      size: sizeController.text.toString(),
                                      subCategory: subCategory!
                                    ));
                                    showSuccessMessage();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Open camera')),
                            ],
                          ),
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
            actions: [
              IconButton(
                  onPressed: () {
                    profileBloc.add(NotificationButtonClickedEvent());
                  },
                  icon: Icon(FontAwesomeIcons.bell))
            ],
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
