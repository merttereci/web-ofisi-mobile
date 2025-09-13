import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/faq_item.dart';

class FaqService {
  static Future<List<FaqItem>> loadFaqItems() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/faq_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> faqItemsJson = jsonData['faq_items'];

      return faqItemsJson.map((json) => FaqItem.fromJson(json)).toList();
    } catch (e) {
      print('FAQ yüklenirken hata: $e');
      return [];
    }
  }

  // Arama fonksiyonu (gelecekte kullanılabilir)
  static List<FaqItem> searchFaqItems(List<FaqItem> items, String query) {
    if (query.isEmpty) return items;

    final lowercaseQuery = query.toLowerCase();
    return items.where((item) {
      return item.question.toLowerCase().contains(lowercaseQuery) ||
          item.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
