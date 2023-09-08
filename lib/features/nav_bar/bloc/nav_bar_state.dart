part of 'nav_bar_bloc.dart';

@immutable
sealed class NavBarState {
  final int tabIndex;

  const NavBarState({required this.tabIndex});
}

final class NavBarInitial extends NavBarState {
  const NavBarInitial({required super.tabIndex});
}
