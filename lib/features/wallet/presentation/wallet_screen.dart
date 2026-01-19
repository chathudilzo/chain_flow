import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/wallet/presentation/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(liveAssetProvider);
    final totalBalance = ref.watch(liveTotalBalanceProvider);
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        title: Text("Assets"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Balance (USD)",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "\$${totalBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Your Assets",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(asset.symbol,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text("${asset.amount} ${asset.symbol}",
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                        trailing: Text(
                            "\$${asset.totalValue.toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
