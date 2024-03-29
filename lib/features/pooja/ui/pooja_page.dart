import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/ui/grocery_product_page.dart';
import 'package:johar/features/grocery/widgets/grocery_card.dart';
import 'package:johar/features/grocery/widgets/grocery_card_small.dart';
import 'package:johar/features/home/repo/home_repo.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:shimmer/shimmer.dart';

class PoojaPage extends StatefulWidget {
  const PoojaPage({super.key});

  @override
  State<PoojaPage> createState() => _PoojaPageState();
}

class _PoojaPageState extends State<PoojaPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    groceryBloc.add(PoojaInitialEvent());
    super.initState();
  }

  final GroceryBloc groceryBloc = GroceryBloc();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<GroceryBloc, GroceryState>(
      bloc: groceryBloc,
      listenWhen: (previous, current) => current is GroceryActionState,
      buildWhen: (previous, current) => current is! GroceryActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case PoojaLoadingState:
            return Scaffold(
              body: Container(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ))),
            );
          case PoojaLoadedSuccessState:
            final successState = state as PoojaLoadedSuccessState;
            final searchController = TextEditingController();
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                groceryBloc.add(PoojaInitialEvent());
              },
              child: Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: getScreenheight(context) * 0.01),
                          height: getScreenheight(context) * 0.07,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: TypeAheadField<ProductDataModel>(
                            controller: searchController,
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
                              List<ProductDataModel> allProducts = await HomeRepo.fetchPooja();

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
                                  labelText: 'Search in grocery',
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
                        Container(
                          margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                          child: Text('Featured Pooja Products', style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w800, fontSize: getScreenWidth(context) * 0.04)),
                        ),

                        SizedBox(
                          height: getScreenWidth(context) * 0.75,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: successState.products.length,
                            itemBuilder: (context, index) {
                              if (successState.products[index].isFeatured == true) {
                                return GroceryCard(
                                  discountedPrice: successState.products[index].discountedPrice,
                                  size: successState.products[index].size!,
                                  bloc: groceryBloc,
                                  gst: successState.products[index].gst,
                                  name: successState.products[index].name,
                                  imageUrl: successState.products[index].imageUrl,
                                  price: successState.products[index].price,
                                  isFeatured: successState.products[index].isFeatured,
                                  inStock: successState.products[index].inStock,
                                  productId: successState.products[index].productId,
                                  groceryUiDataModel: successState.products[index],
                                  description: successState.products[index].description,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        // shop groceries

                        Container(
                          margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                          child: Text('Shop Pooja Products', style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w800, fontSize: getScreenWidth(context) * 0.04)),
                        ),
                        // gridview
                        SizedBox(
                          height: (12 * getScreenWidth(context) * 0.35).toDouble(),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return GroceryCardSmall(
                                discountedPrice: successState.products[index].discountedPrice,
                                size: successState.products[index].size!,
                                bloc: groceryBloc,
                                gst: successState.products[index].gst,
                                name: successState.products[index].name,
                                imageUrl: successState.products[index].imageUrl,
                                price: successState.products[index].price,
                                isFeatured: successState.products[index].isFeatured,
                                inStock: successState.products[index].inStock,
                                productId: successState.products[index].productId,
                                groceryUiDataModel: successState.products[index],
                                description: successState.products[index].description,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }

  shimmerCard() {}
}
