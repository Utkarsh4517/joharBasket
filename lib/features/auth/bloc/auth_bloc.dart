import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:johar/features/auth/service/auth_service.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>(authInitialEvent);
  }

  FutureOr<void> authInitialEvent(
      AuthInitialEvent event, Emitter<AuthState> emit) async {
    emit(
        AuthCheckingState()); // this is not an auth action state hence this will build the ui, this will show loading screen

    // if user exists = true -> emit UserAlreadyExistState
    // if user exists = false -> emit UserDoesNotExistState

    final doesUserExists = await AuthService()
        .doesUserExists(FirebaseAuth.instance.currentUser!.uid);
    if (doesUserExists) {
      emit(UserAlreadyExistState());
    } else {
      emit(UserDoesNotExistState());
    }
  }
}
