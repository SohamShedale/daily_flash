import 'package:daily_flash/features/home/models/article_model.dart';

class HomeState {
  final List<Article> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final bool hasMore;
  final String? error;
  final int totalResults;
  final String query;

  HomeState({
    this.articles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
    this.totalResults = 0,
    this.query = 'bitcoin',
  });

  HomeState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasMore,
    String? error,
    int? totalResults,
    String? query,
  }) {
    return HomeState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      totalResults: totalResults ?? this.totalResults,
      query: query ?? this.query,
    );
  }
}
