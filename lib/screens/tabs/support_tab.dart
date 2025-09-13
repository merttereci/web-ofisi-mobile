// lib/screens/tabs/support_tab.dart
import 'package:flutter/material.dart';
import '../support_screen.dart';

class SupportTab extends StatelessWidget {
  const SupportTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/support':
            return MaterialPageRoute(
              builder: (context) => const SupportScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SupportScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
