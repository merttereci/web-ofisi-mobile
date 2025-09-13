class TabloKategoriler {
  final int id;
  final String adi;
  final String? title;
  final String seo;
  final String keywords;
  final String description;
  final int durum;
  final int yazilim_kat;
  final int? vip; //default 0
  final String tarih;

  TabloKategoriler({
    required this.id,
    required this.adi,
    this.title,
    required this.seo,
    required this.keywords,
    required this.description,
    required this.durum,
    required this.yazilim_kat,
    this.vip = 0,
    required this.tarih,
  });

  factory TabloKategoriler.fromJson(Map<String, dynamic> json) {
    return TabloKategoriler(
      id: json['id'] as int,
      adi: json['adi'] as String,
      title: json['title'] as String?,
      seo: json['seo'] as String,
      keywords: json['keywords'] as String,
      description: json['description'] as String,
      durum: json['durum'] as int,
      yazilim_kat: json['yazilim_kat'] as int,
      vip: json['vip'] as int?,
      tarih: json['tarih'] as String,
    );
  }
}
