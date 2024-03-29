// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grocery_bloc.dart';

@immutable
sealed class GroceryEvent {}

class GroceryInitialEvent extends GroceryEvent {}

class StationaryInitialEvent extends GroceryEvent {}

class CosmeticInitialEvent extends GroceryEvent {}

class PoojaInitialEvent extends GroceryEvent {}

class GroceryCardClickedEvent extends GroceryEvent {
  final ProductDataModel clickedGrocery;
  GroceryCardClickedEvent({
    required this.clickedGrocery,
  });
}

class GroceryCardCartButtonClickedEvent extends GroceryEvent {
  final ProductDataModel cartClickedGrocery;
  GroceryCardCartButtonClickedEvent({
    required this.cartClickedGrocery,
  });
}

class GroceryProductPageAddToCardClickedEvent extends GroceryEvent {
  final ProductDataModel addToCartGrocery;
  final dynamic quantity;
  GroceryProductPageAddToCardClickedEvent({
    required this.addToCartGrocery,
    required this.quantity,
  });
}

class ProductOptionClickedEvent extends GroceryEvent {
  final ProductDataModel selectedProductOption;
  ProductOptionClickedEvent({
    required this.selectedProductOption,
  });
}


