import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../news/data/models/article_model.dart';

abstract class BookmarksLocalDataSource {
  Future<List<ArticleModel>> getBookmarks();
  Future<void> addBookmark(ArticleModel article);
  Future<void> removeBookmark(String articleId);
  Future<bool> isBookmarked(String articleId);
}

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  static const _key = 'bookmarks';
  final SharedPreferences prefs;

  BookmarksLocalDataSourceImpl(this.prefs);

  List<Map<String, dynamic>> _readRaw() {
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      jsonDecode(raw) as List,
    );
  }

  Future<void> _writeRaw(List<Map<String, dynamic>> list) async {
    await prefs.setString(_key, jsonEncode(list));
  }

  @override
  Future<List<ArticleModel>> getBookmarks() async {
    final raw = _readRaw();
    return raw.map((m) => ArticleModel.fromMap(m, m['id'] as String)).toList();
  }

  @override
  Future<void> addBookmark(ArticleModel article) async {
    final raw = _readRaw();
    if (!raw.any((m) => m['id'] == article.id)) {
      raw.add({...article.toMap(), 'id': article.id});
      await _writeRaw(raw);
    }
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    final raw = _readRaw();
    raw.removeWhere((m) => m['id'] == articleId);
    await _writeRaw(raw);
  }

  @override
  Future<bool> isBookmarked(String articleId) async {
    final raw = _readRaw();
    return raw.any((m) => m['id'] == articleId);
  }
}
