import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/usecases/get_articles_by_category.dart';
import '../../../domain/usecases/get_breaking_news.dart';
import '../../../domain/usecases/get_top_headlines.dart';

part 'news_feed_event.dart';
part 'news_feed_state.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final GetTopHeadlines getTopHeadlines;
  final GetBreakingNews getBreakingNews;
  final GetArticlesByCategory getArticlesByCategory;

  NewsFeedBloc({
    required this.getTopHeadlines,
    required this.getBreakingNews,
    required this.getArticlesByCategory,
  }) : super(const NewsFeedInitial()) {
    on<LoadNewsFeed>(_onLoad);
    on<RefreshNewsFeed>(_onRefresh);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoad(
    LoadNewsFeed event,
    Emitter<NewsFeedState> emit,
  ) async {
    emit(const NewsFeedLoading());
    await _fetchAll('general', emit);
  }

  Future<void> _onRefresh(
    RefreshNewsFeed event,
    Emitter<NewsFeedState> emit,
  ) async {
    final current = state;
    final category =
        current is NewsFeedLoaded ? current.selectedCategory : 'general';
    await _fetchAll(category, emit);
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<NewsFeedState> emit,
  ) async {
    final current = state;
    if (current is NewsFeedLoaded) {
      // Show loading for category only
      emit(current.copyWith(
        selectedCategory: event.category,
        categoryArticles: [],
        isLoadingCategory: true,
      ));
    }

    final result = await getArticlesByCategory(event.category);
    result.fold(
      (failure) {
        if (state is NewsFeedLoaded) {
          emit((state as NewsFeedLoaded).copyWith(isLoadingCategory: false));
        }
      },
      (articles) {
        if (state is NewsFeedLoaded) {
          emit(
            (state as NewsFeedLoaded).copyWith(
              categoryArticles: articles,
              selectedCategory: event.category,
              isLoadingCategory: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _fetchAll(
    String category,
    Emitter<NewsFeedState> emit,
  ) async {
    final headlinesResult = await getTopHeadlines();
    final breakingResult = await getBreakingNews();
    final categoryResult = await getArticlesByCategory(category);

    final failure = headlinesResult.fold((f) => f, (_) => null) ??
        breakingResult.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(NewsFeedError(failure.message));
      return;
    }

    emit(
      NewsFeedLoaded(
        headlines: headlinesResult.getOrElse((_) => []),
        breaking: breakingResult.getOrElse((_) => []),
        categoryArticles: categoryResult.getOrElse((_) => []),
        selectedCategory: category,
      ),
    );
  }
}
