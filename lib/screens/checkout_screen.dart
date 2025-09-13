import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../models/order_model.dart';
import 'payment_placeholder_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text(
          'Sipariş Özeti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.grey[800],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: Consumer3<CartProvider, ProductProvider, UserProvider>(
        builder: (context, cartProvider, productProvider, userProvider, child) {
          if (_isProcessing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sipariş hazırlanıyor...'),
                ],
              ),
            );
          }

          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Sepetiniz Boş',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sipariş vermek için sepetinize ürün ekleyin',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          if (!userProvider.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Giriş Yapmanız Gerekli',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sipariş vermek için giriş yapmalısınız',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Checkout içeriği
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoCard(userProvider.currentUser!),
                      const SizedBox(height: 16),
                      if (cartProvider.scriptItemCount > 0) ...[
                        _buildScriptOrdersCard(cartProvider, productProvider),
                        const SizedBox(height: 16),
                      ],
                      if (cartProvider.hostingItemCount > 0) ...[
                        _buildHostingOrdersCard(cartProvider),
                        const SizedBox(height: 16),
                      ],
                      _buildPriceSummaryCard(cartProvider, productProvider),
                    ],
                  ),
                ),
              ),

              _buildBottomBar(cartProvider, productProvider, userProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Sipariş Sahibi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('${user.ad} ${user.soyad}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(user.email ?? '', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(user.telefon ?? '', style: TextStyle(color: Colors.grey[600])),
          if (user.adres != null && user.adres!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              user.adres!,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil düzenleme özelliği yakında eklenecek'),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Bilgileri Düzenle'),
            style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptOrdersCard(
      CartProvider cartProvider, ProductProvider productProvider) {
    final cartProducts =
        cartProvider.getCartProducts(productProvider.allProducts);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Web Scriptleri (${cartProvider.scriptItemCount})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cartProducts
              .map((product) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: product.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kod: ${product.code}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${product.price.toStringAsFixed(0)}₺',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHostingOrdersCard(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dns, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Hosting Hizmetleri (${cartProvider.hostingItemCount})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cartProvider.hostingItems
              .map((hosting) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple[600],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.dns,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hosting.packageName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hosting.formattedDomain,
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hosting.durationText,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${hosting.totalPrice}₺',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[600],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard(
      CartProvider cartProvider, ProductProvider productProvider) {
    final scriptSubtotal =
        cartProvider.getScriptSubtotal(productProvider.allProducts);
    final kdvAmount =
        cartProvider.getScriptKdvAmount(productProvider.allProducts);
    final hostingTotal = cartProvider.getHostingTotalAmount();
    final grandTotal = cartProvider.getGrandTotal(productProvider.allProducts);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Fiyat Özeti',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (cartProvider.scriptItemCount > 0) ...[
            _buildPriceRow('Scriptler (${cartProvider.scriptItemCount} adet)',
                '${scriptSubtotal.toStringAsFixed(0)}₺'),
            _buildPriceRow('KDV (%20)', '${kdvAmount.toStringAsFixed(0)}₺'),
          ],
          if (cartProvider.hostingItemCount > 0) ...[
            _buildPriceRow('Hosting (${cartProvider.hostingItemCount} adet)',
                '${hostingTotal.toStringAsFixed(0)}₺ (KDV Dahil)'),
          ],
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Genel Toplam:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${grandTotal.toStringAsFixed(0)}₺',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider,
      ProductProvider productProvider, UserProvider userProvider) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toplam Tutar:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
              Text(
                '${cartProvider.totalItemCount} ürün',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Ödeme butonu
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _proceedToPayment(
                        cartProvider,
                        productProvider,
                        userProvider,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Ödemeye Geç',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToPayment(
    CartProvider cartProvider,
    ProductProvider productProvider,
    UserProvider userProvider,
  ) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final orderData = OrderData.fromProviders(
        scriptIds: cartProvider.cartItems.toList(),
        hostingItems: cartProvider.hostingItems,
        user: userProvider.currentUser!,
        allProducts: productProvider.allProducts,
        scriptSubtotal:
            cartProvider.getScriptSubtotal(productProvider.allProducts),
        kdvAmount: cartProvider.getScriptKdvAmount(productProvider.allProducts),
        hostingTotal: cartProvider.getHostingTotalAmount(),
        grandTotal: cartProvider.getGrandTotal(productProvider.allProducts),
      );

      // Payment simulayonu
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PaymentPlaceholderScreen(orderData: orderData),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
