import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetBreakingNews {
  final NewsRepository repository;
  const GetBreakingNews(this.repository);

  Future<Either<Failure, List<Article>>> call() =>
      repository.getBreakingNews();
}
