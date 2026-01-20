class CoinTickerStats {
  final double lastPrice;
  final double priceChangePercent;
  final double high24h;
  final double low24h;
  final double volUsdt;
  final double volCoin;

  CoinTickerStats(
      {required this.lastPrice,
      required this.priceChangePercent,
      required this.high24h,
      required this.low24h,
      required this.volUsdt,
      required this.volCoin});
}
