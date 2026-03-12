import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  const GetTopHeadlines(this.repository);

  Future<Either<Failure, List<Article>>> call({int limit = 20}) =>
      repository.getTopHeadlines(limit: limit);
}
