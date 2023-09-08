// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

abstract class OrderActionState extends OrderState {}

final class OrderInitial extends OrderState {}

class OrderFetchingState extends OrderState {}

class NoOrderExistState extends OrderState {}

class OrderLoadedSuccessState extends OrderState {
  final List<List<ProductDataModel>> orders;
  OrderLoadedSuccessState({
    required this.orders,
  });
}

class OrderIsEmptyState extends OrderState {}

class OrderPageShowCancenOrderDialogBoxState extends OrderActionState {
  final String orderId;
  OrderPageShowCancenOrderDialogBoxState({
    required this.orderId,
  });
}

class ConfirmCancelOrderLoadingState extends OrderActionState {}

class OrderCancelSuccessfulState extends OrderActionState {}

class PastOrderFetchingState extends OrderState {}

class PastOrderLoadedSuccessState extends OrderState {
  final List<List<ProductDataModel>> orders;
  PastOrderLoadedSuccessState({
    required this.orders,
  });
}
