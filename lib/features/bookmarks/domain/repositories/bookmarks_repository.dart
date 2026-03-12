import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/article.dart';

abstract class BookmarksRepository {
  Future<Either<Failure, List<Article>>> getBookmarks();
  Future<Either<Failure, void>> addBookmark(Article article);
  Future<Either<Failure, void>> removeBookmark(String articleId);
  Future<Either<Failure, bool>> isBookmarked(String articleId);
}
