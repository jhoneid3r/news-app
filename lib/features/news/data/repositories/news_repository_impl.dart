import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_mock_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsDataSource dataSource;

  const NewsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    int limit = 20,
  }) async {
    try {
      final articles = await dataSource.getTopHeadlines(limit: limit);
      return Right(articles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByCategory(
    String category, {
    int limit = 20,
  }) async {
    try {
      final articles = await dataSource.getArticlesByCategory(
        category,
        limit: limit,
      );
      return Right(articles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String id) async {
    try {
      final article = await dataSource.getArticleById(id);
      return Right(article);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NotFoundFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(String query) async {
    try {
      final articles = await dataSource.searchArticles(query);
      return Right(articles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getBreakingNews() async {
    try {
      final articles = await dataSource.getBreakingNews();
      return Right(articles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
