import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class CreateArticle {
  final NewsRepository repository;

  CreateArticle(this.repository);

  Future<Either<Failure, void>> call(Article article) {
    return repository.createArticle(article);
  }
}
