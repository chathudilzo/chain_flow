import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/market/presentation/market_screen.dart';
import 'package:chain_flow/features/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationShell extends ConsumerWidget {
  const NavigationShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    final List<Widget> screens = [
      Center(
        child: Text("Home"),
      ),
      MarketScreen(),
      Center(
        child: Text("Trade"),
      ),
      Center(
        child: Text("Future"),
      ),
      Center(
        child: Text("Assets"),
      )
    ];
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => ref.read(navigationProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.secondaryBlack,
          selectedItemColor: AppColors.primaryGold,
          unselectedItemColor: AppColors.textSecondary,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Markets'),
            BottomNavigationBarItem(
                icon: Icon(Icons.swap_horizontal_circle), label: 'Trade'),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), label: 'Futures'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Assets'),
          ]),
    );
  }
}
