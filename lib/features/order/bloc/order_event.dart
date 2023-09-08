// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class OrderInitialEvent extends OrderEvent {}

class PastOrderInitialEvent extends OrderEvent {}

class CancelOrderEvent extends OrderEvent {
  final String orderId;
  CancelOrderEvent({
    required this.orderId,
  });
}

class ConfirmCancelOrderEvent extends OrderEvent {
  final String orderId;
  ConfirmCancelOrderEvent({
    required this.orderId,
  });
}


