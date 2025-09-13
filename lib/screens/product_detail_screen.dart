import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/product_details_widgets/product_image_gallery.dart';
import '../widgets/product_details_widgets/product_demo_buttons.dart';
import '../widgets/product_details_widgets/product_detail_row.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  void _showSnackBar(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allImages = [product.image, ...product.otherImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageGallery(imageUrls: allImages),
            const SizedBox(height: 24),
            ProductDemoButtons(
              demoUrl: product.demo,
              adminDemoUrl: product.demoAdmin,
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            _buildPriceSection(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildDescriptionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    List<Widget> chips = [];

    // Kategoriler
    for (String category in product.category) {
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: const Color(0xFF667eea),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (product.coding.isNotEmpty) {
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                size: 14,
                color: Colors.orange[700],
              ),
              const SizedBox(width: 4),
              Text(
                product.coding,
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[50]!,
            Colors.green[100]!.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fiyat',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${product.price.toStringAsFixed(0)} ${product.priceUnit}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'KDV Hariç',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Consumer3<CartProvider, FavoritesProvider, UserProvider>(
      builder: (context, cartProvider, favoritesProvider, userProvider, child) {
        final isInCart = cartProvider.isInCart(product.id);
        final isFavorite = favoritesProvider.isFavorite(product.id);
        final isLoggedIn = userProvider.isLoggedIn;

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isInCart
                        ? [Colors.orange[400]!, Colors.orange[600]!]
                        : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isInCart
                              ? Colors.orange[400]!
                              : const Color(0xFF667eea))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    cartProvider.toggleCart(product.id);
                    _showSnackBar(
                      context,
                      isInCart ? 'Sepetten çıkarıldı' : 'Sepete eklendi!',
                      isError: false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    isInCart ? 'Sepetten Çıkar' : 'Sepete Ekle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isFavorite ? Colors.red[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFavorite ? Colors.red[200]! : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  if (!isLoggedIn) {
                    _showSnackBar(
                      context,
                      'Favorilere eklemek için giriş yapmalısınız',
                    );
                    return;
                  }

                  final success = await favoritesProvider.toggleFavorite(
                    userProvider.currentUser!.id,
                    product.id,
                  );

                  if (success) {
                    _showSnackBar(
                      context,
                      isFavorite
                          ? 'Favorilerden çıkarıldı'
                          : 'Favorilere eklendi!',
                      isError: false,
                    );
                  } else {
                    _showSnackBar(
                      context,
                      'Bir hata oluştu, tekrar deneyin',
                    );
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red[600] : Colors.grey[600],
                  size: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: const Color(0xFF667eea),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Teknik Bilgiler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProductDetailRow(title: 'Ürün Kodu:', value: product.code),
          ProductDetailRow(title: 'Kodlama:', value: product.coding),
          ProductDetailRow(title: 'PHP Versiyon:', value: product.phpVersion),
          ProductDetailRow(title: 'URL:', value: product.url),
        ],
      ),
    );
  }

  //normalde phpye göre yazılan açıklama, değişecek bu kısım, şimdilik gerektirsiz karakteri siliyoruz
  Widget _buildDescriptionSection() {
    if (product.description.trim().isEmpty) return const SizedBox.shrink();

    final cleanedDescription =
        product.description.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();

    if (cleanedDescription.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: const Color(0xFF667eea),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Açıklama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            cleanedDescription,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
