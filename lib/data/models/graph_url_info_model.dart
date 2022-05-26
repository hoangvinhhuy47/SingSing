class GraphUrlInfo {
  GraphUrlInfo({
    required this.domain,
    required this.title,
    required this.image,
    required this.url,
  });

  String domain;
  String title;
  String image;
  String url;

  factory GraphUrlInfo.fromJson(Map<String, dynamic> json) => GraphUrlInfo(
        domain: json["domain"] ?? '',
        title: json["title"] ?? '',
        image: json["image"] ?? '',
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "domain": domain,
        "title": title,
        "image": image,
        "url": url,
      };

  bool isNull() {
    return domain.isEmpty && title.isEmpty && url.isEmpty && image.isEmpty;
  }
}
