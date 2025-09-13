import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/providers/cart_provider.dart';
import 'package:web_ofisi_mobile/providers/favorites_provider.dart';
import 'package:web_ofisi_mobile/widgets/product_card_v2.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/flash_card_widget.dart';
import '../widgets/product_lists_widgets/loading_widget.dart';
import '../widgets/product_lists_widgets/error_widget.dart';
import '../widgets/cart_modal_widget.dart';
import '../screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange; // callback

  const HomeScreen({Key? key, this.onTabChange}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();

      final userProvider = context.read<UserProvider>();
      if (userProvider.isLoggedIn && userProvider.currentUser != null) {
        context
            .read<FavoritesProvider>()
            .loadFavorites(userProvider.currentUser!.id);
      }
    });
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.isLoggedIn
                            ? 'Merhaba ${userProvider.currentUser?.ad ?? ""}! ' //kullancı ismine göre dinamik
                            : 'Merhaba!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userProvider.isLoggedIn
                            ? 'İhtiyacınıza uygun hazır yazılımları keşfedin'
                            : 'Projelerinizi keşfetmeye başlayın!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // öne çıkan hizmetler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Öne Çıkan Hizmetlerimiz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  FlashCardWidget(
                    title: 'Güvenli Hazır Site Çözümleri',
                    description:
                        'Gizliliğiniz ve güvenliğiniz bizim için çok önemlidir. Ucuz web sitesi hizmetlerimizle güvenilir ve kaliteli hizmet sunuyoruz.',
                    backgroundColor: Colors.blue[600]!,
                    icon: Icons.security,
                  ),
                  FlashCardWidget(
                    title: 'Profesyonel Geliştirici Ekibi',
                    description:
                        'Deneyimli ve yetenekli ekibimiz, projelerinizde sizlere 7/24 destek sağlamaya hazır.',
                    backgroundColor: Colors.green[600]!,
                    icon: Icons.code,
                  ),
                  FlashCardWidget(
                    title: 'Ekonomik ve Kaliteli Çözümler',
                    description:
                        'Uygun fiyatlı paketlerimizle müşteri memnuniyetini ön planda tutarak, binlerce mutlu müşteriye ulaştık.',
                    backgroundColor: Colors.orange[600]!,
                    icon: Icons.trending_up,
                  ),
                  FlashCardWidget(
                    title: 'Hızlı Teslimat Garantisi',
                    description:
                        'Projelerinizi zamanında ve kaliteli bir şekilde teslim etme garantisi veriyoruz.',
                    backgroundColor: Colors.purple[600]!,
                    icon: Icons.flash_on,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Popüler Ürünlerimiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  // tümünü gör oto geçiş
                  TextButton(
                    onPressed: () {
                      // callback ile ürünler tab'ına geç (index 1)
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1);
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tümünü Gör',
                          style: TextStyle(
                            color: Color(0xFF667eea),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFF667eea),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return Padding(
                    padding: EdgeInsets.all(24.0),
                    child: LoadingWidget(),
                  );
                } else if (productProvider.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Error1Widget(
                      message: productProvider.errorMessage,
                      onRetry: () => productProvider.loadProducts(),
                    ),
                  );
                } else if (productProvider.allProducts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Henüz ürün yüklenmedi',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // ilk 6 ürünü göster, istersek arttırabiliriz
                  final featuredProducts =
                      productProvider.allProducts.take(6).toList();

                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: featuredProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SizedBox(
                            width: 300,
                            child:
                                ProductCardV2(product: featuredProducts[index]),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
