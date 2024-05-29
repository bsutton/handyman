import 'package:get_it/get_it.dart';
import 'package:money2/money2.dart';

import '../dao/services/persistent_key_store.dart';
import '../dao/transaction/api/http_protocol.dart';

GetIt _getIt = GetIt.instance;

class ServiceLocator {
  factory ServiceLocator() => _self;

  const ServiceLocator._internal();
  static const ServiceLocator _self = ServiceLocator._internal();
  static Currency aud = Currency.create('AUD', 2);

  static HttpProtocol serverHttpProtocol = HttpProtocol.https;

  // If set to true then we won't make any calls to the Noojee Contact system.
  static bool suppressCalls = false;

  static PersistentKeyStore getPersistentKeyStore() =>
      _getIt.get<PersistentKeyStore>();

  static Future<void> initServiceLocator(PersistentKeyStore keyStore) async {
    _getIt.registerSingleton<PersistentKeyStore>(keyStore);
  }
}
