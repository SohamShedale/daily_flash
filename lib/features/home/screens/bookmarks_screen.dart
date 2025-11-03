import 'package:daily_flash/core/theme/app_colors.dart';
import 'package:daily_flash/features/home/providers/bookmark_provider.dart';
import 'package:daily_flash/features/home/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: AppColors.grey),
                  SizedBox(height: 16),
                  Text('No bookmarks yet', style: TextStyle(color: AppColors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: bookmarks[index]);
              },
            ),
    );
  }
}
