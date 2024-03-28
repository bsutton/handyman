// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

import '../entities/entity.dart';
import '../types/firebase_user_uid.dart';

abstract class PersistentKeyStore {
  // api Key
  String? getApiKey();
  bool hasApiKey();
  void setApiKey(String? key);

  // registrationComplete
  // ignore: avoid_positional_boolean_parameters
  Future<void> setRegistrationComplete(bool complete);
  bool getRegistrationComplete();

  String? getString(String key);
  void setString(String key, String value);

  // server API
  void setServerAPIFQDN(String host);
  String? getServerAPIFQDN();

  void setFirebaseTempUserUid(FirebaseTempUserUid userid);
  FirebaseTempUserUid getFirebaseTempUserUid();

  void setRegistrationGuid(GUID registrationGuid);
  GUID? getRegistrationGuid();

  GUID? getUserGUID();
  void setUserGUID(GUID userGUID);

  void registerUser(
      {required String apiKey,
      required String fireStoreUserToken,
      required GUID userGUID,
      GUID? registrationGUID}) {}
}

enum Keys {
  API_KEY,

  SERVER_API_FQDN,

  REGISTRATION_GUID,
  USER_GUID,

  /// CONSIDER: I think ghis is no longer used.
  /// set to true when a user successfull completes the registration process
  /// If this value is false then we launch the wizard.
  REGISTRATION_COMPLETE,

  FIREBASE_USER_ID,
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
  Future<void> setApiKey(String? key) async {
    await prefs.setString(Keys.API_KEY.toString(), key ?? '');
  }

  @override
  String? getString(String key) => prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  @override
  String? getServerAPIFQDN() =>
      prefs.getString(Keys.SERVER_API_FQDN.toString());

  @override
  Future<void> setServerAPIFQDN(String host) async {
    await prefs.setString(Keys.SERVER_API_FQDN.toString(), host);
  }

  @override
  Future<void> setFirebaseTempUserUid(FirebaseTempUserUid userid) async {
    await prefs.setString(Keys.FIREBASE_USER_ID.toString(), userid.toString());
  }

  @override
  FirebaseTempUserUid getFirebaseTempUserUid() =>
      FirebaseTempUserUid(prefs.getString(Keys.FIREBASE_USER_ID.toString())!);

  @override
  GUID getRegistrationGuid() =>
      GUID(prefs.getString(Keys.REGISTRATION_GUID.toString())!);

  @override
  Future<void> setRegistrationGuid(GUID registrationGuid) async {
    await prefs.setString(
        Keys.REGISTRATION_GUID.toString(), registrationGuid.toString());
  }

  @override
  GUID getUserGUID() => GUID(prefs.getString(Keys.USER_GUID.toString())!);

  @override
  Future<void> setUserGUID(GUID userGUID) async {
    await prefs.setString(Keys.USER_GUID.toString(), userGUID.toString());
  }

  @override
  bool getRegistrationComplete() =>
      prefs.getBool(Keys.REGISTRATION_COMPLETE.toString()) ?? false;

  @override
  Future<void> setRegistrationComplete(bool complete) async {
    await prefs.setBool(Keys.REGISTRATION_COMPLETE.toString(), complete);
  }
}
