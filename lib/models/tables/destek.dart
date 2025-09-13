import 'package:flutter/material.dart';

class TabloDestek {
  final int id;
  final int uye_id;
  final String isim;
  final String email;
  final String baslik;
  final String departman;
  final String oncelik;
  final String hizmet;
  final String tarih;
  final String son_giris;
  final String son_cevap;
  final String son_tarih;
  final String ip;
  final int? durum; //default 0
  final int? cevap_yazan; //default 0
  final String? kisi;
  final String mesaj;
  final String? bilgiler;
  final String? ozet;
  final String? seviye;
  final String? islem_tarih;
  final DateTime? yapim_tarih;

  TabloDestek({
    required this.id,
    required this.uye_id,
    required this.isim,
    required this.email,
    required this.baslik,
    required this.departman,
    required this.oncelik,
    required this.hizmet,
    required this.tarih,
    required this.son_giris,
    required this.son_cevap,
    required this.son_tarih,
    required this.ip,
    this.durum = 0,
    this.cevap_yazan = 0,
    this.kisi,
    required this.mesaj,
    this.bilgiler,
    this.ozet,
    this.seviye,
    this.islem_tarih,
    this.yapim_tarih,
  });

  factory TabloDestek.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateString(dynamic date) {
      if (date == null || date.toString().isEmpty) return null;
      try {
        return DateTime.parse(date.toString());
      } catch (e) {
        debugPrint('Tarih ayrıştırma hatası: $e - $date');
        return null;
      }
    }

    return TabloDestek(
      id: json['id'] as int,
      uye_id: json['uye_id'] as int,
      isim: json['isim'] as String,
      email: json['email'] as String,
      baslik: json['baslik'] as String,
      departman: json['departman'] as String,
      oncelik: json['oncelik'] as String,
      hizmet: json['hizmet'] as String,
      tarih: json['tarih'] as String,
      son_giris: json['son_giris'] as String,
      son_cevap: json['son_cevap'] as String,
      son_tarih: json['son_tarih'] as String,
      ip: json['ip'] as String,
      durum: json['durum'] as int,
      cevap_yazan: json['cevap_yazan'] as int?,
      kisi: json['kisi'] as String?,
      mesaj: json['mesaj'] as String,
      bilgiler: json['bilgiler'] as String,
      ozet: json['ozet'] as String?,
      seviye: json['seviye'] as String?,
      islem_tarih: json['islem_tarih'] as String?,
      yapim_tarih: parseDateString(json['yapim_tarih']),
    );
  }
}
