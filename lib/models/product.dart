import 'package:xml/xml.dart';

class Product {
  final int id;
  final String name;
  final String code;
  final String coding;
  final String phpVersion;
  final List<String> category; // birden fazla kategori olabiliyor
  final double price;
  final String priceUnit;
  final String demo;
  final String demoAdmin;
  final String image;
  final List<String> otherImages;
  final String url;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.coding,
    required this.phpVersion,
    required this.category,
    required this.price,
    required this.priceUnit,
    required this.demo,
    required this.demoAdmin,
    required this.image,
    required this.otherImages,
    required this.url,
    required this.description,
  });

  // XML'den Product objesi oluşturmak için factory constructor
  //factory constructor sayesinde Product.fromXml() çağrıldığında
  //önce XML okunur, işlenir, sonra nesne oluşturulur.

  factory Product.fromXml(XmlElement element) {
    String getElementText(String tagName) {
      final elements = element.findElements(tagName);
      return elements.isNotEmpty ? elements.first.text : '';
    }

    // Kategorileri parse et (br ile ayrılmış)
    List<String> parseCategories(String categoriesText) {
      if (categoriesText.isEmpty)
        return [];
      else {
        return categoriesText
            .split('<br>')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    List<String> parseOtherImages(String imagesText) {
      if (imagesText.isEmpty) return [];
      return imagesText.split(',').map((e) => e.trim()).toList();
    }

    double parsePrice(String priceText) {
      if (priceText.isEmpty) return 0.0;
      try {
        return double.parse(priceText);
      } catch (e) {
        return 0.0;
      }
    }

    return Product(
      id: int.tryParse(getElementText('urunid')) ?? 0, //null olmaması için
      name: getElementText('urunadi'),
      code: getElementText('urunkodu'),
      coding: getElementText('kodlama'),
      phpVersion: getElementText('phpversiyon'),
      category:
          parseCategories(getElementText('kategori')), // kategori ayrıştırma
      price: parsePrice(getElementText('fiyat')),
      priceUnit: getElementText('pbirim'),
      demo: getElementText('demo'),
      demoAdmin: getElementText('demo_admin'),
      image: getElementText('resim'),
      otherImages: parseOtherImages(getElementText('diger_resim')),
      url: getElementText('url'),
      description: getElementText('aciklama'),
    );
  }
}
