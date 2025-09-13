import 'package:flutter/material.dart';
import '../product_list_screen.dart';
import '../product_detail_screen.dart';

class ProductsTab extends StatelessWidget {
  final VoidCallback? onShowCategoryModal;

  const ProductsTab({Key? key, this.onShowCategoryModal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/products':
            return MaterialPageRoute(
              builder: (context) => ProductListScreen(
                onShowCategoryModal: onShowCategoryModal,
              ),
              settings: settings,
            );
          case '/product-detail':
            // ürün detay sayfası için parametre geçişi
            final args = settings.arguments;
            if (args != null && args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: args['product'],
                ),
                settings: settings,
              );
            }
            // parametre yoksa ürün listesine dön
            return MaterialPageRoute(
              builder: (context) => ProductListScreen(
                onShowCategoryModal: onShowCategoryModal,
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => ProductListScreen(
                onShowCategoryModal: onShowCategoryModal,
              ),
              settings: settings,
            );
        }
      },
    );
  }
}
