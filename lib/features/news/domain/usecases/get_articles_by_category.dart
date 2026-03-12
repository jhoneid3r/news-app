import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetArticlesByCategory {
  final NewsRepository repository;
  const GetArticlesByCategory(this.repository);

  Future<Either<Failure, List<Article>>> call(
    String category, {
    int limit = 20,
  }) =>
      repository.getArticlesByCategory(category, limit: limit);
}
