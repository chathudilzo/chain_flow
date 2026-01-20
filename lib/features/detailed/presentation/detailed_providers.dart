import 'dart:convert';

import 'package:chain_flow/features/detailed/domain/coin_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

final CoinTickerProvider =
    StreamProvider.family<CoinTickerStats, String>((ref, symbol) {
  final wsUrl =
      'wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}usdt@ticker';
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  ref.onDispose(() => channel.sink.close());

  return channel.stream.map((event) {
    final data = jsonDecode(event);
    return CoinTickerStats(
      lastPrice: double.parse(data['c']),
      priceChangePercent: double.parse(data['P']),
      high24h: double.parse(data['h']),
      low24h: double.parse(data['l']),
      volUsdt: double.parse(data['q']),
      volCoin: double.parse(data['v']),
    );
  });
});

final candleStreamProvider =
    StreamProvider.family<List<CandleData>, String>((ref, symbol) async* {
  final cleanSymbol = symbol.toLowerCase() + "usdt";
  final historyUrl =
      "https://api.binance.com/api/v3/klines?symbol=${cleanSymbol.toUpperCase()}&interval=1m&limit=500";
  final response = await http.get(Uri.parse(historyUrl));

  List<CandleData> candles = [];
  if (response.statusCode == 200) {
    final List<dynamic> rawData = jsonDecode(response.body);
    candles = rawData
        .map((item) => CandleData(
              timestamp: item[0],
              open: double.parse(item[1]),
              high: double.parse(item[2]),
              low: double.parse(item[3]),
              close: double.parse(item[4]),
              volume: double.parse(item[5]),
            ))
        .toList();
  }
  yield candles;
  final wsUrl =
      'wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}usdt@kline_1m';
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  ref.onDispose(() => channel.sink.close());

  await for (final event in channel.stream) {
    final data = jsonDecode(event)['k'];
    final newCandle = CandleData(
      timestamp: data['t'],
      open: double.parse(data['o']),
      high: double.parse(data['h']),
      low: double.parse(data['l']),
      close: double.parse(data['c']),
      volume: double.parse(data['v']),
    );

    if (candles.isNotEmpty && candles.last.timestamp == newCandle.timestamp) {
      candles[candles.length - 1] = newCandle;
    } else {
      candles.add(newCandle);
      if (candles.length > 1000) candles.removeAt(0);
    }
    yield List.from(candles);
  }
});
