// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grocery_bloc.dart';

@immutable
sealed class GroceryState {}

abstract class GroceryActionState extends GroceryState {}

final class GroceryInitial extends GroceryState {}

class GroceryLoadingState extends GroceryState {}

class StationaryLoadingState extends GroceryState {}

class CosmeticLoadingState extends GroceryState {}

class GroceryLoadedSuccessState extends GroceryState {
  final List<ProductDataModel> products;
  GroceryLoadedSuccessState({
    required this.products,
  });
}

class StationaryLoadedSuccessState extends GroceryState {
  final List<ProductDataModel> products;
  StationaryLoadedSuccessState({
    required this.products,
  });
}

class CosmeticLoadedSuccessState extends GroceryState {
  final List<ProductDataModel> products;
  CosmeticLoadedSuccessState({
    required this.products,
  });
}

class GroceryCardClickedActionState extends GroceryActionState {
  final ProductDataModel product;
  GroceryCardClickedActionState({
    required this.product,
  });
}

class GroceryCardCartButtonClickedState extends GroceryState {}

class GroceryAddToCartButtonClickedState extends GroceryActionState {}

class GroceryIconAnimationState extends GroceryState {}

class ProductOptionChangedState extends GroceryActionState {
  final ProductDataModel productDataModel;
  ProductOptionChangedState({
    required this.productDataModel,
  });
}
