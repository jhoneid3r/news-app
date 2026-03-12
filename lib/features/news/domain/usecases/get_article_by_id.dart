import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetArticleById {
  final NewsRepository repository;
  const GetArticleById(this.repository);

  Future<Either<Failure, Article>> call(String id) =>
      repository.getArticleById(id);
}
