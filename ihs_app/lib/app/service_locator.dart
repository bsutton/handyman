import 'package:get_it/get_it.dart';
import 'package:money2/money2.dart';
import '../dao/services/persistent_key_store.dart';
import '../dao/transaction/api/http_protocol.dart';
import '../pages/dialer/widgets/call_manager.dart';

GetIt _getIt = GetIt.instance;

class ServiceLocator {
  static const ServiceLocator _self = ServiceLocator._internal();
  static Currency aud = Currency.create('AUD', 2);

  static CallManager _callManager;

  static HttpProtocol njcontactHttpProtocol = HttpProtocol.HTTPS;
  static HttpProtocol micropbxHttpProtocol = HttpProtocol.HTTPS;

  // If set to true then we won't make any calls to the Noojee Contact system.
  static bool njcontactSuppressCalls = false;

  factory ServiceLocator() {
    return _self;
  }

  const ServiceLocator._internal();

  static PersistentKeyStore getPersistentKeyStore() {
    return _getIt.get<PersistentKeyStore>();
  }

  static Future<void> initServiceLocator(PersistentKeyStore keyStore) async {
    _getIt.registerSingleton<PersistentKeyStore>(keyStore);
  }

  static CallManager getCallManager() {
    _callManager ??= CallManager();
    return _callManager;
  }
}
