import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/usecases/get_article_by_id.dart';

part 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final GetArticleById getArticleById;

  ArticleDetailCubit({required this.getArticleById})
      : super(const ArticleDetailInitial());

  Future<void> loadArticle(String id) async {
    emit(const ArticleDetailLoading());
    final result = await getArticleById(id);
    result.fold(
      (failure) => emit(ArticleDetailError(failure.message)),
      (article) => emit(ArticleDetailLoaded(article)),
    );
  }

  void loadFromEntity(Article article) {
    emit(ArticleDetailLoaded(article));
  }
}
