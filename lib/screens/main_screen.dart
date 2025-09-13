import 'package:flutter/material.dart';
import 'package:web_ofisi_mobile/widgets/product_lists_widgets/category_selector_modal.dart';
import 'package:web_ofisi_mobile/widgets/custom_bottom_navbar.dart';
import 'tabs/home_tab.dart';
import 'tabs/products_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/hosting_tab.dart';
import 'tabs/support_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategorySelectorModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(onTabChange: _changeTab),
          ProductsTab(onShowCategoryModal: _showCategoryModal),
          const HostingTab(),
          const SupportTab(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
