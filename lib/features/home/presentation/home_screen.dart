import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/home/domain/home_market.dart';
import 'package:chain_flow/features/home/domain/news_model.dart';
import 'package:chain_flow/features/home/presentation/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotMarketAsync = ref.watch(homeHotMarketProvider);
    final newsAsync = ref.watch(homeNewsProvider);
    final isVisible = ref.watch(isBalanceVisiblePRovider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
          child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(ref, isVisible),
          ),
          SliverToBoxAdapter(
            child: hotMarketAsync.when(
                data: (coins) => _buildHotMarketRow(coins),
                error: (_, __) => SizedBox.shrink(),
                loading: () => SizedBox(
                      height: 80,
                    )),
          ),
          SliverToBoxAdapter(child: _buildShortcuts()),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text("Binance Square",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          _buildNewsList(newsAsync),
        ],
      )),
    );
  }

  Widget _buildShortcuts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _shortcutIcon(Icons.account_balance_wallet, "Deposit"),
          _shortcutIcon(Icons.people, "P2P"),
          _shortcutIcon(Icons.auto_graph, "Earn"),
          _shortcutIcon(Icons.grid_view, "More"),
        ],
      ),
    );
  }

  Widget _buildNewsList(AsyncValue<List<NewsArticle>> newsAsync) {
    return newsAsync.when(
      data: (articles) => SliverList(
          delegate: SliverChildBuilderDelegate(childCount: articles.length,
              (context, index) {
        final article = articles[index];
        return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${article.source} • ${article.timeAgo}",
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (article.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl!,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
              ],
            ));
      })),
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(
            child: Text("News Unavailable: $err",
                style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _shortcutIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.secondaryBlack,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primaryGold),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }

  Widget _buildHotMarketRow(List<HomeMarketSnapshot> coins) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: coins.map((coin) => _coinCard(coin)).toList(),
      ),
    );
  }

  Widget _coinCard(HomeMarketSnapshot coin) {
    final color = coin.change >= 0 ? AppColors.greenGain : AppColors.redLoss;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(coin.symbol,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              coin.price.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 20,
              child: Sparkline(
                data: coin.history,
                lineColor: color,
                fillMode: FillMode.below,
                fillGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${coin.change >= 0 ? '+' : ''}${coin.change.toStringAsFixed(2)}%",
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, bool isVisible) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.secondaryBlack,
                    child: Icon(Icons.person, color: Colors.white)),
                IconButton(
                    onPressed: () => ref
                        .read(isBalanceVisiblePRovider.notifier)
                        .state = !isVisible,
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ))
              ],
            ),
            const Text("Total Balance",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              isVisible ? "42,150.80 USDT" : "*******",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
