import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderInitialEvent>(orderInitialEvent);
    on<CancelOrderEvent>(cancelOrderEvent);
    on<ConfirmCancelOrderEvent>(confirmCancelOrderEvent);
    on<PastOrderInitialEvent>(pastOrderInitialEvent);
  }

  FutureOr<void> orderInitialEvent(
      OrderInitialEvent event, Emitter<OrderState> emit) async {
    emit(OrderFetchingState());
    List<List<ProductDataModel>> orders = await OrderRepo.fetchCurrentOrders();

    if (orders.isEmpty) {
      emit(OrderIsEmptyState());
    } else if (orders.isNotEmpty) {
      emit(OrderLoadedSuccessState(orders: orders));
    }
  }

  FutureOr<void> cancelOrderEvent(
      CancelOrderEvent event, Emitter<OrderState> emit) {
    emit(OrderPageShowCancenOrderDialogBoxState(orderId: event.orderId));
  }

  FutureOr<void> confirmCancelOrderEvent(
      ConfirmCancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(ConfirmCancelOrderLoadingState());
    // delete order
    await OrderRepo.cancelOrder(event.orderId);
    emit(OrderCancelSuccessfulState());
  }

  FutureOr<void> pastOrderInitialEvent(
      PastOrderInitialEvent event, Emitter<OrderState> emit) async {
    emit(PastOrderFetchingState());
    List<List<ProductDataModel>> orders = await OrderRepo.fetchPastOrders();
    emit(PastOrderLoadedSuccessState(orders: orders));
  }
}
