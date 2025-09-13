class HostingCartItem {
  final String packageId;
  final String packageName;
  final String domain;
  final int years;
  final int basePrice;
  final int totalPrice;
  final DateTime addedAt;

  HostingCartItem({
    required this.packageId,
    required this.packageName,
    required this.domain,
    required this.years,
    required this.basePrice,
    required this.totalPrice,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'packageName': packageName,
      'domain': domain,
      'years': years,
      'basePrice': basePrice,
      'totalPrice': totalPrice,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory HostingCartItem.fromJson(Map<String, dynamic> json) {
    return HostingCartItem(
      packageId: json['packageId'] as String,
      packageName: json['packageName'] as String,
      domain: json['domain'] as String,
      years: json['years'] as int,
      basePrice: json['basePrice'] as int,
      totalPrice: json['totalPrice'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  String get uniqueId => '${packageId}_$domain';

  String get formattedDomain => 'www.$domain.com';

  String get pricePerYear => '${basePrice}₺/yıl';

  String get durationText {
    if (years == 1) return '1 Yıl';
    return '$years Yıl';
  }

  String get summary => '$packageName - $formattedDomain ($durationText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HostingCartItem &&
        other.packageId == packageId &&
        other.domain == domain;
  }

  @override
  int get hashCode => packageId.hashCode ^ domain.hashCode;

  @override
  String toString() {
    return 'HostingCartItem(packageId: $packageId, domain: $domain, years: $years, totalPrice: $totalPrice)';
  }

  HostingCartItem copyWith({
    String? packageId,
    String? packageName,
    String? domain,
    int? years,
    int? basePrice,
    int? totalPrice,
    DateTime? addedAt,
  }) {
    return HostingCartItem(
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      domain: domain ?? this.domain,
      years: years ?? this.years,
      basePrice: basePrice ?? this.basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
