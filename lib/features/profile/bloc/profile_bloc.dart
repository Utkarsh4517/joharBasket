import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfilePageOrderInitialEvent>(profilePageOrderInitialEvent);
    on<AddProductClickedEvent>(addProductClickedEvent);
    on<ProductEditButtonClickedEvent>(productEditButtonClickedEvent);
    on<ProductUpdateDetailsClickedEvent>(productUpdateDetailsClickedEvent);
    on<ProductDeleteButtonClickedEvent>(productDeleteButtonClickedEvent);
    on<RemoveProductClickedEvent>(removeProductClickedEvent);
    on<AcceptOrderClickedEvent>(acceptOrderClickedEvent);
    on<ConfirmOrderClickedEvent>(confirmOrderClickedEvent);
    on<ShowConfirmDeliveryDialogEvent>(showConfirmDeliveryDialogEvent);
    on<DeliveryConfirmedEvent>(deliveryConfirmedEvent);
    on<StatsPageInitialEvent>(statsPageInitialEvent);
  }

  FutureOr<void> profilePageOrderInitialEvent(
      ProfilePageOrderInitialEvent event, Emitter<ProfileState> emit) async {
    emit(OrderPageFetchingState());
    List<List<ProductDataModel>> orders =
        await ProfileRepo.fetchCurrentOrders();

    if (orders.isEmpty) {
      emit(OrderIsEmptyState());
    } else if (orders.isNotEmpty) {
      emit(ProfileOrderLoadedSuccessState(orders: orders));
    }
  }

  FutureOr<void> addProductClickedEvent(
      AddProductClickedEvent event, Emitter<ProfileState> emit) async {
    await ProfileRepo.addNewProduct(
      collectionName: event.category,
      name: event.name,
      description: event.description,
      imageUrl: event.imageUrl,
      inStock: event.inStock,
      price: event.price,
      gst: event.gst,
      isFeatured: event.isFeatured,
      productId: event.productId,
    );
  }

  FutureOr<void> productEditButtonClickedEvent(
      ProductEditButtonClickedEvent event, Emitter<ProfileState> emit) {
    emit(ProductEditButtonClickedState(product: event.product));
  }

  FutureOr<void> productUpdateDetailsClickedEvent(
      ProductUpdateDetailsClickedEvent event,
      Emitter<ProfileState> emit) async {
    await ProfileRepo.updateProductDetails(
        productDataModel: event.product,
        inStock: event.inStock,
        name: event.name,
        isFeatured: event.isFeatred,
        description: event.description,
        price: event.price,
        gst: event.gst);
    emit(ProductDetailsUpdatedState());
  }

  FutureOr<void> productDeleteButtonClickedEvent(
      ProductDeleteButtonClickedEvent event, Emitter<ProfileState> emit) {
    emit(ShowDeleteDialogState());
  }

  FutureOr<void> removeProductClickedEvent(
      RemoveProductClickedEvent event, Emitter<ProfileState> emit) async {
    await ProfileRepo.deleteProduct(productDataModel: event.productDataModel);
    emit(RemoveDialogState());
  }

  FutureOr<void> acceptOrderClickedEvent(
      AcceptOrderClickedEvent event, Emitter<ProfileState> emit) {
    emit(ProfilePageShowAcceptOrderDialog(
        orderId: event.orderId, userId: event.userId));
  }

  FutureOr<void> confirmOrderClickedEvent(
      ConfirmOrderClickedEvent event, Emitter<ProfileState> emit) async {
    await ProfileRepo.orderAccepted(
        event.userId, event.orderId, event.deliveryTime);
    emit(OrderAcceptedSuccessState());
  }

  FutureOr<void> showConfirmDeliveryDialogEvent(
      ShowConfirmDeliveryDialogEvent event, Emitter<ProfileState> emit) {
    emit(ConfirmDeliveryDialogState(
        orderId: event.orderId, userId: event.userId));
  }

  FutureOr<void> deliveryConfirmedEvent(
      DeliveryConfirmedEvent event, Emitter<ProfileState> emit) async {
    await ProfileRepo.orderDelivered(event.userId, event.orderId);
    emit(DeliveryConfirmedState());
  }

  FutureOr<void> statsPageInitialEvent(
      StatsPageInitialEvent event, Emitter<ProfileState> emit) async {
    emit(StatsPageFetchingState());
    // await
    List<List<ProductDataModel>> orders = await ProfileRepo.fetchPastOrders();
    emit(StatsPageOrderDeliveredSuccessState(orders: orders));
  }
}
