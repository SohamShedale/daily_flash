import 'package:daily_flash/features/home/widgets/article_shimmer_card.dart';
import 'package:flutter/material.dart';

class NewsListShimmer extends StatelessWidget {
  final int itemCount;

  const NewsListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ArticleShimmerCard();
      },
    );
  }
}
