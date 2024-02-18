import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:johar/features/auth/bloc/auth_bloc.dart';
import 'package:johar/features/auth/ui/auth_loading_page.dart';
import 'package:johar/features/auth/ui/google_login_page.dart';
import 'package:johar/features/auth/ui/user_details_page.dart';
import 'package:johar/features/nav_bar/bloc/nav_bar_bloc.dart';
import 'package:johar/features/nav_bar/ui/nav_bar.dart';
import 'package:johar/features/on_boarding/ui/on_boarding_screen.dart';
import 'package:upgrader/upgrader.dart';

class RouteGenerator {
  final NavBarBloc navigationBloc = NavBarBloc();
  final AuthBloc authBloc = AuthBloc();
  Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NavBarBloc>.value(
            value: navigationBloc,
            child: UpgradeAlert(child: const NavBar()),
          ),
        );

      case 'onboarding':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NavBarBloc>.value(
            value: navigationBloc,
            child: const OnBoardingScreen(),
          ),
        );
      case 'googleSignIn':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NavBarBloc>.value(
            value: navigationBloc,
            child: const GoogleLoginPage(),
          ),
        );
      case 'userDetailsPage':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NavBarBloc>.value(
            value: navigationBloc,
            child: const UserDetailsPage(),
          ),
        );
      case 'authLoadingPage':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: const AuthLoadingPage(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('Error')),
      );
    });
  }
}
