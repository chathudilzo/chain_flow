import 'dart:convert';

import 'package:chain_flow/features/trade/domain/trade_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final tradeTypeProvider = StateProvider<bool>((ref) => true);
final selectedTradeSymbolProvider = StateProvider<String>((ref) => "BTC");
final orderBookProvider =
    StreamProvider.family<Map<String, List<OrderBookEntry>>, String>(
        (ref, symbol) {
  final wsUrl =
      'wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}usdt@depth10@100ms';

  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  ref.onDispose(() => channel.sink.close());

  return channel.stream.map((event) {
    final Map<String, dynamic> data = jsonDecode(event);

    final bidsRaw = data['bids'] as List<dynamic>?;
    final asksRaw = data['asks'] as List<dynamic>?;

    if (bidsRaw == null || asksRaw == null) {
      return {'bids': <OrderBookEntry>[], 'asks': <OrderBookEntry>[]};
    }

    final bids = bidsRaw
        .map((e) => OrderBookEntry(
            price: double.parse(e[0].toString()),
            quantity: double.parse(e[1].toString())))
        .toList();

    final asks = asksRaw
        .map((e) => OrderBookEntry(
            price: double.parse(e[0].toString()),
            quantity: double.parse(e[1].toString())))
        .toList();

    return {'bids': bids, 'asks': asks};
  });
});
