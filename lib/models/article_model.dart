import 'package:uni_news_app/models/source_model.dart';

class Article {
  Source source;
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publishedAt;
  String content;
  String articleUrl;

  Article(
      {this.source,
      this.title,
      this.description,
      this.author,
      this.content,
      this.publishedAt,
      this.urlToImage,
      this.articleUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      publishedAt: DateTime.parse(json['publishedAt']),
      urlToImage: json['urlToImage'] as String,
      articleUrl: json['url'] as String,
    );
  }
}
