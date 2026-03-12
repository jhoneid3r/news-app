part of 'bookmarks_cubit.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();
  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {
  const BookmarksInitial();
}

class BookmarksLoading extends BookmarksState {
  const BookmarksLoading();
}

class BookmarksLoaded extends BookmarksState {
  final List<Article> bookmarks;
  const BookmarksLoaded(this.bookmarks);
  @override
  List<Object?> get props => [bookmarks];
}

class BookmarksError extends BookmarksState {
  final String message;
  const BookmarksError(this.message);
  @override
  List<Object?> get props => [message];
}
