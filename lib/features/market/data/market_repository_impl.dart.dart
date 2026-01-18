import 'dart:convert';

import 'package:chain_flow/features/market/domain/market_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MarketRepositoryImpl implements MarketRepository {
  @override
  Stream<List<CoinEntity>> watchAllPrices() {
    final channel = WebSocketChannel.connect(
        Uri.parse('wss://stream.binance.com:9443/ws/!ticker@arr'));

    return channel.stream.map((event) {
      final List data = jsonDecode(event);
      return data
          .where((item) => item['s'].toString().endsWith('USDT'))
          .map((item) => CoinEntity(
                symbol: item['s'].replaceAll('USDT', ''),
                price: double.parse(item['c']),
                percentChange: double.parse(item['P']),
                high: double.parse(item['h']),
                low: double.parse(item['l']),
                volume: double.parse(item['q']),
              ))
          .toList();
    });
  }
}
