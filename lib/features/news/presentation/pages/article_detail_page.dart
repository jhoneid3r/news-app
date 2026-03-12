import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: article.thumbnailURL,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x44000000), Color(0xCC000000)],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              BlocBuilder<BookmarksCubit, BookmarksState>(
                builder: (context, bmState) {
                  final isBookmarked = bmState is BookmarksLoaded &&
                      bmState.bookmarks.any((a) => a.id == article.id);
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AppColors.accent : Colors.white,
                    ),
                    onPressed: () =>
                        context.read<BookmarksCubit>().toggle(article),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.open_in_browser, color: Colors.white),
                onPressed: () async {
                  final uri = Uri.tryParse(article.url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + breaking
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.categoryColor(article.category)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.categoryColor(article.category),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (article.isBreaking) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BREAKING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article.title,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    article.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            AppColors.categoryColor(article.category)
                                .withOpacity(0.2),
                        child: Text(
                          article.author.isNotEmpty
                              ? article.author[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.categoryColor(article.category),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author.isNotEmpty
                                  ? article.author
                                  : article.sourceName,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                            Text(
                              '${article.sourceName} · ${DateFormatter.fullDate(article.publishedAt)}',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),

                  // Content
                  Text(
                    article.content,
                    style: theme.textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  // Tags
                  if (article.tags.isNotEmpty) ...[
                    Text('Tags', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags
                          .map((t) => Chip(label: Text('#$t')))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
