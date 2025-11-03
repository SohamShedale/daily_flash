import 'package:daily_flash/app/app_routes.dart';
import 'package:daily_flash/core/theme/app_colors.dart';
import 'package:daily_flash/features/home/providers/home_provider.dart';
import 'package:daily_flash/features/home/providers/home_state.dart';
import 'package:daily_flash/features/home/widgets/article_card.dart';
import 'package:daily_flash/features/home/widgets/article_shimmer_card.dart';
import 'package:daily_flash/features/home/widgets/news_empty_state.dart';
import 'package:daily_flash/features/home/widgets/news_error_widget.dart';
import 'package:daily_flash/features/home/widgets/news_list_shimmer.dart';
import 'package:daily_flash/features/home/widgets/news_search_field.dart';
import 'package:daily_flash/shared/widgets/app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(homeProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const AppName(isCenter: false),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: AppColors.blue),
            onPressed: () {
              context.push(AppRoutes.bookmarks);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const NewsSearchField(),
          Expanded(child: _buildBody(homeState)),
        ],
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state.isLoading && state.articles.isEmpty) {
      return const NewsListShimmer(itemCount: 5);
    }

    if (state.error != null && state.articles.isEmpty) {
      return NewsErrorWidget(error: state.error!);
    }

    if (state.articles.isEmpty) {
      return const NewsEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeProvider.notifier).fetchNews(isRefresh: true);
      },
      color: AppColors.blue,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.articles.length + (state.isLoadingMore ? 1 : 0),
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          if (index == state.articles.length) {
            return const ArticleShimmerCard();
          }

          return ArticleCard(article: state.articles[index]);
        },
      ),
    );
  }
}
