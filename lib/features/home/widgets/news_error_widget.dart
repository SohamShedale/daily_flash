import 'package:daily_flash/features/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsErrorWidget extends ConsumerWidget {
  final String error;

  const NewsErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(homeProvider.notifier).fetchNews(isRefresh: true);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
