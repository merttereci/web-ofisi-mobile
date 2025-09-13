class TabloBankaHesaplari {
  final int id;
  final String banka;
  final String hesap;
  final String sube;
  final String hnumara;
  final String iban;
  final String resim;
  final int durum;
  final String tarih;

  TabloBankaHesaplari({
    required this.id,
    required this.banka,
    required this.hesap,
    required this.sube,
    required this.hnumara,
    required this.iban,
    required this.resim,
    required this.durum,
    required this.tarih,
  });

  factory TabloBankaHesaplari.fromJson(Map<String, dynamic> json) {
    return TabloBankaHesaplari(
      id: json['id'] as int,
      banka: json['banka'] as String,
      hesap: json['hesap'] as String,
      sube: json['sube'] as String,
      hnumara: json['hnumara'] as String,
      iban: json['iban'] as String,
      resim: json['resim'] as String,
      durum: json['durum'] as int,
      tarih: json['tarih'] as String,
    );
  }
}
