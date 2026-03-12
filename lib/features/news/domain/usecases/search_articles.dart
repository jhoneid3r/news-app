import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class SearchArticles {
  final NewsRepository repository;
  const SearchArticles(this.repository);

  Future<Either<Failure, List<Article>>> call(String query) =>
      repository.searchArticles(query);
}
