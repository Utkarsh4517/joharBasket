import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:johar/features/auth/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';

class AuthLoadingPage extends StatefulWidget {
  const AuthLoadingPage({super.key});

  @override
  State<AuthLoadingPage> createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends State<AuthLoadingPage> {
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc.add(AuthInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionState,
      buildWhen: (previous, current) => current is! AuthActionState,
      listener: (context, state) {
        if (state is UserDoesNotExistState) {
          Navigator.pushReplacementNamed(context, 'userDetailsPage');
        } else if (state is UserAlreadyExistState) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthCheckingState:
            return Scaffold(
              body: Center(
                child: Lottie.asset('assets/svgs/animation.json'),
              ),
            );

          default:
            return const Scaffold();
        }
      },
    );
  }
}
