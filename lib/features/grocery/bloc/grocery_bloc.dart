// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:johar/model/grocery_model.dart';
import 'package:johar/features/grocery/repo/grocery_repo.dart';
import 'package:meta/meta.dart';

part 'grocery_event.dart';
part 'grocery_state.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(GroceryInitial()) {
    on<GroceryInitialEvent>(groceryInitialEvent);
    on<GroceryCardClickedEvent>(groceryCardClickedEvent);
    on<GroceryCardCartButtonClickedEvent>(groceryCardCartButtonClickedEvent);
    on<GroceryProductPageAddToCardClickedEvent>(
        groceryProductPageAddToCartClickedEvent);
    on<ProductOptionClickedEvent>(productOptionClickedEvent);
  }

  FutureOr<void> groceryInitialEvent(
      GroceryInitialEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryLoadingState());
    List<ProductDataModel> groceries = await GroceryRepo.fetchGroceries();
    emit(GroceryLoadedSuccessState(products: groceries));
  }

  FutureOr<void> groceryCardClickedEvent(
      GroceryCardClickedEvent event, Emitter<GroceryState> emit) {
    print('Grocery Card Clicked ${event.clickedGrocery.name}');

    // emit action state to navigate to grocery product page
    emit(GroceryCardClickedActionState(product: event.clickedGrocery));
  }

  FutureOr<void> groceryCardCartButtonClickedEvent(
      GroceryCardCartButtonClickedEvent event,
      Emitter<GroceryState> emit) async {
    print('Grocery Card cart button clicked ${event.cartClickedGrocery.name}');

    // write a function here to add this to cart
    await GroceryRepo.addGroceryToCartFromGroceryPage(event.cartClickedGrocery);
    emit(GroceryAddToCartButtonClickedState());
  }

  FutureOr<void> groceryProductPageAddToCartClickedEvent(
      GroceryProductPageAddToCardClickedEvent event,
      Emitter<GroceryState> emit) async {
    print(
        'Add to card button clicked for ${event.addToCartGrocery.name} with quantity = ${event.quantity}');
    await GroceryRepo.addGroceryToCartFromGroceryProductPage(
        event.addToCartGrocery, event.quantity);
    emit(GroceryAddToCartButtonClickedState());
  }

  FutureOr<void> productOptionClickedEvent(
      ProductOptionClickedEvent event, Emitter<GroceryState> emit) {
        print('clicked option is of ${event.selectedProductOption.size}');
        emit(ProductOptionChangedState(productDataModel: event.selectedProductOption));
      }
}
