import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';
import 'package:johar/features/cart/ui/cart_page.dart';
import 'package:johar/features/cosmetics/ui/cosmetics_page.dart';
import 'package:johar/features/grocery/ui/grocery_page.dart';
import 'package:johar/features/home/ui/home_page.dart';
import 'package:johar/features/nav_bar/bloc/nav_bar_bloc.dart';
import 'package:johar/features/order/ui/order_page.dart';
import 'package:johar/features/pooja/ui/pooja_page.dart';
import 'package:johar/features/stationary/ui/stationary_page.dart';
import 'package:johar/features/user_profile/ui/user_profile.dart';

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
            FontAwesomeIcons.bagShopping,
            color: Colors.green,
          ),
          label: 'Shop'),
      // const BottomNavigationBarItem(
      //     icon: Icon(
      //       FontAwesomeIcons.book,
      //     ),
      //     label: 'Stationary'),
      // const BottomNavigationBarItem(
      //     icon: Icon(
      //       FontAwesomeIcons.gem,
      //     ),
      //     label: 'Cosmetics'),
      // const BottomNavigationBarItem(
      //     icon: Icon(
      //       Icons.sunny,
      //     ),
      //     label: 'Pooja'),
      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.shoppingCart,
            color: Colors.green,
          ),
          label: 'Cart'),

      // change orders to profile
      // const BottomNavigationBarItem(
      //     icon: Icon(
      //       FeatherIcons.shoppingBag,
      //       color: Colors.green,
      //     ),
      //     label: 'Orders'),

      const BottomNavigationBarItem(
          icon: Icon(
            FeatherIcons.user,
            color: Colors.green,
          ),
          label: 'Profile'),
    ];

    const List<Widget> bottomNavScreen = <Widget>[
      HomePage(),
      // StationaryPage(),
      // CosmeticsPage(),
      // PoojaPage(),
      CartPage(),
      // OrderPage(),
      UserProfilePage()
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
            margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: getScreenheight(context) * 0.02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                items: bottomNavItems,
                currentIndex: state.tabIndex,
                selectedItemColor: orangeColor,
                // unselectedItemColor: Colors.white,
                elevation: 10,
                selectedFontSize: 12,
                unselectedFontSize: 10,
                type: BottomNavigationBarType.fixed,
                // selectedItemColor: blackColor,
                unselectedItemColor: Color.fromARGB(255, 199, 199, 199).withAlpha(95),
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
