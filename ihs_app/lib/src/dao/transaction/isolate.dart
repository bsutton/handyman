import 'dart:isolate';

import '../../app/service_locator.dart';
import '../../util/log.dart';
import 'api/http_protocol.dart';
import 'transaction.dart';
import 'transport.dart';

class TransportIsolate {
  static late SendPort isolateSendPort;
  static late Isolate isolate;

  Future<List<ActionResponse>> isolateSend(RequestSenderData data) async {
    // create isolate
    data..basePath = '/micropbx/rest/flutterService2/'
    ..host = ServiceLocator.getPersistentKeyStore().getServerAPIFQDN()
    ..httpProtocol = ServiceLocator.serverHttpProtocol;

    Log.w('Sending request to isolate');
    // send request to isolate
    final port = ReceivePort();
    isolateSendPort
        .send(CrossIsolatesMessage<RequestSenderData, List<ActionResponse>>(
      sendPort: port.sendPort,
      message: data,
    ));

    // wait for reply
    final dynamic t = await port.first;
    Log.w('Got response from isolate');
    return Future.value(t as List<ActionResponse>);
  }

  // ignore: unused_element
  Future<void> _createIsolate() async {
    Log.w('Creating isolate');
    final isolateReceivePort = ReceivePort();
    isolate = await Isolate.spawn(
      _isolateRequestSender,
      isolateReceivePort.sendPort,
      debugName: 'Transport',
    );
    isolateSendPort = (await isolateReceivePort.first) as SendPort;
    Log.w('Isolate is now ready');
  }
}

class RequestSenderData {
  RequestSenderData(this.serviceUrl, this.params, this.body);
  String? basePath;
  HttpProtocol? httpProtocol;
  String? host;
  String serviceUrl;
  Map<String, String> params;
  String body;
}

Future<void> _isolateRequestSender(SendPort callerSendPort) async {
  // pass port out
  final callbackIsolateReceivePort = ReceivePort();
  callerSendPort.send(callbackIsolateReceivePort.sendPort);

  // listen for jobs to process
  callbackIsolateReceivePort.listen((dynamic crossIsolateMessage) {
    final incomingMessage = crossIsolateMessage
        as CrossIsolatesMessage<RequestSenderData, List<ActionResponse>>;

    Log.w('Isolate starting http(s) request');
    final requestData = incomingMessage.message;

    // init transport
    final transport = Transport(requestData.host!, requestData.httpProtocol!,
        basePath: requestData.basePath!);

    transport
        .request(requestData.serviceUrl, requestData.params, requestData.body)
        .then((rawResponse) {
      Log.w('Isolate recieved http(s) response ${rawResponse.length}');
      final decodedData = decodeActionResponses(rawResponse);
      Log.w('Isolate finished deocding http(s) response');
      incomingMessage.sendPort.send(decodedData);
      Log.w('Isolate finished sending decoded http(s) response');
    }).catchError((dynamic e) {
      Log.e(e.toString());
    });
  });
}

class CrossIsolatesMessage<T, R> {
  CrossIsolatesMessage({
    required this.message,
    required this.sendPort,
  });
  final T message;
  final SendPort sendPort;
}
