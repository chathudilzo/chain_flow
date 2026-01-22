class HomeMarketSnapshot {
  final String symbol;
  final double price;
  final double change;
  final List<double> history;

  HomeMarketSnapshot({
    required this.symbol,
    required this.price,
    required this.change,
    required this.history,
  });
}
