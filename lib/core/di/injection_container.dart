import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/bookmarks/data/datasources/bookmarks_local_datasource.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import '../../features/bookmarks/domain/repositories/bookmarks_repository.dart';
import '../../features/bookmarks/domain/usecases/get_bookmarks.dart';
import '../../features/bookmarks/domain/usecases/toggle_bookmark.dart';
import '../../features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/news/data/datasources/news_firestore_datasource.dart';
import '../../features/news/data/datasources/news_mock_datasource.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_article_by_id.dart';
import '../../features/news/domain/usecases/get_articles_by_category.dart';
import '../../features/news/domain/usecases/get_breaking_news.dart';
import '../../features/news/domain/usecases/get_top_headlines.dart';
import '../../features/news/domain/usecases/search_articles.dart';
import '../../features/news/presentation/bloc/article_detail/article_detail_cubit.dart';
import '../../features/news/presentation/bloc/news_feed/news_feed_bloc.dart';
import '../../features/news/presentation/bloc/search/search_bloc.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Theme
  sl.registerLazySingleton(() => ThemeCubit(prefs));

  // Data Sources
  sl.registerLazySingleton<NewsDataSource>(
    () => NewsFirestoreDataSource(FirebaseFirestore.instance),
  );

  sl.registerLazySingleton<BookmarksLocalDataSource>(
    () => BookmarksLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<BookmarksRepository>(
    () => BookmarksRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => GetBreakingNews(sl()));
  sl.registerLazySingleton(() => GetArticlesByCategory(sl()));
  sl.registerLazySingleton(() => GetArticleById(sl()));
  sl.registerLazySingleton(() => SearchArticles(sl()));
  sl.registerLazySingleton(() => GetBookmarks(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));

  // BLoCs / Cubits
  sl.registerFactory(
    () => NewsFeedBloc(
      getTopHeadlines: sl(),
      getBreakingNews: sl(),
      getArticlesByCategory: sl(),
    ),
  );

  sl.registerFactory(
    () => ArticleDetailCubit(getArticleById: sl()),
  );

  sl.registerFactory(
    () => SearchBloc(searchArticles: sl()),
  );

  sl.registerFactory(
    () => BookmarksCubit(
      getBookmarks: sl(),
      toggleBookmark: sl(),
    ),
  );
}
