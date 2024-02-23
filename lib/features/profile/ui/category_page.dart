import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:johar/features/home/repo/home_repo.dart';
import 'package:johar/features/profile/widgets/profile_product_card.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: getScreenheight(context) * 0.01),
              height: getScreenheight(context) * 0.07,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: TypeAheadField<ProductDataModel>(
                controller: searchController,
                itemBuilder: (context, value) {
                  return ProfileProductCard(
                    product: value,
                    type: 'grocery',
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
                  if (widget.category == 'grocery') {
                    List<ProductDataModel> allProducts = await HomeRepo.fetchGroceries();

                    List<ProductDataModel> filteredProducts = allProducts.where((product) => product.name.toLowerCase().contains(search.toLowerCase())).toList();

                    return filteredProducts;
                  } else if (widget.category == 'stationary') {
                    List<ProductDataModel> allProducts = await HomeRepo.fetchStationary();

                    List<ProductDataModel> filteredProducts = allProducts.where((product) => product.name.toLowerCase().contains(search.toLowerCase())).toList();

                    return filteredProducts;
                  } else if (widget.category == 'pooja') {
                    List<ProductDataModel> allProducts = await HomeRepo.fetchPooja();

                    List<ProductDataModel> filteredProducts = allProducts.where((product) => product.name.toLowerCase().contains(search.toLowerCase())).toList();

                    return filteredProducts;
                  } else if (widget.category == 'cosmetics') {
                    List<ProductDataModel> allProducts = await HomeRepo.fetchCosmetics();

                    List<ProductDataModel> filteredProducts = allProducts.where((product) => product.name.toLowerCase().contains(search.toLowerCase())).toList();

                    return filteredProducts;
                  } else {
                    return null;
                  }
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
                      labelText: 'Search in ${widget.category}',
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
          ],
        ),
      )),
    );
  }
}
