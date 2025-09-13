class TabloHostingSiparisler {
  final int id;
  final int? uyeid;
  final String? paketadi;
  final String? periyod;
  final String? sunucu; //default "0"
  final String? domain;
  final String? username;
  final String? baslangic;
  final String? yenileme;
  final String? bitis;
  final int? durum; //default 1
  final int? hdurum;
  final String? aciklama;
  final String? tarih;
  final String? mailtarih;
  final String? smstarih;
  final int? mail; //default 0
  final int? sms;
  final int? paytronay; //default 0

  TabloHostingSiparisler({
    required this.id,
    this.uyeid,
    this.paketadi,
    this.periyod,
    this.sunucu = "0",
    this.domain,
    this.username,
    this.baslangic,
    this.yenileme,
    this.bitis,
    this.durum = 1,
    this.hdurum,
    this.aciklama,
    this.tarih,
    this.mailtarih,
    this.smstarih,
    this.mail = 0,
    this.sms,
    this.paytronay = 0,
  });

  factory TabloHostingSiparisler.fromJson(Map<String, dynamic> json) {
    return TabloHostingSiparisler(
      id: json['id'] as int,
      uyeid: json['uyeid'] as int?,
      paketadi: json['paketadi'] as String?,
      periyod: json['periyod'] as String?,
      sunucu: json['sunucu'] as String?,
      domain: json['domain'] as String?,
      username: json['username'] as String?,
      baslangic: json['baslangic'] as String?,
      yenileme: json['yenileme'] as String?,
      bitis: json['bitis'] as String?,
      durum: json['durum'] as int,
      hdurum: json['hdurum'] as int?,
      aciklama: json['aciklama'] as String?,
      tarih: json['tarih'] as String?,
      mailtarih: json['mailtarih'] as String?,
      smstarih: json['smstarih'] as String?,
      mail: json['mail'] as int?,
      sms: json['sms'] as int?,
      paytronay: json['paytronay'] as int?,
    );
  }
}
