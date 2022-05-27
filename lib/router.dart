import 'package:amazon_clone/features/auth/screens/auth_screen.dart';

import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) => const AuthScreen(),
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
