import 'dart:convert';

import 'package:chain_flow/features/home/domain/home_market.dart';
import 'package:chain_flow/features/home/domain/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

final isBalanceVisiblePRovider = StateProvider<bool>((ref) => true);

final homeHotMarketProvider = StreamProvider<List<HomeMarketSnapshot>>((ref) {
  final wsUrl = 'wss://stream.binance.com:9443/ws/!ticker@arr';
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  ref.onDispose(() => channel.sink.close());

  Map<String, List<double>> historyMap = {
    'BTCUSDT': [42000, 42100, 41900, 42200, 42150],
    'ETHUSDT': [2200, 2250, 2230, 2280, 2270],
    'BNBUSDT': [310, 312, 308, 315, 314],
  };

  return channel.stream.map((event) {
    final List<dynamic> data = jsonDecode(event);
    final symbols = ['BTCUSDT', 'ETHUSDT', 'BNBUSDT'];

    return data.where((d) => symbols.contains(d['s'])).map((d) {
      final symbol = d['s'];
      final price = double.parse(d['c']);

      if (historyMap.containsKey(symbol)) {
        historyMap[symbol]!.add(price);
        if (historyMap[symbol]!.length > 20) historyMap[symbol]!.removeAt(0);
      }

      return HomeMarketSnapshot(
        symbol: symbol.replaceAll('USDT', ''),
        price: price,
        change: double.parse(d['P']),
        history: historyMap[symbol] ?? [price],
      );
    }).toList();
  });
});
final homeNewsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  const apiKey = "pub_c5d5d83716a645b8b48d68f4862f8859";
  const url =
      "https://newsdata.io/api/1/latest?apikey=$apiKey&q=crypto&language=en";

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  } catch (e) {
    throw Exception("Error fetching news: $e");
  }
});
