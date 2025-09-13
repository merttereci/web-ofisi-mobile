import 'package:flutter/material.dart';
import '../profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
