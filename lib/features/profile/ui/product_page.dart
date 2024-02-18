import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/widgets/profile_product_card.dart';
import 'package:johar/model/grocery_model.dart';

class ProfileProductPage extends StatefulWidget {
  const ProfileProductPage({super.key});

  @override
  State<ProfileProductPage> createState() => ProfileProductPageState();
}

class ProfileProductPageState extends State<ProfileProductPage> with SingleTickerProviderStateMixin {
  final ProfileBloc profileBloc = ProfileBloc();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<ProductDataModel>> productStream = ProfileRepo.getProducts();
    Stream<List<ProductDataModel>> stationaryStream = ProfileRepo.getStationaryProducts();
    Stream<List<ProductDataModel>> cosmeticStream = ProfileRepo.getCosmeticProducts();
    Stream<List<ProductDataModel>> poojaStream = ProfileRepo.getPoojaProducts();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(getScreenWidth(context) * 0.06).copyWith(bottom: getScreenWidth(context) * 0.02),
                child: Text(
                  'Manage Products',
                  style: GoogleFonts.publicSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: getScreenWidth(context) * 0.04,
                  ),
                ),
              ),
              // const SearchTextField(),
              // product card

              Container(
                alignment: Alignment.center,
                height: getScreenheight(context) * 0.9,
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      dividerColor: const Color.fromRGBO(243, 245, 247, 1),
                      dividerHeight: getScreenheight(context) * 0.06,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      splashBorderRadius: BorderRadius.circular(12),
                      indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      indicatorPadding: const EdgeInsets.only(top: -8, bottom: -40),
                      tabs: [
                        Tab(text: 'Groceries'),
                        Tab(text: 'Stationary'),
                        Tab(text: 'Cosmetics'),
                        Tab(text: 'Pooja'),
                      ],
                      labelColor: Colors.black,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                      child: TabBarView(
                        clipBehavior: Clip.antiAlias,
                        controller: _tabController,
                        children: [
                          SizedBox(
                            height: getScreenheight(context) * 0.8,
                            width: getScreenWidth(context) * 0.9,
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
                                            type: 'grocery',
                                          );
                                        });
                                  } else if (snapshot.hasError) {}
                                  return Container();
                                }),
                          ),
                          SizedBox(
                            height: getScreenheight(context) * 0.8,
                            width: getScreenWidth(context) * 0.9,
                            child: StreamBuilder(
                                stream: stationaryStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ProductDataModel> products = snapshot.data!;
                                    return ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          ProductDataModel product = products[index];
                                          return ProfileProductCard(
                                            product: product,
                                            type: 'stationary',
                                          );
                                        });
                                  } else if (snapshot.hasError) {}
                                  return Container();
                                }),
                          ),
                          SizedBox(
                            height: getScreenheight(context) * 0.8,
                            width: getScreenWidth(context) * 0.9,
                            child: StreamBuilder(
                                stream: cosmeticStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ProductDataModel> products = snapshot.data!;
                                    return ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          ProductDataModel product = products[index];
                                          return ProfileProductCard(
                                            product: product,
                                            type: 'cosmetics',
                                          );
                                        });
                                  } else if (snapshot.hasError) {}
                                  return Container();
                                }),
                          ),
                          SizedBox(
                            height: getScreenheight(context) * 0.8,
                            width: getScreenWidth(context) * 0.9,
                            child: StreamBuilder(
                                stream: poojaStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ProductDataModel> products = snapshot.data!;
                                    return ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          ProductDataModel product = products[index];
                                          return ProfileProductCard(
                                            product: product,
                                            type: 'pooja',
                                          );
                                        });
                                  } else if (snapshot.hasError) {}
                                  return Container();
                                }),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
