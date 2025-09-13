class TabloIndirimKuponlari {
  final int id;
  final String kod;
  final String indirim;
  final int durum;
  final String ip;
  final String tarih;

  TabloIndirimKuponlari({
    required this.id,
    required this.kod,
    required this.indirim,
    required this.durum,
    required this.ip,
    required this.tarih,
  });

  factory TabloIndirimKuponlari.fromJson(Map<String, dynamic> json) {
    return TabloIndirimKuponlari(
      id: json['id'] as int,
      kod: json['kod'] as String,
      indirim: json['indirim'] as String,
      durum: json['durum'] as int,
      ip: json['ip'] as String,
      tarih: json['tarih'] as String,
    );
  }
}
