class FuturesUIState {
  final double lastPrice;
  final double markPrice;
  final double fundingRate;
  final int leverage;
  final bool isCross;
  final double quantity;
  final double entryPrice;

  FuturesUIState({
    required this.lastPrice,
    required this.markPrice,
    required this.fundingRate,
    required this.leverage,
    required this.isCross,
    this.quantity = 0.0,
    this.entryPrice = 0.0,
  });

  double get liquidationPrice {
    if (quantity <= 0 || lastPrice <= 0) return 0.0;

    return lastPrice * (1 - (1 / leverage) + 0.005);
  }

  FuturesUIState copyWith({
    double? lastPrice,
    double? markPrice,
    double? fundingRate,
    int? leverage,
    bool? isCross,
    double? quantity,
    double? entryPrice,
  }) {
    return FuturesUIState(
      lastPrice: lastPrice ?? this.lastPrice,
      markPrice: markPrice ?? this.markPrice,
      fundingRate: fundingRate ?? this.fundingRate,
      leverage: leverage ?? this.leverage,
      isCross: isCross ?? this.isCross,
      quantity: quantity ?? this.quantity,
      entryPrice: entryPrice ?? this.entryPrice,
    );
  }
}
