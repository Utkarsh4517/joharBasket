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
  final dynamic discountedPrice;
  final String subCategory;
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
    required this.discountedPrice,
    required this.subCategory,
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
  final double discountedPrice;
  final String subCategory;
  ProductUpdateDetailsClickedEvent({
    required this.product,
    required this.inStock,
    required this.name,
    required this.isFeatred,
    required this.description,
    required this.price,
    required this.gst,
    required this.size,
    required this.discountedPrice,
    required this.subCategory,
  });
}

class StationaryUpdateDetailsClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  final double inStock;
  final String name;
  final bool isFeatred;
  final String description;
  final double price;
  final double gst;
  final String size;
  final double discountedPrice;
  final String subCategory;
  StationaryUpdateDetailsClickedEvent({
    required this.product,
    required this.inStock,
    required this.name,
    required this.isFeatred,
    required this.description,
    required this.price,
    required this.gst,
    required this.size,
    required this.discountedPrice,
    required this.subCategory,
  });
}

class CosmeticUpdateClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  final double inStock;
  final String name;
  final bool isFeatred;
  final String description;
  final double price;
  final double gst;
  final String size;
  final double discountedPrice;
  final String subCategory;
  CosmeticUpdateClickedEvent({
    required this.product,
    required this.inStock,
    required this.name,
    required this.isFeatred,
    required this.description,
    required this.price,
    required this.gst,
    required this.size,
    required this.discountedPrice,
    required this.subCategory,
  });
}

class PoojaUpdateClickedEvent extends ProfileEvent {
  final ProductDataModel product;
  final double inStock;
  final String name;
  final bool isFeatred;
  final String description;
  final double price;
  final double gst;
  final String size;
  final double discountedPrice;
  final String subCategory;
  PoojaUpdateClickedEvent({
    required this.product,
    required this.inStock,
    required this.name,
    required this.isFeatred,
    required this.description,
    required this.price,
    required this.gst,
    required this.size,
    required this.discountedPrice,
    required this.subCategory,
  });
}

class RemoveProductClickedEvent extends ProfileEvent {
  final ProductDataModel productDataModel;
  RemoveProductClickedEvent({
    required this.productDataModel,
  });
}

class RemoveStationaryClickedEvent extends ProfileEvent {
  final ProductDataModel productDataModel;
  RemoveStationaryClickedEvent({
    required this.productDataModel,
  });
}

class RemoveCosmeticClickedEvent extends ProfileEvent {
  final ProductDataModel productDataModel;
  RemoveCosmeticClickedEvent({
    required this.productDataModel,
  });
}

class RemovePoojaClickedEvent extends ProfileEvent {
  final ProductDataModel productDataModel;
  RemovePoojaClickedEvent({
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

class CancelOrderClickedEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  CancelOrderClickedEvent({
    required this.orderId,
    required this.userId,
  });
}

class ConfirmCancelOrderEvent extends ProfileEvent {
  final String orderId;
  final String userId;
  ConfirmCancelOrderEvent({
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

class NotificationButtonClickedEvent extends ProfileEvent {}

class SendNotification extends ProfileEvent {
  final String notfTitle;
  final String notfDesc;

  SendNotification({
    required this.notfTitle,
    required this.notfDesc,
  });
}

class StatsPageInitialEvent extends ProfileEvent {}

class AddCouponClickedEvent extends ProfileEvent {
  final String type;
  final String couponCode;
  final double flatOff;
  final double onOrderAbove;
  final double discount;
  final double upto;
  AddCouponClickedEvent({
    required this.type,
    required this.couponCode,
    required this.flatOff,
    required this.onOrderAbove,
    required this.discount,
    required this.upto,
  });
}

class CouponDeleteClickedEvent extends ProfileEvent {
  final CouponModel couponModel;
  CouponDeleteClickedEvent({
    required this.couponModel,
  });
}
