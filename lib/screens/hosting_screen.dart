import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/hosting_cart_item.dart';
import '../widgets/cart_modal_widget.dart';
import '../screens/favorites_screen.dart';

class HostingScreen extends StatefulWidget {
  const HostingScreen({Key? key}) : super(key: key);

  @override
  State<HostingScreen> createState() => _HostingScreenState();
}

class _HostingScreenState extends State<HostingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                'Web Ofisi - Hosting',
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
                            '${cartProvider.totalItemCount}',
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
                        'Hosting Hizmetleri',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Güvenilir ve hızlı hosting çözümleri',
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Cloudlinux, Litespeed ve SSD diskli donanımlarla sunduğumuz web hosting hizmetleri ile en üst düzeyde performans sağlamaktadır, tecrübeli ekibimiz ile %99 uptime garantisi verilmektedir.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Linux Web Hosting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildHostingCard(
                    title: 'BASİT HOSTİNG',
                    price: '₺400',
                    period: 'Yıllık Ücret',
                    features: [
                      'Disk Kotası: 1 GB',
                      'Aylık Bant Genişliği: 10 GB',
                      'FTP Hesabı Sayısı: 1',
                      'E-Posta Hesabı: 5',
                    ],
                    color: Colors.grey[600]!,
                    packageId: 'basit',
                  ),
                  const SizedBox(height: 16),
                  _buildHostingCard(
                    title: 'EKONOMİK HOSTİNG',
                    price: '₺550',
                    period: 'Yıllık Ücret',
                    features: [
                      'Disk Kotası: 5 GB',
                      'Aylık Bant Genişliği: 30 GB',
                      'FTP Hesabı Sayısı: 1',
                      'E-Posta Hesabı: 10',
                    ],
                    color: const Color(0xFF1E88E5),
                    popular: true,
                    packageId: 'ekonomik',
                  ),
                  const SizedBox(height: 16),
                  _buildHostingCard(
                    title: 'İDEAL HOSTİNG',
                    price: '₺700',
                    period: 'Yıllık Ücret',
                    features: [
                      'Disk Kotası: 10 GB',
                      'Aylık Bant Genişliği: 50 GB',
                      'FTP Hesabı Sayısı: 3',
                      'E-Posta Hesabı: 10',
                    ],
                    color: Colors.grey[600]!,
                    packageId: 'ideal',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHostingCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required Color color,
    required String packageId,
    bool popular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: popular
            ? Border.all(color: color, width: 2)
            : Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (popular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Text(
                'EN POPÜLER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            feature,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showOrderDialog(packageId, title, price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: popular ? color : Colors.white,
                      foregroundColor: popular ? Colors.white : color,
                      side: popular ? null : BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Sepete Ekle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(
      String packageId, String packageName, String basePrice) {
    String domain = '';
    int? selectedYears;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final int basePriceInt = int.parse(basePrice.replaceAll('₺', ''));
          final int totalPrice =
              selectedYears != null ? basePriceInt * selectedYears! : 0;

          return AlertDialog(
            title: Text(packageName),
            content: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domain Adı:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('www.', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                domain = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'domain-adiniz',
                              border: UnderlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),
                        Text('.com', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Hosting Süresi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(3, (index) {
                      final years = index + 1;
                      final price = basePriceInt * years;
                      return RadioListTile<int>(
                        title: Text('$years Yıl - ₺$price'),
                        value: years,
                        groupValue: selectedYears,
                        onChanged: (value) {
                          setState(() {
                            selectedYears = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedYears != null
                            ? 'Toplam: ₺$totalPrice'
                            : 'Hosting süresi seçiniz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: (domain.isNotEmpty && selectedYears != null)
                    ? () {
                        Navigator.of(context).pop();
                        _addToCart(packageId, packageName, domain,
                            selectedYears!, totalPrice);
                      }
                    : null,
                child: Text('Sepete Ekle'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addToCart(String packageId, String packageName, String domain,
      int years, int totalPrice) {
    final hostingItem = HostingCartItem(
      packageId: packageId,
      packageName: packageName,
      domain: domain,
      years: years,
      basePrice: totalPrice ~/ years,
      totalPrice: totalPrice,
    );
    context.read<CartProvider>().addHostingToCart(hostingItem);
  }
}
