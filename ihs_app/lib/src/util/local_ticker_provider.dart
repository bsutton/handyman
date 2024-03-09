import 'package:flutter/scheduler.dart';

class LocalTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback tickerCallback) {
    return Ticker(tickerCallback);
  }
}
