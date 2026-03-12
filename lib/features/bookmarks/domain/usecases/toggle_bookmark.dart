import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/article.dart';
import '../repositories/bookmarks_repository.dart';

class ToggleBookmark {
  final BookmarksRepository repository;
  const ToggleBookmark(this.repository);

  Future<Either<Failure, bool>> call(Article article) async {
    final isBookmarkedResult = await repository.isBookmarked(article.id);
    return isBookmarkedResult.fold(
      (failure) => Left(failure),
      (isBookmarked) async {
        if (isBookmarked) {
          final result = await repository.removeBookmark(article.id);
          return result.fold(
            (failure) => Left(failure),
            (_) => const Right(false),
          );
        } else {
          final result = await repository.addBookmark(article);
          return result.fold(
            (failure) => Left(failure),
            (_) => const Right(true),
          );
        }
      },
    );
  }
}
