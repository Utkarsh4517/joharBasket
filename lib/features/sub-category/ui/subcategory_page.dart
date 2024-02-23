import 'package:flutter/material.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/grocery/bloc/grocery_bloc.dart';
import 'package:johar/features/grocery/widgets/grocery_card_small.dart';
import 'package:johar/features/sub-category/repo/subcategory_repo.dart';
import 'package:johar/model/grocery_model.dart';

class SubCategoryPage extends StatefulWidget {
  final String subCategory;
  final GroceryBloc groceryBloc;
  const SubCategoryPage({
    super.key,
    required this.subCategory,
    required this.groceryBloc,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Text('Showing products in ${widget.subCategory}'),
            ),
            SizedBox(
              height: getScreenheight(context) * 0.75,
              child: FutureBuilder(
                future: SubCategoryRepo.getSubCategoryProducts(widget.subCategory),
                builder: (context, AsyncSnapshot<List<ProductDataModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<ProductDataModel> filteredProducts = snapshot.data ?? [];
                    return GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                      itemBuilder: (context, index) {
                        return GroceryCardSmall(
                          discountedPrice: filteredProducts[index].discountedPrice,
                          size: filteredProducts[index].size!,
                          bloc: widget.groceryBloc,
                          gst: filteredProducts[index].gst,
                          name: filteredProducts[index].name,
                          imageUrl: filteredProducts[index].imageUrl,
                          price: filteredProducts[index].price,
                          isFeatured: filteredProducts[index].isFeatured,
                          inStock: filteredProducts[index].inStock,
                          productId: filteredProducts[index].productId,
                          groceryUiDataModel: filteredProducts[index],
                          description: filteredProducts[index].description,
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
