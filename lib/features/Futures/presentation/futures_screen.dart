import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/Futures/domain/future_state.dart';
import 'package:chain_flow/features/Futures/presentation/futures_provider.dart';
import 'package:chain_flow/features/trade/presentation/order_book_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FuturesScreen extends ConsumerWidget {
  final String symbol;
  const FuturesScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(futuresProvider(symbol));

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildMarginLeverageRow(ref, state),
                          const SizedBox(height: 16),
                          _buildOrderForm(state),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: OrderBookPanel(symbol: symbol)),
                ],
              ),
            ),
            _buildLiquidationBottomBar(state),
          ],
        ),
      ),
    );
  }

  Widget _buildMarginLeverageRow(WidgetRef ref, FuturesUIState state) {
    return Row(
      children: [
        _pillBtn(state.isCross ? "Cross" : "Isolated",
            () => ref.read(futuresProvider(symbol).notifier).toggleMargin()),
        const SizedBox(width: 8),
        // _pillBtn("${state.leverage}x", () => _showLeverageDialog(ref)),
      ],
    );
  }

  Widget _pillBtn(String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlack,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.divider, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidationBottomBar(FuturesUIState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.secondaryBlack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Est. Liq Price",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(
            state.liquidationPrice > 0
                ? state.liquidationPrice.toStringAsFixed(2)
                : "--",
            style: const TextStyle(
                color: AppColors.primaryGold, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FuturesUIState state) {
    final Color priceColor = state.lastPrice >= state.markPrice
        ? AppColors.greenGain
        : AppColors.redLoss;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        border:
            Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$symbol Perpetual",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                state.lastPrice.toStringAsFixed(2),
                style: TextStyle(
                    color: priceColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerStat("Mark", state.markPrice.toStringAsFixed(2)),
              const SizedBox(height: 4),
              _headerStat(
                  "Index", (state.markPrice * 0.999).toStringAsFixed(2)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Funding / Countdown",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                "${(state.fundingRate * 100).toStringAsFixed(4)}% / ${_formatCountdown()}",
                style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _formatCountdown() {
    final now = DateTime.now();
    final nextFunding = DateTime(
        now.year, now.month, now.day, ((now.hour / 8).floor() + 1) * 8);
    final diff = nextFunding.difference(now);
    return "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  Widget _buildOrderForm(FuturesUIState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.secondaryBlack,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              _orderTypeTab("Limit", true),
              _orderTypeTab("Market", false),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _OrderInput(
          label: "Price",
          value: state.lastPrice.toStringAsFixed(2),
          suffix: "USDT",
          enabled: true,
        ),
        const SizedBox(height: 12),
        _OrderInput(
          label: "Amount",
          value: "0.00",
          suffix: symbol,
          enabled: true,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              [25, 50, 75, 100].map((pct) => _percentBtn("$pct%")).toList(),
        ),
        const SizedBox(height: 20),
        _infoRow("Available", "1,240.50 USDT"),
        _infoRow("Max Buy", "0.45 $symbol"),
        _infoRow("Cost", "0.00 USDT"),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _actionBtn("Buy/Long", AppColors.greenGain)),
            const SizedBox(width: 8),
            Expanded(child: _actionBtn("Sell/Short", AppColors.redLoss)),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn(String label, Color color) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _orderTypeTab(String label, bool isActive) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.divider : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _OrderInput({
    required String label,
    required String value,
    required String suffix,
    required bool enabled,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: enabled
            ? AppColors.secondaryBlack
            : AppColors.secondaryBlack.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text(
            label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              enabled: enabled,
              controller: TextEditingController(text: value),
              textAlign: TextAlign.right,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            suffix,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              _adjBtn(Icons.remove),
              const VerticalDivider(
                  color: AppColors.divider,
                  indent: 12,
                  endIndent: 12,
                  width: 16),
              _adjBtn(Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _adjBtn(IconData icon) {
    return InkWell(
      onTap: () {},
      child: Icon(icon, color: AppColors.textSecondary, size: 16),
    );
  }

  Widget _percentBtn(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
