import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/widgets/grocery_card.dart';
import 'package:johar/features/grocery/widgets/grocery_card_small.dart';
import 'package:johar/shared/stationary_appbar.dart';
import 'package:shimmer/shimmer.dart';

class StationaryPage extends StatefulWidget {
  const StationaryPage({super.key});

  @override
  State<StationaryPage> createState() => _StationaryPageState();
}

class _StationaryPageState extends State<StationaryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    groceryBloc.add(StationaryInitialEvent());
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
      listener: (context, state) {
        if (state is GroceryAddToCartButtonClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case StationaryLoadingState:
           return Scaffold(
              body: Container(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ))),
            );
          case StationaryLoadedSuccessState:
            final successState = state as StationaryLoadedSuccessState;
            final searchController = TextEditingController();

            return RefreshIndicator(
              onRefresh: () async{
                await Future.delayed(Duration(seconds: 1));
                groceryBloc.add(StationaryInitialEvent());
              },
              child: Scaffold(
                appBar: StationaryAppBar(
                  controller: searchController,
                  successState: successState,
                ),
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name and profile pic
                        SizedBox(height: getScreenWidth(context) * 0.01),
                        SizedBox(height: getScreenWidth(context) * 0.04),
                        // const SearchTextField(),
            
                        Container(
                          margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                          child: Text('Featured Stationary Products',
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: getScreenWidth(context) * 0.04)),
                        ),
            
                        SizedBox(
                          height: getScreenWidth(context) * 0.75,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: successState.products.length,
                            itemBuilder: (context, index) {
                              if (successState.products[index].isFeatured ==
                                  true) {
                                return GroceryCard(
                                  discountedPrice: successState
                                      .products[index].discountedPrice,
                                  size: successState.products[index].size!,
                                  bloc: groceryBloc,
                                  gst: successState.products[index].gst,
                                  name: successState.products[index].name,
                                  imageUrl: successState.products[index].imageUrl,
                                  price: successState.products[index].price,
                                  isFeatured:
                                      successState.products[index].isFeatured,
                                  inStock: successState.products[index].inStock,
                                  productId:
                                      successState.products[index].productId,
                                  groceryUiDataModel:
                                      successState.products[index],
                                  description:
                                      successState.products[index].description,
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
                          child: Text('Shop Stationaries',
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: getScreenWidth(context) * 0.04)),
                        ),
                        // gridview
                        SizedBox(
                          height: (successState.products.length *
                                  getScreenWidth(context) *
                                  0.35)
                              .toDouble(),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: successState.products.length,
                            itemBuilder: (context, index) {
                              return GroceryCardSmall(
                                discountedPrice:
                                    successState.products[index].discountedPrice,
                                size: successState.products[index].size!,
                                bloc: groceryBloc,
                                gst: successState.products[index].gst,
                                name: successState.products[index].name,
                                imageUrl: successState.products[index].imageUrl,
                                price: successState.products[index].price,
                                isFeatured:
                                    successState.products[index].isFeatured,
                                inStock: successState.products[index].inStock,
                                productId: successState.products[index].productId,
                                groceryUiDataModel: successState.products[index],
                                description:
                                    successState.products[index].description,
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
}
