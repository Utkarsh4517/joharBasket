// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProductEditButtonClickedState extends ProfileActionState {
  final ProductDataModel product;
  ProductEditButtonClickedState({
    required this.product,
  });
}

class ProfilePageShowCancelOrderDialogBoxState extends ProfileActionState {
  final String orderId;
  final String userId;
  ProfilePageShowCancelOrderDialogBoxState({
    required this.orderId,
    required this.userId,
  });
}

class ProfilePageOrderCancelSuccessfulState extends ProfileActionState {}

class OrderCancelSuccessfulState extends ProfileActionState {}

class ProductDetailsUpdatedState extends ProfileActionState {}

class ShowDeleteDialogState extends ProfileActionState {}

class RemoveDialogState extends ProfileActionState {}

class OrderPageFetchingState extends ProfileState {}

class StatsPageFetchingState extends ProfileState {}

class OrderIsEmptyState extends ProfileState {}

class ProfileOrderLoadedSuccessState extends ProfileState {
  final List<List<ProductDataModel>> orders;
  ProfileOrderLoadedSuccessState({
    required this.orders,
  });
}

class StatsPageOrderDeliveredSuccessState extends ProfileState {
  final List<List<ProductDataModel>> orders;
  StatsPageOrderDeliveredSuccessState({
    required this.orders,
  });
}

class ProfilePageShowAcceptOrderDialog extends ProfileActionState {
  final String orderId;
  final String userId;
  ProfilePageShowAcceptOrderDialog({
    required this.orderId,
    required this.userId,
  });
}

class OrderAcceptedSuccessState extends ProfileActionState {}

class ConfirmDeliveryDialogState extends ProfileActionState {
  final String orderId;
  final String userId;
  ConfirmDeliveryDialogState({
    required this.orderId,
    required this.userId,
  });
}

class DeliveryConfirmedState extends ProfileActionState {}

class NotificationButtonClickedState extends ProfileActionState {}

class NotificationSentState extends ProfileActionState {}

class CouponAddedState extends ProfileActionState {}
