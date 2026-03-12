part of 'news_feed_bloc.dart';

abstract class NewsFeedEvent extends Equatable {
  const NewsFeedEvent();
  @override
  List<Object?> get props => [];
}

class LoadNewsFeed extends NewsFeedEvent {
  const LoadNewsFeed();
}

class RefreshNewsFeed extends NewsFeedEvent {
  const RefreshNewsFeed();
}

class SelectCategory extends NewsFeedEvent {
  final String category;
  const SelectCategory(this.category);
  @override
  List<Object?> get props => [category];
}
