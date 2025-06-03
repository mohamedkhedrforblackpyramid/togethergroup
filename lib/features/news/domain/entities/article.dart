import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String? author;
  final Map<String, dynamic>? source;

  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.author,
    this.source,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
        author,
        source,
      ];
} 