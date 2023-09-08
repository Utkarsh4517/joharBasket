import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/widgets/profile_order_card_large.dart';
import 'package:lottie/lottie.dart';

class ProfileOrderPage extends StatefulWidget {
  const ProfileOrderPage({super.key});

  @override
  State<ProfileOrderPage> createState() => _ProfileOrderPageState();
}

class _ProfileOrderPageState extends State<ProfileOrderPage> {
  final ProfileBloc profileBloc = ProfileBloc();
  List<dynamic> orderIdList = [];

  @override
  void initState() {
    profileBloc.add(ProfilePageOrderInitialEvent());
    fetchOrderIds();
    super.initState();
  }

  fetchOrderIds() async {
    orderIdList = await ProfileRepo.fetchOrderIdList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case OrderPageFetchingState:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case OrderIsEmptyState:
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: getScreenheight(context) * 0.1),
                    Center(
                      child: Lottie.asset('assets/svgs/empty_orders.json'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                      child: Text(
                        'No orders yet',
                        style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: getScreenWidth(context) * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

          case ProfileOrderLoadedSuccessState:
            final successState = state as ProfileOrderLoadedSuccessState;

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 248, 248, 248),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: successState.orders.length,
                  itemBuilder: (context, indexU) {
                    return ProfileOrderCardLarge(
                      orderIdList: orderIdList,
                      successState: successState,
                      bloc: profileBloc,
                      indexU: indexU,
                    );
                  },
                ),
              ),
            );

          default:
            return Container();
        }
      },
    );
  }
}
