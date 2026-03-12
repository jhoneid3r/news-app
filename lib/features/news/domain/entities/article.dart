import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String sourceName;
  final String sourceId;
  final String category;
  final String thumbnailURL;
  final DateTime publishedAt;
  final String url;
  final bool isBreaking;
  final List<String> tags;
  final int views;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.sourceName,
    required this.sourceId,
    required this.category,
    required this.thumbnailURL,
    required this.publishedAt,
    required this.url,
    required this.isBreaking,
    required this.tags,
    required this.views,
  });

  @override
  List<Object?> get props => [
        id, title, description, content, author, sourceName, sourceId,
        category, thumbnailURL, publishedAt, url, isBreaking, tags, views,
      ];
}
