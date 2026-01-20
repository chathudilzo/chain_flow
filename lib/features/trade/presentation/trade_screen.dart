import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/detailed/presentation/coin_detail_screen.dart';
import 'package:chain_flow/features/market/presentation/market_provider.dart';
import 'package:chain_flow/features/trade/presentation/market_list_widget.dart';
import 'package:chain_flow/features/trade/presentation/order_book_panel.dart';
import 'package:chain_flow/features/trade/presentation/trade_panel.dart';
import 'package:chain_flow/features/trade/presentation/trade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeScreen extends ConsumerWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symbol = ref.watch(selectedTradeSymbolProvider);
    final isBuy = ref.watch(tradeTypeProvider);
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
          child: Column(
        children: [
          _buildTopHeader(context, symbol, ref),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3, child: TradePanel(symbol: symbol, isBuy: isBuy)),
                Expanded(
                    flex: 2,
                    child: OrderBookPanel(
                      symbol: symbol,
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget _buildTopHeader(BuildContext context, String symbol, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _showCoinSelector(context, ref),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "$symbol/USDT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  )
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoinDetailScreen(
                              symbol: symbol,
                            )));
              },
              icon: Icon(
                Icons.bar_chart_rounded,
                color: AppColors.textSecondary,
              ))
        ],
      ),
    );
  }

  void _showCoinSelector(BuildContext context, WidgetRef ref) {
    ref.read(markerSearchProvider.notifier).state = "";

    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryBlack,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) =>
                      ref.read(markerSearchProvider.notifier).state = value,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search coins...",
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textSecondary),
                    fillColor: AppColors.secondaryBlack,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: MarketListWidget(onSelected: (newSymbol) {
                  ref.read(selectedTradeSymbolProvider.notifier).state =
                      newSymbol;
                  Navigator.pop(context);
                }))
              ],
            ),
          );
        });
  }
}
