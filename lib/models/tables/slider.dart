import 'package:flutter/material.dart';

class TabloSlider {
  final int id;
  final int sira;
  final String adi;
  final String resim;
  final int durum;
  final DateTime tarih;

  TabloSlider({
    required this.id,
    required this.sira,
    required this.adi,
    required this.resim,
    required this.durum,
    required this.tarih,
  });

  factory TabloSlider.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateString(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        return null;
      }
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        debugPrint('Tarih ayrıştırma hatası: $e - $dateStr');
        return null;
      }
    }

    return TabloSlider(
      id: json['id'] as int,
      sira: json['sira'] as int,
      adi: json['adi'] as String,
      resim: json['resim'] as String,
      durum: json['durum'] as int,
      tarih: parseDateString(json['tarih'] as String?)!,
    );
  }
}
