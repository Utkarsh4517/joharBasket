import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/repo/grocery_repo.dart';
import 'package:johar/model/grocery_model.dart';

class StationarySearchPage extends StatefulWidget {
  final StationaryLoadedSuccessState successState;
  const StationarySearchPage({
    required this.successState,
    super.key,
  });

  @override
  State<StationarySearchPage> createState() => _StationarySearchPageState();
}

class _StationarySearchPageState extends State<StationarySearchPage> {
  final controller = TextEditingController();

  List<ProductDataModel> stationaries = []; 

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  fetchProducts() async {
    List<ProductDataModel> stationary = await GroceryRepo.fetchStationaries();
    setState(() {
      stationaries = stationary;
    });
  }


  @override
  Widget build(BuildContext context) {
    void searchProducts(String query) {
      final suggestions = stationaries.where((grocery) {
        final productTitle = grocery.name.toLowerCase();
        final input = query.toLowerCase();
        return productTitle.contains(input);
      }).toList();

      setState(() {
        stationaries = suggestions;
      });
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
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(14)),
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
                  itemCount: stationaries.length,
                  itemBuilder: (context, index) {
                    final product = stationaries[index];
                    return Container(
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
                            fit: BoxFit.cover,
                            width: getScreenWidth(context) * 0.2,
                          ),
                          Text(
                            product.name,
                            style: GoogleFonts.publicSans(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ',
                            style: GoogleFonts.publicSans(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product.size!,
                            style: GoogleFonts.publicSans(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
