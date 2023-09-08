import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:johar/features/profile/repo/profile_repo.dart';
import 'package:johar/features/profile/widgets/delivered_order_card_large.dart';
import 'package:johar/features/profile/widgets/stats_card.dart';

class ProfileStatsPage extends StatefulWidget {
  const ProfileStatsPage({super.key});

  @override
  State<ProfileStatsPage> createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage> {
  final ProfileBloc profileBloc = ProfileBloc();
  List<dynamic> orderIdList = [];

  dynamic deliveredOrders = 0;
  dynamic pendingOrders = 0;
  dynamic cancelledOrders = 0;
  dynamic totalAmount = 0;

  @override
  void initState() {
    profileBloc.add(StatsPageInitialEvent());
    fetchDetails();
    fetchOrderIds();
    super.initState();
  }

  fetchOrderIds() async {
    orderIdList = await ProfileRepo.fetchPastOrderIdList();
  }

  fetchDetails() async {
    final deliveredOrdersLength = await ProfileRepo.getDeliveredOrdersLength();
    final pendingOrdersLength = await ProfileRepo.getPendingOrdersLength();
    final cancelledOrdersLength = await ProfileRepo.getCancelledOrdersLength();
    final amount = await ProfileRepo.getTotalSales();
    if (mounted) {
      setState(() {
        deliveredOrders = deliveredOrdersLength;
        pendingOrders = pendingOrdersLength;
        cancelledOrders = cancelledOrdersLength;
        totalAmount = amount;
      });
    }
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
          case StatsPageFetchingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case StatsPageOrderDeliveredSuccessState:
            final successState = state as StatsPageOrderDeliveredSuccessState;
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            StatsCard(
                                text: 'Total Orders Deliverd!',
                                color: Colors.blueAccent,
                                data: '$deliveredOrders'),
                            StatsCard(
                                text: 'Total Sales',
                                color: Colors.cyan,
                                data: '₹$totalAmount',
                                sizeFactor: 0.06),
                            StatsCard(
                                text: 'Total Pending Orders!',
                                color: Colors.orange,
                                data: '$pendingOrders'),
                            StatsCard(
                                text: 'Total Cancelled Orders!',
                                color: Colors.red,
                                data: '$cancelledOrders'),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: getScreenWidth(context) * 0.04,
                              horizontal: getScreenWidth(context) * 0.07),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Delivered Orders',
                            style: GoogleFonts.publicSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: getScreenWidth(context) * 0.04,
                            ),
                          ),
                        ),
                        // Show Delivered Orders
                        SizedBox(
                          height: getScreenheight(context) * 0.5,
                          child: ListView.builder(
                            itemCount: successState.orders.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, indexU) {
                              return ProfileDeliveredOrderCardLarge(
                                orderIdlist: orderIdList,
                                successState: successState,
                                bloc: profileBloc,
                                indexU: indexU,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: getScreenWidth(context) * 0.3),
                      ],
                    ),
                  ),
                ));

          default:
            return const Scaffold();
        }
      },
    );
  }
}
