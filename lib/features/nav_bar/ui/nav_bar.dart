import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/ui/cart_page.dart';
import 'package:johar/features/cosmetics/ui/cosmetics_page.dart';
import 'package:johar/features/grocery/ui/grocery_page.dart';
import 'package:johar/features/nav_bar/bloc/nav_bar_bloc.dart';
import 'package:johar/features/order/ui/order_page.dart';
import 'package:johar/features/stationary/ui/stationary_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.home,
          ),
          label: 'Grocery'),
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.book,
          ),
          label: 'Stationary'),
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.watch,
          ),
          label: 'Cosmetics'),
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.shoppingCart,
          ),
          label: 'Cart'),
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.shoppingBag,
          ),
          label: 'Orders'),
    ];

    const List<Widget> bottomNavScreen = <Widget>[
      GroceryPage(),
      StationaryPage(),
      CosmeticsPage(),
      CartPage(),
      OrderPage(),
    ];
    return BlocConsumer<NavBarBloc, NavBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              context.read<NavBarBloc>().add(TabChangeEvent(tabIndex: index));
            },
            children: bottomNavScreen,
          ),
          bottomNavigationBar: Container(
            color: const Color.fromARGB(255, 248, 248, 248),
            margin: const EdgeInsets.symmetric(horizontal: 20)
                .copyWith(bottom: getScreenheight(context) * 0.02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                backgroundColor: const Color.fromARGB(255, 46, 52, 68),
                items: bottomNavItems,
                currentIndex: state.tabIndex,
                selectedItemColor: Colors.white,
                // unselectedItemColor: Colors.white,
                elevation: 10,
                selectedFontSize: 12,
                unselectedFontSize: 10,
                type: BottomNavigationBarType.fixed,
                // selectedItemColor: blackColor,
                unselectedItemColor: Colors.white.withAlpha(85),
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
