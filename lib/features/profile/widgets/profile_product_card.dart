import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/auth/widgets/details_text_field.dart';
import 'package:johar/features/cart/widgets/small_text_body.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/shared/button.dart';

class ProfileProductCard extends StatefulWidget {
  final ProductDataModel product;

  const ProfileProductCard({
    required this.product,
    super.key,
  });

  @override
  State<ProfileProductCard> createState() => _ProfileProductCardState();
}

class _ProfileProductCardState extends State<ProfileProductCard> {
  final ProfileBloc profileBloc = ProfileBloc();

  // show bottom sheet to edit product details
  showEditProductModelSheet(
      {required ProductDataModel productDataModel,
      required ProductEditButtonClickedState state}) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final inStockController = TextEditingController();
    final priceController = TextEditingController();
    final gstController = TextEditingController();
    final sizeController = TextEditingController();
    final discountedPriceController = TextEditingController();
    bool toggle = state.product.isFeatured;
    String radioValue = 'grocery';
    nameController.text = productDataModel.name;
    sizeController.text = productDataModel.size!;
    discountedPriceController.text =
        productDataModel.discountedPrice.toString();
    descriptionController.text = productDataModel.description;
    inStockController.text = productDataModel.inStock.toString();
    priceController.text = productDataModel.price.toString();
    gstController.text = productDataModel.price.toString();
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Edit Product Details',
                  style: GoogleFonts.publicSans(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              DetailsTextField(
                  controller: nameController, label: 'Complete Product Name'),
              DetailsTextField(
                  controller: descriptionController,
                  label: 'Product Description'),
              DetailsTextField(
                  controller: inStockController, label: 'Current stock'),
              DetailsTextField(
                  controller: priceController, label: 'Price including gst'),
              DetailsTextField(
                  controller: discountedPriceController, label: 'Price after discount'),
              DetailsTextField(
                  controller: gstController,
                  label: 'GST in Rs on this product'),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.07,
                    vertical: getScreenWidth(context) * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Product?',
                      style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: getScreenWidth(context) * 0.04),
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                padding: EdgeInsets.all(getScreenWidth(context) * 0.02),
                child: Column(
                  children: [
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: Colors.green,
                      value: 'grocery',
                      groupValue: radioValue,
                      onChanged: (value) {
                        setState(() {
                          radioValue = value.toString();
                        });
                      },
                      title: const SmallTextBody(text: 'Grocery Product'),
                    ),
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: Colors.green,
                      value: 'stationary',
                      groupValue: radioValue,
                      onChanged: (value) {
                        setState(() {
                          radioValue = value.toString();
                        });
                      },
                      title: const SmallTextBody(text: 'Stationary Product'),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => profileBloc.add(ProductUpdateDetailsClickedEvent(
                  product: productDataModel,
                  size: sizeController.text.toString(),
                  description: descriptionController.text,
                  gst: double.parse(gstController.text),
                  inStock: double.parse(inStockController.text),
                  isFeatred: toggle,
                  name: nameController.text,
                  price: double.parse(priceController.text),
                )),
                child: const Button(
                  radius: 15,
                  text: 'Update Product Details!',
                  paddingH: 0.23,
                ),
              ),
              SizedBox(height: getScreenWidth(context) * 0.2),
            ],
          ),
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
          Navigator.pop(context);
        } else if (state is ShowDeleteDialogState) {
          showConfirmDeleteDialog();
        } else if (state is RemoveDialogState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: getScreenWidth(context) * 0.04,
              vertical: getScreenWidth(context) * 0.02),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(getScreenWidth(context) * 0.02),
                width: getScreenWidth(context) * 0.15,
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
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '₹ ${widget.product.price}',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: getScreenWidth(context) * 0.03),
                  ),
                  Text(
                    'Current Stock = ${widget.product.inStock}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: getScreenWidth(context) * 0.03),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          profileBloc.add(ProductEditButtonClickedEvent(
                              product: widget.product));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          profileBloc.add(ProductDeleteButtonClickedEvent(
                              product: widget.product));
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
                      profileBloc.add(RemoveProductClickedEvent(
                          productDataModel: widget.product));
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
