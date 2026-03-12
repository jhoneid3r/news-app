import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../bookmarks/presentation/bloc/bookmarks_cubit.dart';
import '../../domain/entities/article.dart';
import '../bloc/article_detail/article_detail_cubit.dart';

class ArticleDetailPage extends StatelessWidget {
  final String articleId;
  final Article? article;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
    this.article,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = sl<ArticleDetailCubit>();
            if (article != null) {
              cubit.loadFromEntity(article!);
            } else {
              cubit.loadArticle(articleId);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => sl<BookmarksCubit>()..loadBookmarks(),
        ),
      ],
      child: const _ArticleDetailView(),
    );
  }
}

class _ArticleDetailView extends StatelessWidget {
  const _ArticleDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
      builder: (context, state) {
        if (state is ArticleDetailLoading || state is ArticleDetailInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ArticleDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.message)),
          );
        }
        if (state is ArticleDetailLoaded) {
          return _Content(article: state.article);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _Content extends StatelessWidget {
  final Article article;
  const _Content({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    BlocBuilder<BookmarksCubit, BookmarksState>(
                      builder: (context, bmState) {
                        final isBookmarked = bmState is BookmarksLoaded &&
                            bmState.bookmarks.any((a) => a.id == article.id);
                        return IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? AppColors.fabPurple
                                : null,
                          ),
                          onPressed: () =>
                              context.read<BookmarksCubit>().toggle(article),
                        );
                      },
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title card — matches Figma
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.black12,
                            ),
                          ),
                          child: Text(
                            article.title,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Hero image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: article.thumbnailURL,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              height: 220,
                              color: Colors.grey.shade200,
                            ),
                            errorWidget: (_, _, _) => Container(
                              height: 220,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Meta
                        Row(
                          children: [
                            Text(
                              article.sourceName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.fabPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('·',
                                style: theme.textTheme.labelSmall),
                            const SizedBox(width: 8),
                            Text(
                              DateFormatter.timeAgo(article.publishedAt),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Content
                        Text(
                          article.content,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom "Publish Article" bar — matches Figma
          _PublishBar(
            label: 'Read full article',
            icon: Icons.open_in_browser,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// Reusable bottom action bar matching the Figma purple/lavender style.
class _PublishBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PublishBar({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.publishBarDark : AppColors.publishBar,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isDark ? Colors.white70 : Colors.black87, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
