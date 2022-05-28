import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';

import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => const BottomBar(),
      );
    case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => const AccountScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: Text('Unknown route: ${routeSettings.name}'),
          ),
        ),
      );
  }
}
