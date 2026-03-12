import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({int limit = 20});
  Future<Either<Failure, List<Article>>> getArticlesByCategory(
    String category, {
    int limit = 20,
  });
  Future<Either<Failure, Article>> getArticleById(String id);
  Future<Either<Failure, List<Article>>> searchArticles(String query);
  Future<Either<Failure, List<Article>>> getBreakingNews();
}
