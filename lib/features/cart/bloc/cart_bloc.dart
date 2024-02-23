// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:johar/features/cart/repo/cart_repo.dart';
import 'package:johar/model/coupon_model.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(cartInitialEvent);
    on<CartBillRefreshEvent>(cartBillRefreshEvent);
    on<CartProductQuantityIncreaseEvent>(cartProductQuantityIncreaseEvent);
    on<CartProductQuantityDecreaseEvent>(cartProductQuantityDecreaseEvent);
    on<CartRemoveProductEvent>(cartRemoveProductEvent);
    on<CartPageUpdateUserAddressClickedEvent>(cartPageUpdateUserAddressClickedEvent);
    on<CartPagePlaceOrderClickedEvent>(cartPagePlaceOrderClickedEvent);
    on<CartPageUpdateUserDetailsClickedEvent>(cartPageUpdateUserDetailsClickedEvent);
    on<CouponCodeApplyClickedEvent>(couponCodeApplyClickedEvent);
  }

  FutureOr<void> cartInitialEvent(CartInitialEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    List<ProductDataModel> products = await CartRepo.fetchProducts();
    if (products.isEmpty) {
      emit(CartIsEmptyState());
    } else if (products.isNotEmpty) {
      emit(CartLoadedSuccessState(products: products));
    }
  }

  FutureOr<void> cartBillRefreshEvent(CartBillRefreshEvent event, Emitter<CartState> emit) async {
    final sum = await CartRepo.calculateSubTotal();
    final sumWithoutDiscount = await CartRepo.calculateTotalWithoutDiscount();
    print('bill refresh');

    emit(CartBillRefreshState(
      sum: sum,
      sumWithoutDiscount: sumWithoutDiscount,
    ));
  }

  FutureOr<void> cartProductQuantityIncreaseEvent(CartProductQuantityIncreaseEvent event, Emitter<CartState> emit) async {
    await CartRepo.increaseQuantity(event.product);
    emit(CartProductQuantityIncreaseState(product: event.product));
  }

  FutureOr<void> cartProductQuantityDecreaseEvent(CartProductQuantityDecreaseEvent event, Emitter<CartState> emit) async {
    await CartRepo.decreaseQuantity(event.product);
    emit(CartProductQuantityDecreaseState(product: event.product));
  }

  FutureOr<void> cartRemoveProductEvent(CartRemoveProductEvent event, Emitter<CartState> emit) async {
    await CartRepo.deleteProduct(event.product);
    emit(CartProductDeletedState(product: event.product));
    print('product deleted');
  }

  FutureOr<void> cartPagePlaceOrderClickedEvent(CartPagePlaceOrderClickedEvent event, Emitter<CartState> emit) async {
    print('Place order CLicked');
    // write a method in cart repo to add product list to order collection with document id = an unique order number
    // loading state
    emit(CartPlacingOrderLoadingState());
    await CartRepo.addProductsToOrder(
      event.products,
      event.amount,
      event.gst,
      event.isPaid,
    );
    emit(CartPagePlaceOrderSuccessfulState());
    // empty the cart...
    await CartRepo.emptyCart();
    emit(CartEmptiedState());
  }

  FutureOr<void> cartPageUpdateUserDetailsClickedEvent(CartPageUpdateUserDetailsClickedEvent event, Emitter<CartState> emit) async {
    emit(CartPlacingOrderLoadingState());
    // cart repo to update user details
    await CartRepo.updateUserDetails(
      firstName: event.firstName,
      lastName: event.lastName,
      mobileNumber: event.mobileNumber,
      // address: event.address,
      // pinCode: event.pincode,
    );
    emit(CartPageUserDetailsUpdatedSuccessState());
  }

  FutureOr<void> couponCodeApplyClickedEvent(CouponCodeApplyClickedEvent event, Emitter<CartState> emit) async {
    final coupon = await CartRepo.verifyCoupon(couponCode: event.couponCode);
    if (coupon != null) {
      emit(CouponVerifedState(couponModel: coupon));
    } else {
      emit(CouponUnverifiedState());
    }
  }

  FutureOr<void> cartPageUpdateUserAddressClickedEvent(CartPageUpdateUserAddressClickedEvent event, Emitter<CartState> emit) async {
    await CartRepo.updateUserAddress(
      pincode: event.pincode,
      address: event.address,
      houseNo: event.houseNo,
      city: event.city,
      landmark: event.landmark,
    );
    emit(CartPageUserDetailsUpdatedSuccessState());
  }
}
