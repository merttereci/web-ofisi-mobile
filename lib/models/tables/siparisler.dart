import 'package:flutter/material.dart';

class TabloSiparisler {
  final int id;
  final int uyeid;
  final int scriptid;
  final String ad;
  final String soyad;
  final String email;
  final String telefon;
  final int il;
  final int ilce;
  final String adres;
  final String tc;
  final String firmaadi;
  final String vergino;
  final String vergidairesi;
  final String? firma_tel;
  final String? firma_adres;
  final String kodu;
  final int bonus;
  final String scriptadi;
  final String seo;
  final String tutar;
  final String fiyati;
  final String resim;
  final String odeme;
  final String havale;
  final String domain;
  final String lisans;
  final int? lisanstip; //default 0
  final String surum;
  final String mesaj;
  final int durum;
  final String ip;
  final String ay;
  final String ktarih;
  final String tarih;
  final int kdv;
  final int? vergi; //default 1
  final int? vergioran; //default 18
  final int? fatura; //default 0
  final String? spno;
  final int? paytronay; //default 0
  final DateTime? indirmetarihi; /////
  final String? ftp;
  final int? parasutuyeid; //default 0
  final String? parasut_invoice;
  final String? parasut_invoice_send;
  final int? mailsend; //default 0
  final int? yazilimmailsend; //default 0

  TabloSiparisler({
    required this.id,
    required this.uyeid,
    required this.scriptid,
    required this.ad,
    required this.soyad,
    required this.email,
    required this.telefon,
    required this.il,
    required this.ilce,
    required this.adres,
    required this.tc,
    required this.firmaadi,
    required this.vergino,
    required this.vergidairesi,
    this.firma_tel,
    this.firma_adres,
    required this.kodu,
    required this.bonus,
    required this.scriptadi,
    required this.seo,
    required this.tutar,
    required this.fiyati,
    required this.resim,
    required this.odeme,
    required this.havale,
    required this.domain,
    required this.lisans,
    this.lisanstip = 0,
    required this.surum,
    required this.mesaj,
    required this.durum,
    required this.ip,
    required this.ay,
    required this.ktarih,
    required this.tarih,
    required this.kdv,
    this.vergi = 1,
    this.vergioran = 18,
    this.fatura = 0,
    this.spno,
    this.paytronay = 0,
    this.indirmetarihi,
    this.ftp,
    this.parasutuyeid = 0,
    this.parasut_invoice,
    this.parasut_invoice_send,
    this.mailsend = 0,
    this.yazilimmailsend = 0,
  });

  factory TabloSiparisler.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      try {
        return DateTime.parse(date.toString());
      } catch (e) {
        debugPrint('Tarih ayrıştırma hatası: $e - $date');
        return null;
      }
    }

    return TabloSiparisler(
      id: json['id'] as int,
      uyeid: json['uyeid'] as int,
      scriptid: json['scriptid'] as int,
      ad: json['ad'] as String,
      soyad: json['soyad'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String,
      il: json['il'] as int,
      ilce: json['ilce'] as int,
      adres: json['adres'] as String,
      tc: json['tc'] as String,
      firmaadi: json['firmaadi'] as String,
      vergino: json['vergino'] as String,
      vergidairesi: json['vergidairesi'] as String,
      firma_tel: json['firma_tel'] as String?,
      firma_adres: json['firma_adres'] as String?,
      kodu: json['kodu'] as String,
      bonus: json['bonus'] as int,
      scriptadi: json['scriptadi'] as String,
      seo: json['seo'] as String,
      tutar: json['tutar'] as String,
      fiyati: json['fiyati'] as String,
      resim: json['resim'] as String,
      odeme: json['odeme'] as String,
      havale: json['havale'] as String,
      domain: json['domain'] as String,
      lisans: json['lisans'] as String,
      lisanstip: json['lisanstip'] as int?,
      surum: json['surum'] as String,
      mesaj: json['mesaj'] as String,
      durum: json['durum'] as int,
      ip: json['ip'] as String,
      ay: json['ay'] as String,
      ktarih: json['ktarih'] as String,
      tarih: json['tarih'] as String,
      kdv: json['kdv'] as int,
      vergi: json['vergi'] as int?,
      vergioran: json['vergioran'] as int?,
      fatura: json['fatura'] as int?,
      spno: json['spno'] as String?,
      paytronay: json['paytronay'] as int?,
      indirmetarihi: parseDate(json['indirmetarihi']),
      ftp: json['ftp'] as String?,
      parasutuyeid: json['parasutuyeid'] as int?,
      parasut_invoice: json['parasut_invoice'] as String?,
      parasut_invoice_send: json['parasut_invoice_send'] as String?,
      mailsend: json['mailsend'] as int?,
      yazilimmailsend: json['yazilimmailsend'] as int?,
    );
  }
}
