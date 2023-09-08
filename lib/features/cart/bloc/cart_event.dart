// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartInitialEvent extends CartEvent {}

class CartItemClickedEvent extends CartEvent {
  final ProductDataModel clickedProduct;
  CartItemClickedEvent({
    required this.clickedProduct,
  });
}

class CartProductQuantityIncreaseEvent extends CartEvent {
  final ProductDataModel product;
  CartProductQuantityIncreaseEvent({
    required this.product,
  });
}

class CartProductQuantityDecreaseEvent extends CartEvent {
  final ProductDataModel product;
  CartProductQuantityDecreaseEvent({
    required this.product,
  });
}

class CartRemoveProductEvent extends CartEvent {
  final ProductDataModel product;
  CartRemoveProductEvent({
    required this.product,
  });
}

class CartBillRefreshEvent extends CartEvent {}

class CartPagePlaceOrderClickedEvent extends CartEvent {
  final List<ProductDataModel> products;
  final String amount;
  CartPagePlaceOrderClickedEvent({
    required this.amount,
    required this.products,
  });
}

class CartPageUpdateDetailsClickedEvent extends CartEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String pincode;
  final String address;
  CartPageUpdateDetailsClickedEvent({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.pincode,
    required this.address,
  });
}

class RefreshBillSummeryEverySecondEvent extends CartEvent {}
