import 'package:daily_flash/features/home/models/article_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class BookmarkProvider extends StateNotifier<List<Article>> {
  BookmarkProvider() : super([]);

  void addBookmark(Article article) {
    if (!state.any((item) => item.url == article.url)) {
      state = [...state, article];
    }
  }

  void removeBookmark(Article article) {
    state = state.where((item) => item.url != article.url).toList();
  }

  bool isBookmarked(Article article) {
    return state.any((item) => item.url == article.url);
  }

  void toggleBookmark(Article article) {
    if (isBookmarked(article)) {
      removeBookmark(article);
    } else {
      addBookmark(article);
    }
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkProvider, List<Article>>((ref) {
  return BookmarkProvider();
});
