import 'package:flutter/material.dart';
import '../home_screen.dart';

class HomeTab extends StatelessWidget {
  final Function(int)? onTabChange;

  const HomeTab({Key? key, this.onTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/home':
            return MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(onTabChange: onTabChange), // callback
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(onTabChange: onTabChange), // callback
              settings: settings,
            );
        }
      },
    );
  }
}
