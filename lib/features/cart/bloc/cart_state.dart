// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

abstract class CartActionState extends CartState {}

final class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedSuccessState extends CartState {
  final List<ProductDataModel> products;
  CartLoadedSuccessState({
    required this.products,
  });
}

class CartIsEmptyState extends CartState {}

class CartProductItemClickedState extends CartActionState {}

class CartProductQuantityIncreaseState extends CartActionState {
  final ProductDataModel product;
  CartProductQuantityIncreaseState({
    required this.product,
  });
}

class CartProductQuantityDecreaseState extends CartActionState {
  final ProductDataModel product;
  CartProductQuantityDecreaseState({
    required this.product,
  });
}

class CartProductDeletedState extends CartActionState {
  final ProductDataModel product;
  CartProductDeletedState({
    required this.product,
  });
}

class CartBillRefreshState extends CartActionState {
  final dynamic sum;
  CartBillRefreshState({
    required this.sum,
  });
}

class CartPagePlaceOrderSuccessfulState extends CartActionState{}

class CartEmptiedState extends CartActionState {}

class CartPlacingOrderLoadingState extends CartActionState {}

class CartPageUserDetailsUpdatedSuccessState extends CartActionState {}

class VerifyQuantityState extends CartActionState {}

class BillRefreshEverySecondState extends CartActionState {}
