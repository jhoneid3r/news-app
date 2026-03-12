part of 'news_feed_bloc.dart';

abstract class NewsFeedState extends Equatable {
  const NewsFeedState();
  @override
  List<Object?> get props => [];
}

class NewsFeedInitial extends NewsFeedState {
  const NewsFeedInitial();
}

class NewsFeedLoading extends NewsFeedState {
  const NewsFeedLoading();
}

class NewsFeedLoaded extends NewsFeedState {
  final List<Article> headlines;
  final List<Article> breaking;
  final List<Article> categoryArticles;
  final String selectedCategory;

  const NewsFeedLoaded({
    required this.headlines,
    required this.breaking,
    required this.categoryArticles,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [
        headlines,
        breaking,
        categoryArticles,
        selectedCategory,
      ];

  NewsFeedLoaded copyWith({
    List<Article>? headlines,
    List<Article>? breaking,
    List<Article>? categoryArticles,
    String? selectedCategory,
  }) =>
      NewsFeedLoaded(
        headlines: headlines ?? this.headlines,
        breaking: breaking ?? this.breaking,
        categoryArticles: categoryArticles ?? this.categoryArticles,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}

class NewsFeedError extends NewsFeedState {
  final String message;
  const NewsFeedError(this.message);
  @override
  List<Object?> get props => [message];
}
