import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../news/data/models/article_model.dart';
import '../../../news/domain/entities/article.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../datasources/bookmarks_local_datasource.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksLocalDataSource dataSource;

  const BookmarksRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Article>>> getBookmarks() async {
    try {
      final bookmarks = await dataSource.getBookmarks();
      return Right(bookmarks);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(Article article) async {
    try {
      await dataSource.addBookmark(ArticleModel.fromEntity(article));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String articleId) async {
    try {
      await dataSource.removeBookmark(articleId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String articleId) async {
    try {
      final result = await dataSource.isBookmarked(articleId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
