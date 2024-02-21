import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenheight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidthPercentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * percentage ;
}

double getScreenHeightPercentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * percentage ;
}
