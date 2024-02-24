import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/ui/google_login_page.dart';
import 'package:johar/features/cosmetics/ui/cosmetics_page.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/ui/grocery_page.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:johar/features/grocery/widgets/grocery_card_small.dart';
import 'package:johar/features/home/repo/home_repo.dart';
import 'package:johar/features/pooja/ui/pooja_page.dart';
import 'package:johar/features/profile/ui/profile_page.dart';
import 'package:johar/features/stationary/ui/stationary_page.dart';
import 'package:johar/features/sub-category/ui/subcategory_page.dart';
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
  List<ProductDataModel> products = [];

  getProducts() async {
    List<ProductDataModel> allProducts = await HomeRepo.fetchAllProducts();
    setState(() {
      products = allProducts;
    });
  }

  // fetch admin user list
  Future<void> fetchAdmins() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('admin').doc('adminNumbers').get();
    if (docSnapshot.exists) {
      List<dynamic> admins = docSnapshot.get('list');
      for (var admin in admins) {
        if (FirebaseAuth.instance.currentUser!.phoneNumber == admin) {
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

  List<String> _imageUrls = [];

  void fetchImageUrls() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('img').doc('img').get();

    List<dynamic> urls = documentSnapshot.get('img_array');

    setState(() {
      _imageUrls = List<String>.from(urls);
    });
  }

  Widget shimmerCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    fetchAdmins();
    fetchImageUrls();
  }

  final GroceryBloc groceryBloc = GroceryBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, weight: 60),
        backgroundColor: orangeColor,
        elevation: 0,
        title: Text('Johar Basket', style: GoogleFonts.poppins(color: Colors.white, fontSize: getScreenWidth(context) * 0.05, fontWeight: FontWeight.w700)),
        centerTitle: true,
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
              child: Container(
                child: Text(
                  'Johar\nBasket',
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: getScreenWidth(context) * 0.1,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset('assets/svgs/grocery.svg', width: 30, height: 30),
              title: Text('Groceries'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryPage()));
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/svgs/cosmetic.svg', width: 30, height: 30),
              title: Text('Cosmetics'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CosmeticsPage()));
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/svgs/stationary.svg', width: 30, height: 30),
              title: Text('Stationaries'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StationaryPage()));
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/svgs/pooja.svg', width: 30, height: 30),
              title: Text('Pooja Products'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PoojaPage()));
              },
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.arrowRightFromBracket,
              ),
              title: Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleLoginPage()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: getScreenWidth(context),
              height: getScreenheight(context) * 0.27,
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
                            labelText: 'Search All Products',
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
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: getScreenWidth(context) * 0.072),
                    child: Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: getScreenWidth(context) * 0.035,
                      ),
                    ),
                  ),
                  Container(
                    height: getScreenheight(context) * 0.05,
                    width: getScreenWidth(context) * 0.9,
                    margin: EdgeInsets.only(left: getScreenWidth(context) * 0.05, top: getScreenheight(context) * 0.02),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('subcategories').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
        
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
        
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            String documentName = documents[index].id;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoryPage(subCategory: documentName, groceryBloc: groceryBloc)));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: getScreenWidth(context) * 0.25,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  documentName,
                                  style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.028),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: getScreenWidth(context) * 0.04, top: getScreenWidth(context) * 0.02),
              child: Text(
                'Deals & Offers',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: getScreenWidth(context) * 0.05,
                ),
              ),
            ),
            _imageUrls.isEmpty
                ? CircularProgressIndicator()
                : Container(
                    width: getScreenWidth(context),
                    alignment: Alignment.center,
                    child: MUICarousel(
                      images: _imageUrls,
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(left: getScreenWidth(context) * 0.04, top: getScreenWidth(context) * 0.02),
              child: Text(
                'Featured Products',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: getScreenWidth(context) * 0.05,
                ),
              ),
            ),
            SizedBox(
              height: (products.where((product) => product.isFeatured).length * getScreenWidth(context) * 0.53).toDouble(),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                itemCount: products.where((product) => product.isFeatured).length,
                itemBuilder: (context, index) {
                  final featuredProducts = products.where((product) => product.isFeatured).toList();
                  return GroceryCardSmall(
                    discountedPrice: featuredProducts[index].discountedPrice,
                    size: featuredProducts[index].size!,
                    bloc: groceryBloc,
                    gst: featuredProducts[index].gst,
                    name: featuredProducts[index].name,
                    imageUrl: featuredProducts[index].imageUrl,
                    price: featuredProducts[index].price,
                    isFeatured: featuredProducts[index].isFeatured,
                    inStock: featuredProducts[index].inStock,
                    productId: featuredProducts[index].productId,
                    groceryUiDataModel: featuredProducts[index],
                    description: featuredProducts[index].description,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
