import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/screens/checkout_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scriptler
                      if (cartProvider.scriptItemCount > 0) ...[
                        _buildSectionHeader(
                          'Web Scriptleri (${cartProvider.scriptItemCount})',
                          Icons.code,
                        ),
                        const SizedBox(height: 12),
                        ..._buildScriptItems(
                            context, cartProvider, productProvider),
                        if (cartProvider.hostingItemCount > 0)
                          const SizedBox(height: 20),
                      ],

                      // Hostingler
                      if (cartProvider.hostingItemCount > 0) ...[
                        _buildSectionHeader(
                          'Hosting Hizmetleri (${cartProvider.hostingItemCount})',
                          Icons.dns,
                        ),
                        const SizedBox(height: 12),
                        ..._buildHostingItems(context, cartProvider),
                      ],
                    ],
                  ),
                ),
              ),
              _buildTotalBar(context, cartProvider, productProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sepetiniz Boş',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Henüz sepetinizde ürün bulunmuyor.\nAlışverişe başlamak için ürünler\nveya hosting sekmesini ziyaret edin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Alışverişe Başla'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF667eea), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScriptItems(
    BuildContext context,
    CartProvider cartProvider,
    ProductProvider productProvider,
  ) {
    final cartProducts =
        cartProvider.getCartProducts(productProvider.allProducts);

    return cartProducts
        .map((product) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Ürün resmi
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: product.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.code,
                                    color: Colors.grey[400]);
                              },
                            ),
                          )
                        : Icon(Icons.code, color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 12),

                  // Ürün bilgileri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kod: ${product.code}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.price.toStringAsFixed(0)}₺ + KDV',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => cartProvider.removeFromCart(product.id),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[600],
                    ),
                    tooltip: 'Sepetten Çıkar',
                  ),
                ],
              ),
            ))
        .toList();
  }

  List<Widget> _buildHostingItems(
      BuildContext context, CartProvider cartProvider) {
    return cartProvider.hostingItems
        .map((hostingItem) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Hosting icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.dns,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Hosting info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hostingItem.packageName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hostingItem.formattedDomain,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              hostingItem.durationText,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(' • ',
                                style: TextStyle(color: Colors.grey[400])),
                            Text(
                              '${hostingItem.totalPrice}₺ (KDV Dahil)',
                              style: TextStyle(
                                color: const Color(0xFF667eea),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => cartProvider.removeHostingFromCart(
                      hostingItem.packageId,
                      hostingItem.domain,
                    ),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[600],
                    ),
                    tooltip: 'Sepetten Çıkar',
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildTotalBar(
    BuildContext context,
    CartProvider cartProvider,
    ProductProvider productProvider,
  ) {
    final scriptSubtotal =
        cartProvider.getScriptSubtotal(productProvider.allProducts);
    final scriptKdv =
        cartProvider.getScriptKdvAmount(productProvider.allProducts);
    final hostingTotal = cartProvider.getHostingTotalAmount();
    final grandTotal = cartProvider.getGrandTotal(productProvider.allProducts);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (cartProvider.scriptItemCount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scriptler (${cartProvider.scriptItemCount} adet):',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${scriptSubtotal.toStringAsFixed(0)}₺',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KDV (%20):',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${scriptKdv.toStringAsFixed(0)}₺',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (cartProvider.hostingItemCount > 0) const SizedBox(height: 4),
          ],
          if (cartProvider.hostingItemCount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hosting (${cartProvider.hostingItemCount} adet):',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${hostingTotal.toStringAsFixed(0)}₺ (KDV Dahil)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Genel Toplam:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${grandTotal.toStringAsFixed(0)}₺',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Sepeti temizle butonu
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    _showClearCartDialog(context, cartProvider);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Temizle'),
                ),
              ),
              const SizedBox(width: 12),
              // Sipariş ver butonu
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    _proceedToCheckout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Sipariş Ver'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sepeti Temizle'),
        content: const Text(
            'Sepetteki tüm ürünleri kaldırmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sepet temizlendi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );
  }
}
