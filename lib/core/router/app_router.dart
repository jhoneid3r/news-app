import 'package:go_router/go_router.dart';
import '../../features/news/domain/entities/article.dart';
import '../../features/news/presentation/pages/home_page.dart';
import '../../features/news/presentation/pages/article_detail_page.dart';
import '../../features/news/presentation/pages/create_article_page.dart';
import '../../features/news/presentation/pages/search_page.dart';
import '../../features/bookmarks/presentation/pages/bookmarks_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/bookmarks',
        name: 'bookmarks',
        builder: (context, state) => const BookmarksPage(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/create',
        name: 'create',
        builder: (context, state) => const CreateArticlePage(),
      ),
      GoRoute(
        path: '/article/:id',
        name: 'article',
        builder: (context, state) {
          final article = state.extra as Article?;
          final id = state.pathParameters['id']!;
          return ArticleDetailPage(articleId: id, article: article);
        },
      ),
    ],
  );
}
