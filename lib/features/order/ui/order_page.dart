import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/bloc/cart_bloc.dart';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/features/order/repo/order_repo.dart';
import 'package:johar/features/order/ui/past_order_page.dart';
import 'package:johar/features/order/widgets/order_card_large.dart';
import 'package:lottie/lottie.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderBloc orderBloc = OrderBloc();
  final CartBloc cartBloc = CartBloc();
  List<dynamic> orderIdList = [];
  List<dynamic> pastOrderIdList = [];

  @override
  void initState() {
    orderBloc.add(OrderInitialEvent());
    fetchOrderIds();
    super.initState();
  }

  fetchOrderIds() async {
    orderIdList = await OrderRepo.fetchOrderIdList();
    pastOrderIdList = await OrderRepo.fetchPastOrderIdList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      bloc: orderBloc,
      listenWhen: (previous, current) => current is OrderActionState,
      buildWhen: (previous, current) => current is! OrderActionState,
      listener: (context, state) {
        if (state is OrderPageShowCancenOrderDialogBoxState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Do you want to cancel this order?'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: GoogleFonts.publicSans(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          orderBloc.add(
                              ConfirmCancelOrderEvent(orderId: state.orderId));
                        },
                        child: Text(
                          'Cancel Order',
                          style: GoogleFonts.publicSans(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        } else if (state is ConfirmCancelOrderLoadingState) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    height: getScreenWidth(context) * 0.2,
                    width: getScreenWidth(context) * 0.2,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              });
        } else if (state is OrderCancelSuccessfulState) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case OrderFetchingState:
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
                        'You have no orders right now',
                        style: GoogleFonts.publicSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: getScreenWidth(context) * 0.04,
                        ),
                      ),
                    ),
                    if (pastOrderIdList.length != 0)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PastOrderPage()));
                        },
                        child: const Text(
                          'View Past Orders',
                        ),
                      ),
                  ],
                ),
              ),
            );

          case OrderLoadedSuccessState:
            final successState = state as OrderLoadedSuccessState;

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 248, 248, 248),
              appBar: AppBar(
                title: Text(
                  'Your orders!',
                  style: GoogleFonts.publicSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: getScreenWidth(context) * 0.05,
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PastOrderPage()));
                      },
                      child: const Text('View Past Orders')),
                ],
              ),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: successState.orders.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, indexU) {
                    return OrderCardLarge(
                      orderIdList: orderIdList,
                      successState: successState,
                      bloc: orderBloc,
                      indexU: indexU,
                    );
                  },
                ),
              ),
            );

          default:
            return const Scaffold();
        }
      },
    );
  }
}
