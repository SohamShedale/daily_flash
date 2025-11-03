import 'package:flutter/material.dart';

class NewsEmptyState extends StatelessWidget {
  const NewsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No news articles found'));
  }
}
