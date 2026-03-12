import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool compact;

  const ArticleCard({super.key, required this.article, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/article/${article.id}', extra: article),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: compact ? _buildCompact(theme) : _buildFull(theme),
      ),
    );
  }

  Widget _buildFull(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Thumbnail(url: article.thumbnailURL, height: 180),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryBadge(category: article.category),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                article.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              _Meta(article: article),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompact(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryBadge(category: article.category),
                const SizedBox(height: 6),
                Text(
                  article.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _Meta(article: article),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _Thumbnail(url: article.thumbnailURL, height: 80, width: 80),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String url;
  final double height;
  final double? width;

  const _Thumbnail({required this.url, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: height,
        width: width ?? double.infinity,
        color: Colors.grey.withOpacity(0.2),
      ),
      errorWidget: (_, __, ___) => Container(
        height: height,
        width: width ?? double.infinity,
        color: Colors.grey.withOpacity(0.2),
        child: const Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.categoryColor(category).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.categoryColor(category),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final Article article;
  const _Meta({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          article.sourceName,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Text('·', style: theme.textTheme.labelSmall),
        const SizedBox(width: 6),
        Text(
          DateFormatter.timeAgo(article.publishedAt),
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
