import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/ui/grocery_page.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:johar/features/home/repo/home_repo.dart';
import 'package:johar/features/profile/ui/profile_page.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  bool isAdmin = false;

  // fetch admin user list
  Future<void> fetchAdmins() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('adminEmails').get();
    if (docSnapshot.exists) {
      List<dynamic> admins = docSnapshot.get('list');
      for (var admin in admins) {
        if (FirebaseAuth.instance.currentUser!.email == admin) {
          setState(() {
            isAdmin = true;
          });
          if (mounted) {
            setState(
              () async {
                // upload the admin device fcm token...
                final firebaseMessaging = FirebaseMessaging.instance;
                final token = await firebaseMessaging.getToken();

                DocumentSnapshot adminFcmSnapshot = await FirebaseFirestore.instance.collection('admin').doc('adminFcm').get();
                if (adminFcmSnapshot.exists) {
                  List<dynamic> adminFcmList = adminFcmSnapshot.get('adminFcms');
                  if (!adminFcmList.contains(token)) {
                    adminFcmList.add(token);
                  }
                  await FirebaseFirestore.instance.collection('admin').doc('adminFcm').update({'adminFcms': adminFcmList});
                } else {
                  await FirebaseFirestore.instance.collection('admin').doc('adminFcm').set({
                    'adminFcms': [token]
                  });
                }
              },
            );
          }
        }
      }
    }
  }

  Widget shimmerCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, weight: 60),
        backgroundColor: orangeColor,
        elevation: 0,
        actions: [
          if (isAdmin)
            Container(
              margin: EdgeInsets.only(right: getScreenWidth(context) * 0.05),
              child: MUISecondaryButton(
                  text: 'Admin',
                  bgColor: orangeColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  }),
            )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: orangeColor,
              ),
              child: Text('Johar Basket'),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Groceries'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryPage()));
              },
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Cosmetics'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Stationaries'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Pooja Products'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: getScreenWidth(context),
                height: getScreenheight(context) * 0.31,
                decoration: BoxDecoration(color: orangeColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05),
                      height: getScreenheight(context) * 0.07,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: TypeAheadField<ProductDataModel>(
                        controller: controller,
                        itemBuilder: (context, value) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.02, horizontal: getScreenWidth(context) * 0.02),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: value.imageUrl,
                                  width: getScreenWidth(context) * 0.1,
                                  height: getScreenWidth(context) * 0.1,
                                  placeholder: (context, url) => Container(child: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: shimmerCard())),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.02),
                                  width: getScreenWidth(context) * 0.5,
                                  child: Text(value.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
                                )
                              ],
                            ),
                          );
                        },
                        onSelected: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroceryProductPage(
                                grocery: value,
                              ),
                            ),
                          );
                        },
                        suggestionsCallback: (search) async {
                          List<ProductDataModel> allProducts = await HomeRepo.fetchAllProducts();

                          List<ProductDataModel> filteredProducts = allProducts.where((product) => product.name.toLowerCase().contains(search.toLowerCase())).toList();

                          return filteredProducts;
                        },
                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            cursorColor: Colors.black,
                            controller: controller,
                            style: GoogleFonts.poppins(color: const Color.fromRGBO(51, 51, 51, 1), fontWeight: FontWeight.w700, fontSize: 12),
                            focusNode: focusNode,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              suffix: (controller.text.isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          controller.text = '';
                                        });
                                      },
                                      child: Icon(FontAwesomeIcons.ban, color: Colors.grey))
                                  : Icon(FontAwesomeIcons.magnifyingGlass),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                              labelText: 'Search Products',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: getScreenWidth(context) * 0.035,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: getScreenheight(context) * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getScreenWidth(context) * 0.23,
                          height: 2,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        Text(
                          '  EXPLORE  ',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: getScreenWidth(context) * 0.05,
                          ),
                        ),
                        Container(
                          width: getScreenWidth(context) * 0.23,
                          height: 2,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      height: getScreenheight(context) * 0.15,
                      margin: EdgeInsets.only(left: getScreenWidth(context) * 0.05, top: getScreenheight(context) * 0.02),
                      child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: getScreenWidth(context) * 0.02, bottom: 10),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://t4.ftcdn.net/jpg/01/02/58/91/360_F_102589163_hk02O92vzEYP0rZbVyvDTbkje1GaUDk1.jpg',
                                      width: getScreenWidth(context) * 0.16,
                                      height: getScreenWidth(context) * 0.16,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  '   SPICES',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getScreenWidth(context) * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
