import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/news_feed/news_feed_bloc.dart';
import '../widgets/article_card.dart';
import '../widgets/article_shimmer.dart';
import '../widgets/featured_article_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsFeedBloc>()..add(const LoadNewsFeed()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'News',
                style: theme.appBarTheme.titleTextStyle,
              ),
              TextSpan(
                text: 'Flow',
                style: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            bloc: sl<ThemeCubit>(),
            builder: (context, mode) {
              final icon = switch (mode) {
                ThemeMode.light => Icons.dark_mode_outlined,
                ThemeMode.dark => Icons.light_mode_outlined,
                ThemeMode.system => Icons.brightness_auto,
              };
              final tooltip = switch (mode) {
                ThemeMode.light => 'Switch to dark',
                ThemeMode.dark => 'Switch to system',
                ThemeMode.system => 'Switch to light',
              };
              return IconButton(
                icon: Icon(icon),
                tooltip: tooltip,
                onPressed: () => sl<ThemeCubit>().toggle(),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<NewsFeedBloc, NewsFeedState>(
        builder: (context, state) {
          if (state is NewsFeedLoading || state is NewsFeedInitial) {
            return const _LoadingView();
          }
          if (state is NewsFeedError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context
                  .read<NewsFeedBloc>()
                  .add(const LoadNewsFeed()),
            );
          }
          if (state is NewsFeedLoaded) {
            return _LoadedView(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.fabPurple,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final NewsFeedLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsFeedBloc>().add(const RefreshNewsFeed());
      },
      child: CustomScrollView(
        slivers: [
          // Breaking news / Featured
          if (state.breaking.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breaking News',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        itemCount: state.breaking.length,
                        controller: PageController(viewportFraction: 0.92),
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FeaturedArticleCard(
                            article: state.breaking[i],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Category filter
          SliverToBoxAdapter(
            child: _CategoryBar(selected: state.selectedCategory),
          ),

          // Article list header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                state.selectedCategory == 'general'
                    ? 'Latest News'
                    : AppConstants.categoryLabels[state.selectedCategory] ??
                        state.selectedCategory,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),

          // Articles
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final articles = state.categoryArticles.isNotEmpty
                    ? state.categoryArticles
                    : state.headlines;
                if (index >= articles.length) return null;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: ArticleCard(
                    article: articles[index],
                    compact: true,
                  ),
                );
              },
              childCount: (state.categoryArticles.isNotEmpty
                      ? state.categoryArticles
                      : state.headlines)
                  .length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String selected;
  const _CategoryBar({required this.selected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: AppConstants.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = AppConstants.categories[i];
          final isSelected = cat == selected;
          final color = AppColors.categoryColor(cat);
          return GestureDetector(
            onTap: () => context
                .read<NewsFeedBloc>()
                .add(SelectCategory(cat)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppConstants.categoryEmojis[cat] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppConstants.categoryLabels[cat] ?? cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          FeaturedShimmer(),
          SizedBox(height: 20),
          ArticleShimmer(),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
