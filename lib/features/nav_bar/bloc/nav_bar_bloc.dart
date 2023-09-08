// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nav_bar_event.dart';
part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarInitial(tabIndex: 0)) {
    on<TabChangeEvent>(tabChangeEvent);
  }

  FutureOr<void> tabChangeEvent(
      TabChangeEvent event, Emitter<NavBarState> emit) {
    emit(NavBarInitial(tabIndex: event.tabIndex));
  }
}
