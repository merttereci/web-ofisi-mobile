import '../models/hosting_cart_item.dart';
import '../models/tables/uyeler.dart';
import '../models/product.dart';

class OrderData {
  final List<int> scriptIds;
  final List<HostingCartItem> hostingItems;
  final TabloUyeler user;
  final List<Product> allProducts; // Script detayları için, ilkel yöntem biraz

  final double scriptSubtotal;
  final double kdvAmount;
  final double hostingTotal;
  final double grandTotal;

  OrderData({
    required this.scriptIds,
    required this.hostingItems,
    required this.user,
    required this.allProducts,
    required this.scriptSubtotal,
    required this.kdvAmount,
    required this.hostingTotal,
    required this.grandTotal,
  });

  factory OrderData.fromProviders({
    required List<int> scriptIds,
    required List<HostingCartItem> hostingItems,
    required TabloUyeler user,
    required List<Product> allProducts,
    required double scriptSubtotal,
    required double kdvAmount,
    required double hostingTotal,
    required double grandTotal,
  }) {
    return OrderData(
      scriptIds: scriptIds,
      hostingItems: hostingItems,
      user: user,
      allProducts: allProducts,
      scriptSubtotal: scriptSubtotal,
      kdvAmount: kdvAmount,
      hostingTotal: hostingTotal,
      grandTotal: grandTotal,
    );
  }

  List<Map<String, dynamic>> toScriptOrders() {
    return scriptIds.map((scriptId) {
      try {
        final product = allProducts.firstWhere((p) => p.id == scriptId);
        final now = DateTime.now();
        //şimdilik böyle
        final spno =
            'SP${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${scriptId}_${user.id}';

        return {
          // ID otomatik atanacak (JSON server)
          'uyeid': user.id,
          'scriptid': scriptId,
          'ad': user.ad ?? '',
          'soyad': user.soyad ?? '',
          'email': user.email ?? '',
          'telefon': user.telefon ?? '',
          'il': _parseIntSafely(user.il),
          'ilce': _parseIntSafely(user.ilce),
          'adres': user.adres ?? '',
          'tc': user.tc ?? '',
          'firmaadi': user.firmaadi ?? '',
          'vergino': user.vergino ?? '',
          'vergidairesi': user.vergidairesi ?? '',
          'firma_tel': user.firma_tel ?? '',
          'firma_adres': user.firma_adres ?? '',
          'kodu': product.code,
          'bonus': 0, //şimdilik bilinmiyor
          'scriptadi': product.name,
          'seo': '', //şimdilik bilinmiyor
          'tutar': (product.price * 1.20).toStringAsFixed(2), // KDV dahil
          'fiyati': product.price.toStringAsFixed(2), // KDV hariç
          'resim': product.image,
          'odeme': 'beklemede', // PayTr entegrasyonu sonrası güncellenecek
          'havale': '',

          ///şimdilik bilinmiyor
          'domain': '', // Kullanıcı sonradan girecek
          'lisans': '', // Kullanıcı sonradan girecek
          'lisanstip': 0,
          'surum': '', //şimdilik bilinmiyor
          'mesaj': 'Mobil uygulama üzerinden sipariş verildi',
          'durum': 0, //şimdilik 0 dedim bilmiyorum
          'ip': '127.0.0.1', // Mock için
          'ay': now.month.toString().padLeft(2, '0'),
          'ktarih':
              '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}',
          'tarih': now.toString(),
          'kdv': 20,
          'vergi': user.vergi ?? 1,
          'vergioran': 20,
          'fatura': user.vergi == 1 ? 1 : 0,
          'spno': spno,
          'paytronay': 0, // PayTr onayı alanı
          'indirmetarihi': null,
          'ftp': null,
          'parasutuyeid': user.parasutuyeid ?? 0,
          'parasut_invoice': null,
          'parasut_invoice_send': null,
          'mailsend': 0,
          'yazilimmailsend': 0,
        };
      } catch (e) {
        throw Exception('Script bulunamadı: $scriptId');
      }
    }).toList();
  }

  List<Map<String, dynamic>> toHostingOrders() {
    return hostingItems.map((hosting) {
      final now = DateTime.now();
      final startDate = now.toString().split(' ')[0]; // YYYY-MM-DD format
      final renewalDate = DateTime(now.year + hosting.years, now.month, now.day)
          .toString()
          .split(' ')[0];
      final endDate = DateTime(now.year + hosting.years, now.month, now.day - 1)
          .toString()
          .split(' ')[0];

      return {
        // ID otomatik atanacak (JSON server)
        'uyeid': user.id,
        'paketadi': hosting.packageName,
        'periyod': '${hosting.years} yıl',
        'sunucu': '0', // Default sunucu
        'domain': hosting.formattedDomain,
        'username': '',
        'baslangic': startDate,
        'yenileme': renewalDate,
        'bitis': endDate,
        'durum': 0,
        'hdurum': null,
        'aciklama':
            'Mobil uygulama üzerinden sipariş verildi - ${hosting.packageName}',
        'tarih': now.toString(),
        'mailtarih': null,
        'smstarih': null,
        'mail': 0,
        'sms': null,
        'paytronay': 0,
      };
    }).toList();
  }

  int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return 0;
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Sipariş özeti
  Map<String, dynamic> getOrderSummary() {
    return {
      'script_count': scriptIds.length,
      'hosting_count': hostingItems.length,
      'total_items': scriptIds.length + hostingItems.length,
      'script_subtotal': scriptSubtotal,
      'kdv_amount': kdvAmount,
      'hosting_total': hostingTotal,
      'grand_total': grandTotal,
      'user_name': '${user.ad} ${user.soyad}',
      'user_email': user.email,
    };
  }

  // Debug için string
  @override
  String toString() {
    return 'OrderData{scripts: ${scriptIds.length}, hosting: ${hostingItems.length}, total: ${grandTotal}₺}';
  }
}
