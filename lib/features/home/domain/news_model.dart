class NewsArticle {
  final String title;
  final String source;
  final String timeAgo;
  final String? imageUrl;
  final String link;

  NewsArticle({
    required this.title,
    required this.source,
    required this.timeAgo,
    this.imageUrl,
    required this.link,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      source: json['source_name'] ?? 'Unknown Source',
      timeAgo: json['pubDate'] ?? '',
      imageUrl: json['image_url'],
      link: json['link'] ?? '',
    );
  }
}
