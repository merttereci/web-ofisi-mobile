class TabloScriptler {
  final int id;
  final String kategoriler;
  final String adi;
  final String url;
  final String? admin_url;
  final String seo;
  final String kodu;
  final String ozel_kod;
  final int bonus;
  final double? fiyat;
  final double? full_fiyat;
  final String resim;
  final String kodlama;
  final String? versiyon;
  final String aciklama;
  final String keywords;
  final String description;
  final int coksatanlar;
  final int durum;
  final int? yeni_lisans; //default 0
  final int? uc_nesil; //default 0
  final int? dort_nesil; //default 0
  final int? uzak_lisans; //default 0
  final String tarih;
  final int coksatan2;
  final String? raradi;
  final int? sanal; //default 1
  final int? vip; //default 0
  final int? genis; //default 0

  TabloScriptler(
      {required this.id,
      required this.kategoriler,
      required this.adi,
      required this.url,
      this.admin_url,
      required this.seo,
      required this.kodu,
      required this.ozel_kod,
      required this.bonus,
      this.fiyat,
      this.full_fiyat,
      required this.resim,
      required this.kodlama,
      this.versiyon,
      required this.aciklama,
      required this.keywords,
      required this.description,
      required this.coksatanlar,
      required this.durum,
      this.yeni_lisans = 0,
      this.uc_nesil = 0,
      this.dort_nesil = 0,
      this.uzak_lisans = 0,
      required this.tarih,
      required this.coksatan2,
      this.raradi,
      this.sanal = 1,
      this.vip = 0,
      this.genis = 0 // default 0 denmiş, ama aynı zamanda not nullable,
      });

  factory TabloScriptler.fromJson(Map<String, dynamic> json) {
    return TabloScriptler(
      id: json['id'] as int,
      kategoriler: json['kategoriler'] as String,
      adi: json['adi'] as String,
      url: json['url'] as String,
      admin_url: json['admin_url'] as String?,
      seo: json['seo'] as String,
      kodu: json['kodu'] as String,
      ozel_kod: json['ozel_kod'] as String,
      bonus: json['bonus'] as int,
      fiyat: (json['fiyat'] as num?)?.toDouble(),
      full_fiyat: (json['full_fiyat'] as num?)?.toDouble(),
      resim: json['resim'] as String,
      kodlama: json['kodlama'] as String,
      versiyon: json['versiyon'] as String?,
      aciklama: json['aciklama'] as String,
      keywords: json['keywords'] as String,
      description: json['description'] as String,
      coksatanlar: json['coksatanlar'] as int,
      durum: json['durum'] as int,
      yeni_lisans: json['yeni_lisans'] as int?,
      uc_nesil: json['3nesil'] as int?,
      dort_nesil: json['4nesil'] as int?,
      uzak_lisans: json['uzak_lisans'] as int?,
      tarih: json['tarih'] as String,
      coksatan2: json['coksatan2'] as int,
      raradi: json['raradi'] as String?,
      sanal: json['sanal'] as int?,
      vip: json['vip'] as int?,
      genis: json['genis'] as int?,
    );
  }
}
