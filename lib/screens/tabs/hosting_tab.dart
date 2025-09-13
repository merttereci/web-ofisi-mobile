import 'package:flutter/material.dart';
import '../hosting_screen.dart';

class HostingTab extends StatelessWidget {
  const HostingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/hosting':
            return MaterialPageRoute(
              builder: (context) => const HostingScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HostingScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
