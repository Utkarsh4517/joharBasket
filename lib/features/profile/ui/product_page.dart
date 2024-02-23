import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/ui/category_page.dart';
import 'package:johar/features/profile/widgets/stats_card.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:lottie/lottie.dart';
import 'package:modular_ui/modular_ui.dart';

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
    final subCategoryController = TextEditingController();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: 'grocery')));
                    },
                    child: StatsCard(text: '\n\n\nGroceries', color: Colors.blueAccent, data: '', sizeFactor: 0.05),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: 'cosmetics')));
                    },
                    child: StatsCard(text: '\n\n\nCosmetics', color: Colors.cyan, data: '', sizeFactor: 0.05),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: 'stationary')));
                    },
                    child: StatsCard(text: '\n\n\nStationary', color: Colors.orange, data: '', sizeFactor: 0.05),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: 'pooja')));
                    },
                    child: StatsCard(text: '\n\n\nPooja Products', color: Colors.red, data: '', sizeFactor: 0.05),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: getScreenWidth(context) * 0.05),
                    child: Text('Manage Sub categories'),
                  ),
                  TextButton(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, _, __) => StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 3000),
                                padding: EdgeInsets.all(
                                  getScreenWidth(context) * 0.05,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: getScreenWidth(context) * 0.05,
                                  vertical: getScreenheight(context) * 0.25,
                                ),
                                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(bottom: 20),
                                              child: Text(
                                                "Create a new subcategory",
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.03),
                                              ),
                                            ),
                                            MUIPrimaryInputField(hintText: 'Sub-category name', controller: subCategoryController, filledColor: Colors.white),
                                            MUITextButton(
                                              onPressed: () async {
                                                await ProfileRepo.addSubcategory(subCategoryController.text);
                                                Navigator.pop(context);
                                              },
                                              text: 'Done',
                                              textColor: Colors.redAccent,
                                              bgColor: Colors.grey.shade200,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Text('+ Sub-category'))
                ],
              ),
              Container(
                height: getScreenheight(context) * 0.3,
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: getScreenWidth(context) * 0.02),
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
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        String documentName = documents[index].id;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(bottom: 5),
                          child: ListTile(
                            title: Text(documentName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await ProfileRepo.deleteSubcategory(name: documentName);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )));
  }
}
