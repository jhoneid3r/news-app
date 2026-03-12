import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/article_model.dart';
import 'news_mock_datasource.dart';

class NewsFirestoreDataSource implements NewsDataSource {
  final FirebaseFirestore _firestore;

  NewsFirestoreDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _articles =>
      _firestore.collection(AppConstants.articlesCollection);

  @override
  Future<List<ArticleModel>> getTopHeadlines({int limit = 20}) async {
    final snap = await _articles
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(ArticleModel.fromFirestore).toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(
    String category, {
    int limit = 20,
  }) async {
    final snap = await _articles
        .where('category', isEqualTo: category)
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(ArticleModel.fromFirestore).toList();
  }

  @override
  Future<ArticleModel> getArticleById(String id) async {
    final doc = await _articles.doc(id).get();
    if (!doc.exists) throw Exception('Article not found');
    return ArticleModel.fromFirestore(doc);
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query) async {
    // Firestore does not support full-text search natively.
    // For production, integrate Algolia or Typesense.
    // This implementation does a prefix search on the title field.
    final snap = await _articles
        .orderBy('title')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();
    return snap.docs.map(ArticleModel.fromFirestore).toList();
  }

  @override
  Future<List<ArticleModel>> getBreakingNews() async {
    final snap = await _articles
        .where('isBreaking', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .limit(10)
        .get();
    return snap.docs.map(ArticleModel.fromFirestore).toList();
  }

  @override
  Future<void> createArticle(ArticleModel article) async {
    await _articles.add({
      'title': article.title,
      'description': article.description,
      'content': article.content,
      'author': article.author,
      'sourceName': article.sourceName,
      'sourceId': article.sourceId,
      'category': article.category,
      'thumbnailURL': article.thumbnailURL,
      'publishedAt': Timestamp.fromDate(article.publishedAt),
      'url': article.url,
      'isBreaking': article.isBreaking,
      'tags': article.tags,
      'views': article.views,
    });
  }
}
