import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/features/order/widgets/past_order_card_large.dart';

class PastOrderPage extends StatefulWidget {
  const PastOrderPage({super.key});

  @override
  State<PastOrderPage> createState() => _PastOrderPageState();
}

class _PastOrderPageState extends State<PastOrderPage> {
  final OrderBloc orderBloc = OrderBloc();
  final CartBloc cartBloc = CartBloc();
  List<dynamic> orderIdList = [];

  @override
  void initState() {
    orderBloc.add(PastOrderInitialEvent());
    fetchPastOrderIds();
    super.initState();
  }

  fetchPastOrderIds() async {
    orderIdList = await OrderRepo.fetchPastOrderIdList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      bloc: orderBloc,
      listenWhen: (previous, current) => current is OrderActionState,
      buildWhen: (previous, current) => current is! OrderActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case PastOrderFetchingState:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case PastOrderLoadedSuccessState:
            final successState = state as PastOrderLoadedSuccessState;

            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(getScreenWidth(context) * 0.06),
                        child: Text(
                          'Your Past orders!',
                          style: GoogleFonts.publicSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: getScreenWidth(context) * 0.05,
                          ),
                        ),
                      ),

                       SizedBox(
                          height: getScreenheight(context) * 2,
                          child: ListView.builder(
                            itemCount: successState.orders.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, indexU) {
                              return PastOrderCardLarge(
                                orderIdlist: orderIdList,
                                successState: successState,
                                bloc: orderBloc,
                                indexU: indexU,
                              );
                            },
                          ),
                        ),

                      // outer listview
                    ],
                  ),
                )));

          default:
            return const Scaffold();
        }
      },
    );
  }
}
