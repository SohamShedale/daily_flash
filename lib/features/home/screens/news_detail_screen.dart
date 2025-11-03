import 'package:daily_flash/core/theme/app_colors.dart';
import 'package:daily_flash/features/home/models/article_model.dart';
import 'package:daily_flash/features/home/providers/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends ConsumerWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  Future<void> _launchURL(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No URL available')));
      }
      return;
    }

    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open the URL. Please check your browser settings.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening URL: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarkProvider).any((item) => item.url == article.url);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: AppColors.blue),
            onPressed: () {
              ref.read(bookmarkProvider.notifier).toggleBookmark(article);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 64),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source?.name != null)
                    Text(
                      article.source!.name!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  const SizedBox(height: 8),
                  Text(article.title ?? 'No title', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (article.publishedAt != null || article.author != null)
                    Row(
                      children: [
                        if (article.publishedAt != null)
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(article.publishedAt!),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        if (article.publishedAt != null && article.author != null) const SizedBox(width: 16),
                        if (article.author != null)
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(article.author!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  if (article.description != null)
                    Text(article.description!, style: const TextStyle(fontSize: 16, height: 1.6)),
                  const SizedBox(height: 16),
                  if (article.content != null)
                    Text(
                      article.content!.replaceAll(RegExp(r'\[.*?\]'), '').trim(),
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey[800]),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _launchURL(context, article.url);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Read full article',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
