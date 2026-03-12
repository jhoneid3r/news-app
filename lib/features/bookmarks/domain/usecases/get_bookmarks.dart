import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../news/domain/entities/article.dart';
import '../repositories/bookmarks_repository.dart';

class GetBookmarks {
  final BookmarksRepository repository;
  const GetBookmarks(this.repository);
  Future<Either<Failure, List<Article>>> call() => repository.getBookmarks();
}
