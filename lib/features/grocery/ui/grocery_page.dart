import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/widgets/grocery_card.dart';
import 'package:johar/features/grocery/widgets/grocery_card_small.dart';
import 'package:johar/shared/appbar.dart';
import 'package:shimmer/shimmer.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    groceryBloc.add(GroceryInitialEvent());
    getUserName();
  }

  String firstName = '';
  String lastName = '';

  void getUserName() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists) {
      String name1 = snapshot.get('firstName');
      String name2 = snapshot.get('lastName');
      setState(() {
        firstName = name1;
        lastName = name2;
      });
    }
  }

  final GroceryBloc groceryBloc = GroceryBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroceryBloc, GroceryState>(
      bloc: groceryBloc,
      listenWhen: (previous, current) => current is GroceryActionState,
      buildWhen: (previous, current) => current is! GroceryActionState,
      listener: (context, state) {
        if (state is GroceryAddToCartButtonClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added to cart')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case GroceryLoadingState:
            return Scaffold(
              body: Container(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ))),
            );
          case GroceryLoadedSuccessState:
            final successState = state as GroceryLoadedSuccessState;
            final searchController = TextEditingController();

            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                groceryBloc.add(GroceryInitialEvent());
              },
              child: Scaffold(
                appBar: CustomAppbar(
                  controller: searchController,
                  successState: successState,
                ),
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // gridview
                        SizedBox(
                          height: (successState.products.where((product) => product.isFeatured).length * getScreenWidth(context) * 0.53).toDouble(),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.65),
                            itemCount: successState.products.where((product) => product.isFeatured).length,
                            itemBuilder: (context, index) {
                              final featuredProducts = successState.products.where((product) => product.isFeatured).toList();
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
