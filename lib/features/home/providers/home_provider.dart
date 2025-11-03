import 'dart:convert';
import 'package:daily_flash/features/home/models/news_model.dart';
import 'package:daily_flash/features/home/providers/home_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends StateNotifier<HomeState> {
  HomeProvider() : super(HomeState()) {
    fetchNews();
  }

  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const int _pageSize = 20;

  String get _apiKey {
    final apiKey = dotenv.env['NEWS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('NEWS_API_KEY is not set in .env file');
    }
    return apiKey;
  }

  Future<void> fetchNews({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isLoading: true, currentPage: 1, articles: [], hasMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final query = Uri.encodeComponent(state.query);
      final response = await http.get(Uri.parse('$_baseUrl?q=$query&apiKey=$_apiKey&page=1&pageSize=$_pageSize'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newsModel = NewsModel.fromJson(jsonData);

        state = state.copyWith(
          articles: newsModel.articles ?? [],
          isLoading: false,
          currentPage: 1,
          totalResults: newsModel.totalResults ?? 0,
          hasMore:
              (newsModel.articles?.length ?? 0) >= _pageSize &&
              (state.articles.length + (newsModel.articles?.length ?? 0)) < (newsModel.totalResults ?? 0),
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error loading news: ${e.toString()}');
    }
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(
      query: query.trim(),
      isLoading: true,
      currentPage: 1,
      articles: [],
      hasMore: true,
      error: null,
    );

    await fetchNews(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final query = Uri.encodeComponent(state.query);
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$query&apiKey=$_apiKey&page=$nextPage&pageSize=$_pageSize'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newsModel = NewsModel.fromJson(jsonData);
        final newArticles = newsModel.articles ?? [];

        state = state.copyWith(
          articles: [...state.articles, ...newArticles],
          isLoadingMore: false,
          currentPage: nextPage,
          hasMore:
              newArticles.length >= _pageSize &&
              (state.articles.length + newArticles.length) < (newsModel.totalResults ?? 0),
        );
      } else {
        state = state.copyWith(isLoadingMore: false, error: 'Failed to load more news: ${response.statusCode}');
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: 'Error loading more news: ${e.toString()}');
    }
  }
}

final homeProvider = StateNotifierProvider<HomeProvider, HomeState>((ref) {
  return HomeProvider();
});
