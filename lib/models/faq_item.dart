class FaqItem {
  final int id;
  final String question;
  final String description;
  final String? youtubeUrl;
  final ExtraLink? extraLink; // tek link
  final List<ExtraLink>? extraLinks; // bazılarında 2 link var onun için

  FaqItem({
    required this.id,
    required this.question,
    required this.description,
    this.youtubeUrl,
    this.extraLink,
    this.extraLinks,
  });

  List<ExtraLink> get allExtraLinks {
    List<ExtraLink> links = [];
    if (extraLink != null) links.add(extraLink!);
    if (extraLinks != null) links.addAll(extraLinks!);
    return links;
  }

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as int,
      question: json['question'] as String,
      description: json['description'] as String,
      youtubeUrl: json['youtube_url'] as String?,
      extraLink: json['extra_link'] != null
          ? ExtraLink.fromJson(json['extra_link'])
          : null,
      extraLinks: json['extra_links'] != null
          ? (json['extra_links'] as List)
              .map((link) => ExtraLink.fromJson(link))
              .toList()
          : null,
    );
  }
}

class ExtraLink {
  final String title;
  final String url;

  ExtraLink({
    required this.title,
    required this.url,
  });

  factory ExtraLink.fromJson(Map<String, dynamic> json) {
    return ExtraLink(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}
