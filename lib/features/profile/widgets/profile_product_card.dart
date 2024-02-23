import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/shared/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileProductCard extends StatefulWidget {
  final ProductDataModel product;
  final String type;

  const ProfileProductCard({
    required this.product,
    required this.type,
    super.key,
  });

  @override
  State<ProfileProductCard> createState() => _ProfileProductCardState();
}

class _ProfileProductCardState extends State<ProfileProductCard> {
  final ProfileBloc profileBloc = ProfileBloc();
  String? subCategory;

  // get subcategory of product
  getSubcategory() async {
    final sc = await ProfileRepo.getSubCategoryOfTheProducst(productDataModel: widget.product, collectionName: widget.type);
    if (sc != 'noField') {
      setState(() {
        subCategory = sc;
      });
    }
  }

  @override
  void initState() {
    getSubcategory();

    super.initState();
  }

  // show bottom sheet to edit product details
  showEditProductModelSheet({required ProductDataModel productDataModel, required ProductEditButtonClickedState state}) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final inStockController = TextEditingController();
    final priceController = TextEditingController();
    final gstController = TextEditingController();
    final sizeController = TextEditingController();
    final discountedPriceController = TextEditingController();

    bool toggle = state.product.isFeatured;
    // String radioValue = 'grocery';
    nameController.text = productDataModel.name;
    sizeController.text = productDataModel.size!;
    discountedPriceController.text = productDataModel.discountedPrice.toString();
    descriptionController.text = productDataModel.description;
    inStockController.text = productDataModel.inStock.toString();
    priceController.text = productDataModel.price.toString();
    gstController.text = productDataModel.price.toString();

    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Edit Product Details',
                      style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DetailsTextField(controller: nameController, label: 'Complete Product Name'),
                  DetailsTextField(controller: descriptionController, label: 'Product Description'),
                  DetailsTextField(controller: inStockController, label: 'Current stock'),
                  DetailsTextField(controller: priceController, label: 'Price including gst'),
                  DetailsTextField(controller: discountedPriceController, label: 'Price after discount'),
                  DetailsTextField(controller: gstController, label: 'GST in Rs on this product'),
                  Container(
                    height: getScreenheight(context) * 0.07,
                    width: getScreenWidth(context),
                    margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.07),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('subcategories').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<DocumentSnapshot> documents = snapshot.data!.docs;

                        List<String> docNames = documents.map((doc) => doc.id).toList();

                        return DropdownButton2(
                          hint: Text('Select a category'),
                          value: subCategory,
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: getScreenWidth(context) * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            offset: const Offset(0, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility: MaterialStateProperty.all<bool>(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                          items: docNames.map((String docName) {
                            return DropdownMenuItem(
                              value: docName,
                              child: Text(docName),
                            );
                          }).toList(),
                          onChanged: (selectedDoc) {
                            setState(() {
                              subCategory = selectedDoc;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.07, vertical: getScreenWidth(context) * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Product?',
                          style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.04),
                        ),
                        Switch(
                          value: toggle,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              toggle = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.type == 'grocery') {
                        profileBloc.add(ProductUpdateDetailsClickedEvent(
                            product: productDataModel,
                            size: sizeController.text.toString(),
                            description: descriptionController.text,
                            gst: double.parse(gstController.text),
                            inStock: double.parse(inStockController.text),
                            isFeatred: toggle,
                            name: nameController.text,
                            price: double.parse(priceController.text),
                            discountedPrice: double.parse(discountedPriceController.text),
                            subCategory: subCategory ?? ''));
                      } else if (widget.type == 'stationary') {
                        profileBloc.add(StationaryUpdateDetailsClickedEvent(
                            product: productDataModel,
                            size: sizeController.text.toString(),
                            description: descriptionController.text,
                            gst: double.parse(gstController.text),
                            inStock: double.parse(inStockController.text),
                            isFeatred: toggle,
                            name: nameController.text,
                            price: double.parse(priceController.text),
                            discountedPrice: double.parse(discountedPriceController.text),
                            subCategory: subCategory ?? ''));
                      } else if (widget.type == 'cosmetics') {
                        profileBloc.add(CosmeticUpdateClickedEvent(
                            product: productDataModel,
                            size: sizeController.text.toString(),
                            description: descriptionController.text,
                            gst: double.parse(gstController.text),
                            inStock: double.parse(inStockController.text),
                            isFeatred: toggle,
                            name: nameController.text,
                            price: double.parse(priceController.text),
                            discountedPrice: double.parse(discountedPriceController.text),
                            subCategory: subCategory ?? ''));
                      } else if (widget.type == 'pooja') {
                        profileBloc.add(PoojaUpdateClickedEvent(
                            product: productDataModel,
                            size: sizeController.text.toString(),
                            description: descriptionController.text,
                            gst: double.parse(gstController.text),
                            inStock: double.parse(inStockController.text),
                            isFeatred: toggle,
                            name: nameController.text,
                            price: double.parse(priceController.text),
                            discountedPrice: double.parse(discountedPriceController.text),
                            subCategory: subCategory ?? ''));
                      }
                    },
                    child: const Button(
                      radius: 15,
                      text: 'Update Product Details!',
                      paddingH: 0.23,
                    ),
                  ),
                  SizedBox(height: getScreenWidth(context) * 0.2),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('pop'))
                ],
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is ProductEditButtonClickedState) {
          showEditProductModelSheet(
            productDataModel: widget.product,
            state: state,
          );
        } else if (state is ProductDetailsUpdatedState) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: "Product Updated",
            ),
          );
          Navigator.pop(context);
        } else if (state is ShowDeleteDialogState) {
          showConfirmDeleteDialog();
        } else if (state is RemoveDialogState) {
          print('deleted');
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.04, vertical: getScreenWidth(context) * 0.02),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(getScreenWidth(context) * 0.02),
                width: getScreenWidth(context) * 0.15,
                height: getScreenWidth(context) * 0.15,
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: getScreenWidth(context) * 0.3,
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      style: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.02),
                    ),
                  ),
                  Text(
                    '₹ ${widget.product.price}',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: getScreenWidth(context) * 0.03, decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    '₹ ${widget.product.discountedPrice}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: getScreenWidth(context) * 0.03),
                  ),
                  Text(
                    'Current Stock = ${widget.product.inStock}',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: getScreenWidth(context) * 0.03),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          profileBloc.add(ProductEditButtonClickedEvent(product: widget.product));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          profileBloc.add(ProductDeleteButtonClickedEvent(product: widget.product));
                        },
                        icon: const Icon(Icons.delete_forever))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: getScreenheight(context) * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Are you sure, You want to delete this product?',
                style: GoogleFonts.publicSans(
                  color: Colors.black,
                  fontSize: getScreenWidth(context) * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      if (widget.type == 'grocery') {
                        profileBloc.add(RemoveProductClickedEvent(productDataModel: widget.product));
                      } else if (widget.type == 'stationary') {
                        profileBloc.add(RemoveStationaryClickedEvent(productDataModel: widget.product));
                      } else if (widget.type == 'cosmetics') {
                        profileBloc.add(RemoveCosmeticClickedEvent(productDataModel: widget.product));
                      } else if (widget.type == 'pooja') {
                        profileBloc.add(RemovePoojaClickedEvent(productDataModel: widget.product));
                      }
                    },
                    child: const Text(
                      'Remove Product',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
