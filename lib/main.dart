import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/navigation/navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const ChainFlowApp()));
}

class ChainFlowApp extends StatelessWidget {
  const ChainFlowApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ChainFlow",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryBlack,
          primaryColor: AppColors.primaryGold,
          colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGold,
              secondary: AppColors.primaryGold,
              surface: AppColors.secondaryBlack,
              background: AppColors.primaryBlack),
          textTheme: TextTheme(
              displayLarge: TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(color: AppColors.textSecondary))),
      home: NavigationShell(),
    );
  }
}
