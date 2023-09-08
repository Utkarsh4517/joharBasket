import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/widgets/profile_product_card.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/shared/search_textfield.dart';

class ProfileProductPage extends StatefulWidget {
  const ProfileProductPage({super.key});

  @override
  State<ProfileProductPage> createState() => ProfileProductPageState();
}

class ProfileProductPageState extends State<ProfileProductPage> {
  final ProfileBloc profileBloc = ProfileBloc();
  @override
  Widget build(BuildContext context) {
    Stream<List<ProductDataModel>> productStream = ProfileRepo.getProducts();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(getScreenWidth(context) * 0.06)
                    .copyWith(bottom: getScreenWidth(context) * 0.02),
                child: Text(
                  'Manage Products',
                  style: GoogleFonts.publicSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: getScreenWidth(context) * 0.04,
                  ),
                ),
              ),
              const SearchTextField(),
              // product card

              SizedBox(
                height: getScreenheight(context) * 0.5,
                child: StreamBuilder(
                    stream: productStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ProductDataModel> products = snapshot.data!;
                        return ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              ProductDataModel product = products[index];
                              return ProfileProductCard(
                                product: product,
                              );
                            });
                      } else if (snapshot.hasError) {}
                      return Container();
                    }),
              )
            ],
          ),
        )));
  }
}
