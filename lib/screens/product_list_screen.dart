import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/screens/favorites_screen.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_modal_widget.dart';
import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/product_lists_widgets/compact_search_widget.dart';
import '../widgets/product_lists_widgets/product_card.dart';
import '../widgets/product_lists_widgets/pagination_widget.dart';
import '../widgets/product_lists_widgets/loading_widget.dart';
import '../widgets/product_lists_widgets/error_widget.dart';

class ProductListScreen extends StatefulWidget {
  final VoidCallback? onShowCategoryModal;

  const ProductListScreen({Key? key, this.onShowCategoryModal})
      : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.loadProducts();

      final userProvider = context.read<UserProvider>();
      if (userProvider.isLoggedIn && userProvider.currentUser != null) {
        context
            .read<FavoritesProvider>()
            .loadFavorites(userProvider.currentUser!.id);
      }
    });
    _productProvider.addListener(_scrollToTopOnStateChange);
  }

  void _scrollToTopOnStateChange() {
    if (_scrollController.hasClients && _scrollController.offset != 0.0) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productProvider.removeListener(_scrollToTopOnStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          child: Image.asset(
            'assets/logo/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Web Ofisi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF667eea),
                ),
              );
            },
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return IconButton(
                onPressed: () {
                  CartModalWidget.show(context);
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                    if (cartProvider.isNotEmpty)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Consumer2<FavoritesProvider, UserProvider>(
            builder: (context, favoritesProvider, userProvider, child) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                    if (userProvider.isLoggedIn &&
                        favoritesProvider.favoriteCount > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${favoritesProvider.favoriteCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Column(
              children: [
                CompactSearchWidget(
                  onShowCategoryModal: widget.onShowCategoryModal,
                ),
                Expanded(
                  child: productProvider.isLoading
                      ? LoadingWidget()
                      : productProvider.errorMessage.isNotEmpty
                          ? Error1Widget(
                              message: productProvider.errorMessage,
                              onRetry: () => productProvider.loadProducts(),
                            )
                          : productProvider.displayedProducts.isEmpty &&
                                  productProvider.searchQuery.isNotEmpty
                              ? Error1Widget(
                                  message: productProvider.errorMessage,
                                  onRetry: () => productProvider.loadProducts(),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await productProvider.loadProducts();
                                  },
                                  color: const Color(0xFF667eea),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          padding: const EdgeInsets.all(16.0),
                                          itemCount: productProvider
                                              .displayedProducts.length,
                                          itemBuilder: (context, index) {
                                            return ProductCard(
                                              product: productProvider
                                                  .displayedProducts[index],
                                            );
                                          },
                                        ),
                                      ),
                                      PaginationWidget(),
                                    ],
                                  ),
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
