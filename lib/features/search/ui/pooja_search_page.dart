import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/repo/grocery_repo.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:johar/model/grocery_model.dart';

class PoojaSearchPage extends StatefulWidget {
  final PoojaLoadedSuccessState successState;
  const PoojaSearchPage({
    required this.successState,
    super.key,
  });

  @override
  State<PoojaSearchPage> createState() => _CosmeticSearchPageState();
}

class _CosmeticSearchPageState extends State<PoojaSearchPage> {
  final controller = TextEditingController();

  List<ProductDataModel> pooja = [];
  List<ProductDataModel> allProducts = [];

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  fetchProducts() async {
    List<ProductDataModel> p = await GroceryRepo.fetchPooja();
    setState(() {
      allProducts = p;
      pooja = allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    void searchProducts(String query) {
      if (query.isEmpty) {
        // If the query is empty, show all products.
        setState(() {
          pooja = allProducts;
        });
      } else {
        final suggestions = allProducts.where((grocery) {
          final productTitle = grocery.name.toLowerCase();
          final input = query.toLowerCase();
          return productTitle.contains(input);
        }).toList();

        setState(() {
          pooja = suggestions;
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: searchProducts,
                controller: controller,
                style: const TextStyle(color: greyColor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    FeatherIcons.search,
                    color: greyColor,
                  ),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  labelText: 'Search Products',
                  labelStyle: const TextStyle(color: greyColor),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getScreenheight(context) * 0.8,
                child: ListView.builder(
                  itemCount: pooja.length,
                  itemBuilder: (context, index) {
                    final product = pooja[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroceryProductPage(
                                      grocery: product,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: getScreenWidth(context) * 0.02,
                          vertical: getScreenWidth(context) * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.fitHeight,
                              width: getScreenWidth(context) * 0.2,
                              height: getScreenheight(context) * 0.1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: getScreenWidth(context) * 0.65,
                                  child: Text(
                                    overflow: TextOverflow.clip,
                                    product.name,
                                    style: GoogleFonts.publicSans(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' ',
                                  style: GoogleFonts.publicSans(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    product.size!,
                                    style: GoogleFonts.publicSans(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
