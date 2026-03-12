class AppConstants {
  static const String appName = 'NewsFlow';

  static const List<String> categories = [
    'general',
    'technology',
    'sports',
    'business',
    'entertainment',
    'health',
    'science',
  ];

  static const Map<String, String> categoryLabels = {
    'general': 'General',
    'technology': 'Technology',
    'sports': 'Sports',
    'business': 'Business',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'science': 'Science',
  };

  static const Map<String, String> categoryEmojis = {
    'general': '🌐',
    'technology': '💻',
    'sports': '⚽',
    'business': '💼',
    'entertainment': '🎬',
    'health': '❤️',
    'science': '🔬',
  };

  static const int pageSize = 20;
  static const String articlesCollection = 'articles';
  static const String categoriesCollection = 'categories';
  static const String usersCollection = 'users';
  static const String bookmarksSubcollection = 'bookmarks';
  static const String storageArticlesFolder = 'media/articles';
}
