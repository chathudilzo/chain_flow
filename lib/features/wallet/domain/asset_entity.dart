class AssetEntity {
  final String symbol;
  final double amount;
  final double currentPrice;

  AssetEntity(
      {required this.symbol, required this.amount, required this.currentPrice});

  double get totalValue => amount * currentPrice;
}
