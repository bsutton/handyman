import 'dart:async';
import 'dart:convert';

import '../../app/service_locator.dart';
import '../../util/enum_helper.dart';
import '../transaction/api/http_protocol.dart';
import '../transaction/api/retry/retry_data.dart';
import '../transaction/api/retry/retry_helper.dart';
import '../transaction/transport.dart';

// This is the NjContactClient and it's special, it communicates
// directly with njadmin and it
// doesn't use Entities at all so
// it won't be registered. It also doesn't get wrapped up in
// transactions as it does things like long polling
class SystemRepository {
  SystemRepository() {
    transport = Transport(
        ServiceLocator.getPersistentKeyStore().getServerAPIFQDN()!,
        ServiceLocator.serverHttpProtocol,
        basePath: (ServiceLocator.serverHttpProtocol == HttpProtocol.https
            ? '/njadmin/rest/mpbx/'
            : '/njadmin/rest/mpbx/'));
  }
  late Transport transport;

  Future<EntityList<CallConfig>> initiateCall(
          String target, RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        params['target'] = target;
        return transport.request('initiateCall', params, '').then((data) =>
            EntityList<CallConfig>.fromJson(
                json.decode(data) as Map<String, dynamic>,
                CallConfig.fromJson));
      }, retryData);

  Future<EntityList<CallConfig>> readyForCall(
          String deliveryTech, RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        params['deliveryTech'] = deliveryTech;
        return transport.request('readyForCall', params, '').then((data) =>
            EntityList<CallConfig>.fromJson(
                json.decode(data) as Map<String, dynamic>,
                CallConfig.fromJson));
      }, retryData);

  Future<EntityList<SipConfig>> getConfig(
          String fireBaseToken, String deviceName, RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        params['fireBaseToken'] = fireBaseToken;
        params['deviceName'] = deviceName;
        return transport.request('getConfig', params, '').then((data) =>
            EntityList<SipConfig>.fromJson(
                json.decode(data) as Map<String, dynamic>, SipConfig.fromJson));
      }, retryData);

  Future<EntityList<SnapShot>> inCallWaitForEvent(
          int lastSequenceNumber, RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        params['lastSequenceNumber'] = lastSequenceNumber.toString();
        return transport.request('inCallWaitForEvent', params, '').then(
            (data) => EntityList<SnapShot>.fromJson(
                json.decode(data) as Map<String, dynamic>, SnapShot.fromJson));
      }, retryData);

  Future<EntityList<InboundCallData>> checkForInboundCall(
          RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        return transport.request('checkForInboundCall', params, '').then(
            (data) => EntityList<InboundCallData>.fromJson(
                json.decode(data) as Map<String, dynamic>,
                InboundCallData.fromJson));
      }, retryData);

  Future<StandardApiResponse> inCallHangup(RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        return transport.request('inCallHangup', params, '').then((data) =>
            StandardApiResponse.fromJson(
                json.decode(data) as Map<String, dynamic>));
      }, retryData);

  Future<StandardApiResponse> inCallHold(RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        return transport.request('inCallHold', params, '').then((data) =>
            StandardApiResponse.fromJson(
                json.decode(data) as Map<String, dynamic>));
      }, retryData);

  Future<StandardApiResponse> inCallUnHold(RetryData retryData) =>
      RetryHelper.exec(() {
        final params = _params('');
        return transport.request('inCallUnHold', params, '').then((data) =>
            StandardApiResponse.fromJson(
                json.decode(data) as Map<String, dynamic>));
      }, retryData);

  Map<String, String> _params(String entity) {
    final params = {
      'entity': entity,
    };
    final apiKey = ServiceLocator.getPersistentKeyStore().getApiKey();
    if (apiKey != null) {
      params['apiKey'] = apiKey;
    }
    return params;
  }
}

class StandardApiResponse {
  StandardApiResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] as int;
    message = json['message'] as String;
    data = json['data'] as String;
  }
  late int code;
  late String message;
  late String data;
}

class EntityList<T> {
  EntityList.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic> data) entityConverter) {
    response = StandardApiResponse.fromJson(json);
    type = json['type'] as String;
    var list = json['entities'] as List<dynamic>?;
    list ??= <dynamic>[];
    for (final value in list) {
      entities.add(entityConverter(value as Map<String, dynamic>));
    }
  }
  late StandardApiResponse response;
  late String type;
  late List<T> entities = [];
}

class InboundCallData {
  late String clid;
  late bool hasCall;

  // ignore: prefer_constructors_over_static_methods
  static InboundCallData fromJson(Map<String, dynamic> json) {
    final clid = json['clid'] as String;
    final hasCall = json['hasCall'] as bool;
    final inboundCallData = InboundCallData();
    inboundCallData.clid = clid;
    inboundCallData.hasCall = hasCall;
    return inboundCallData;
  }
}

class SnapShot {
  late MpbxCallStatusEnum state;
  late int sequenceNumber;

  // ignore: prefer_constructors_over_static_methods
  static SnapShot fromJson(Map<String, dynamic> json) {
    final snapShot = SnapShot();
    final state = json['state'] as String;
    snapShot.state = EnumHelper.getEnum(state, MpbxCallStatusEnum.values);

    snapShot.sequenceNumber = json['sequenceNumber'] as int;
    return snapShot;
  }
}

enum MpbxCallStatusEnum {
  registered,
  identified,

  ringing,
  dialing,
  hangup,
  exiting,
  connected,
  hold,
  unknown
}

class CallConfig {
  late String did;
  late String challengeDtmf;

  // ignore: prefer_constructors_over_static_methods
  static CallConfig fromJson(Map<String, dynamic> json) {
    final callConfig = CallConfig();
    callConfig.did = json['did'] as String;
    callConfig.challengeDtmf = json['challengeDtmf'] as String;
    return callConfig;
  }
}

class SipConfig {
  late String serverHost;
  late int serverPort;
  late String stunSettings;
  late String exten;
  late String password;
  late String protocol;
  late String proxyHost;
  late String proxyPort;

  // ignore: prefer_constructors_over_static_methods
  static SipConfig fromJson(Map<String, dynamic> json) {
    final config = SipConfig();
    final json2 = json['serverPort'] as String;
    config.serverPort = int.parse(json2);
    config.serverHost = json['serverHost'] as String;
    config.stunSettings = json['stunSettings'] as String;
    config.exten = json['exten'] as String;
    config.password = json['password'] as String;
    config.protocol = json['protocol'] as String;
    config.proxyHost = json['proxyHost'] as String;
    config.proxyPort = json['proxyPort'] as String;
    return config;
  }

  @override
  String toString() {
    final desc =
        'serverHost $serverHost\n serverPort $serverPort\n stunSettings $stunSettings\n '
        ' exten $exten\n password $password\n protocol $protocol\n proxyHost $proxyHost\n proxyPort $proxyPort';
    return desc;
  }
}
