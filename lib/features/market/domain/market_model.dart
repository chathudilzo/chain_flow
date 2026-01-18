class CoinEntity {
  final String symbol;
  final double price;
  final double percentChange;
  final double high;
  final double low;
  final double volume;

  CoinEntity(
      {required this.symbol,
      required this.price,
      required this.percentChange,
      required this.high,
      required this.low,
      required this.volume});
}

abstract class MarketRepository {
  Stream<List<CoinEntity>> watchAllPrices();
}
