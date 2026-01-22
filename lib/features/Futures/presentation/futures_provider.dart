import 'dart:convert';

import 'package:chain_flow/features/Futures/domain/future_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final futuresProvider =
    StateNotifierProvider.family<FuturesNotifier, FuturesUIState, String>(
        (ref, symbol) {
  return FuturesNotifier(symbol);
});

class FuturesNotifier extends StateNotifier<FuturesUIState> {
  final String symbol;
  WebSocketChannel? _channel;

  FuturesNotifier(this.symbol)
      : super(FuturesUIState(
            lastPrice: 0,
            markPrice: 0,
            fundingRate: 0,
            leverage: 20,
            isCross: true)) {
    _initStream();
  }

  void _initStream() {
    final cleanSymbol = symbol.toLowerCase() + "usdt";
    final wsUrl =
        'wss://fstream.binance.com/stream?streams=$cleanSymbol@markPrice/$cleanSymbol@ticker';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel!.stream.listen((event) {
      final msg = jsonDecode(event);
      final data = msg['data'];

      if (msg['stream'].contains('@ticker')) {
        state = state.copyWith(lastPrice: double.parse(data['c']));
      } else {
        state = state.copyWith(
          markPrice: double.parse(data['p']),
          fundingRate: double.parse(data['r']),
        );
      }
    });
  }

  void updateLeverage(int val) => state = state.copyWith(leverage: val);
  void toggleMargin() => state = state.copyWith(isCross: !state.isCross);

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
