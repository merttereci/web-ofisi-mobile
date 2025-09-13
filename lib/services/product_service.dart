import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/product.dart';

class ProductService {
  static const String xmlUrl = 'https://web-ofisi.com/urunler.xml';

  static Future<List<Product>> fetchProducts() async {
    try {
      print('XML verisi çekiliyor...');

      final response = await http.get(
        Uri.parse(xmlUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      print('HTTP Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Türkçe karakter sorunları için encoding kontrolü
        String xmlContent = response.body;

        // XML'i parse et
        final document = XmlDocument.parse(xmlContent);

        // Ürünleri bul (XML yapısına göre tag ismi değişebilir)
        final productElements = document.findAllElements('item');

        print('Bulunan ürün sayısı: ${productElements.length}');

        final products = <Product>[];

        for (final element in productElements) {
          try {
            final product = Product.fromXml(element);
            products.add(product);
          } catch (e) {
            print('Ürün parse hatası: $e');
            // Hatalı ürünü atla devam et
          }
        }

        print('Başarıyla parse edilen ürün sayısı: ${products.length}');
        return products;
      } else {
        throw Exception('XML yüklenemedi. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  static Future<void> testXmlConnection() async {
    try {
      final products = await fetchProducts();
      if (products.isNotEmpty) {
        print('Test başarılı!');
        print('İlk ürün: ${products.first}');
        print('Son ürün: ${products.last}');
      }
    } catch (e) {
      print('Test başarısız: $e');
    }
  }
}
