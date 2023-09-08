// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}

class ProfilePageOrderInitialEvent extends ProfileEvent {}

class AddProductClickedEvent extends ProfileEvent {
  final String name;
  final String description;
  final String imageUrl;
  final double inStock;
  final double price;
  final double gst;
  final String category;
  final String productId;
  final bool isFeatured;
  final String size;
  AddProductClickedEvent({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.inStock,
    required this.price,
    required this.gst,
    required this.category,
    required this.productId,
    required this.isFeatured,
    required this.size,
  });
}

class ProductEditButtonClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  ProductEditButtonClickedEvent({
    required this.product,
  });
}

class ProductDeleteButtonClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  ProductDeleteButtonClickedEvent({
    required this.product,
  });
}

class ProductUpdateDetailsClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  final double inStock;
  final String name;
  final bool isFeatred;
  final String description;
  final double price;
  final double gst;
  final String size;
  ProductUpdateDetailsClickedEvent({
    required this.product,
    required this.inStock,
    required this.name,
    required this.isFeatred,
    required this.description,
    required this.price,
    required this.gst,
    required this.size,
  });
}

class RemoveProductClickedEvent extends ProfileEvent {
  final ProductDataModel productDataModel;
  RemoveProductClickedEvent({
    required this.productDataModel,
  });
}

class AcceptOrderClickedEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  AcceptOrderClickedEvent({
    required this.orderId,
    required this.userId,
  });
}

class ConfirmOrderClickedEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  final String deliveryTime;
  ConfirmOrderClickedEvent({
    required this.orderId,
    required this.userId,
    required this.deliveryTime,
  });
}

class ShowConfirmDeliveryDialogEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  ShowConfirmDeliveryDialogEvent({
    required this.orderId,
    required this.userId,
  });
}

class DeliveryConfirmedEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  DeliveryConfirmedEvent({
    required this.orderId,
    required this.userId,
  });
}

class StatsPageInitialEvent extends ProfileEvent {}



