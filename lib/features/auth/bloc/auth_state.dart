part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

abstract class AuthActionState extends AuthState {}

class AuthInitial extends AuthState {}

class AuthCheckingState extends AuthState {}

class UserDoesNotExistState extends AuthActionState {}

class UserAlreadyExistState extends AuthActionState {}
