import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../news/domain/entities/article.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/toggle_bookmark.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final GetBookmarks getBookmarks;
  final ToggleBookmark toggleBookmark;

  BookmarksCubit({
    required this.getBookmarks,
    required this.toggleBookmark,
  }) : super(const BookmarksInitial());

  Future<void> loadBookmarks() async {
    emit(const BookmarksLoading());
    final result = await getBookmarks();
    result.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (bookmarks) => emit(BookmarksLoaded(bookmarks)),
    );
  }

  Future<void> toggle(Article article) async {
    final result = await toggleBookmark(article);
    result.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (_) => loadBookmarks(),
    );
  }

  Future<bool> isBookmarked(String articleId) async {
    final current = state;
    if (current is BookmarksLoaded) {
      return current.bookmarks.any((a) => a.id == articleId);
    }
    return false;
  }
}
