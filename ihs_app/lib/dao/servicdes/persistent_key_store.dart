// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistentKeyStore {
  String? getApiKey();
  bool hasApiKey();
  void setApiKey(String key);
  void setNjcontactApiHost(String host);

  String? getString(String key);
  void setString(String key, String value);
  String? getNjcontactApiHost();
}

enum Keys {
  API_KEY,

  NJCONTACT_API_HOST,
}

class PersistentKeyStoreImpl extends PersistentKeyStore {
  PersistentKeyStoreImpl(this.prefs);
  SharedPreferences prefs;

  @override
  String? getApiKey() {
    var tmp = prefs.getString(Keys.API_KEY.toString());
    if (tmp != null && tmp.isEmpty) {
      tmp = null;
    }
    return tmp;
  }

  @override
  bool hasApiKey() => getApiKey() != null;

  @override
  Future<void> setApiKey(String key) async {
    await prefs.setString(Keys.API_KEY.toString(), key);
  }

  @override
  String? getString(String key) => prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  @override
  String? getNjcontactApiHost() =>
      prefs.getString(Keys.NJCONTACT_API_HOST.toString());

  @override
  Future<void> setNjcontactApiHost(String host) async {
    await prefs.setString(Keys.NJCONTACT_API_HOST.toString(), host);
  }
}
