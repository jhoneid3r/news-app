import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.author,
    required super.sourceName,
    required super.sourceId,
    required super.category,
    required super.thumbnailURL,
    required super.publishedAt,
    required super.url,
    required super.isBreaking,
    required super.tags,
    required super.views,
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      author: data['author'] ?? '',
      sourceName: data['sourceName'] ?? '',
      sourceId: data['sourceId'] ?? '',
      category: data['category'] ?? 'general',
      thumbnailURL: data['thumbnailURL'] ?? '',
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      url: data['url'] ?? '',
      isBreaking: data['isBreaking'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      views: (data['views'] ?? 0).toInt(),
    );
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map, String id) {
    return ArticleModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      sourceName: map['sourceName'] ?? '',
      sourceId: map['sourceId'] ?? '',
      category: map['category'] ?? 'general',
      thumbnailURL: map['thumbnailURL'] ?? '',
      publishedAt: map['publishedAt'] is Timestamp
          ? (map['publishedAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['publishedAt']?.toString() ?? '') ?? DateTime.now(),
      url: map['url'] ?? '',
      isBreaking: map['isBreaking'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      views: (map['views'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'content': content,
        'author': author,
        'sourceName': sourceName,
        'sourceId': sourceId,
        'category': category,
        'thumbnailURL': thumbnailURL,
        'publishedAt': publishedAt.toIso8601String(),
        'url': url,
        'isBreaking': isBreaking,
        'tags': tags,
        'views': views,
      };

  factory ArticleModel.fromEntity(Article article) => ArticleModel(
        id: article.id,
        title: article.title,
        description: article.description,
        content: article.content,
        author: article.author,
        sourceName: article.sourceName,
        sourceId: article.sourceId,
        category: article.category,
        thumbnailURL: article.thumbnailURL,
        publishedAt: article.publishedAt,
        url: article.url,
        isBreaking: article.isBreaking,
        tags: article.tags,
        views: article.views,
      );
}
