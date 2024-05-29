import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../transaction/transaction.dart';
import '../non_entity_repository.dart';
import 'action.dart';

@immutable
class ActionSendEmail extends CustomAction<SendEmailResponse> {
  ActionSendEmail(
      {required this.from,
      required this.to,
      this.bcc = const <String>[],
      this.cc = const <String>[],
      this.plainBody,
      this.htmlBody});
  final String from;
  final List<String> to;
  final List<String> cc;
  final List<String> bcc;

  final String? plainBody;
  final String? htmlBody;

  @override
  SendEmailResponse decodeResponse(ActionResponse data) =>
      SendEmailResponse(data.success!, data.exception!);

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'sendEmail';
    map[Action.mutatesKey] = causesMutation;
    map['details'] = toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [];

  @override
  Future<SendEmailResponse> run() async =>
      NonEntityRepository().taskAction(this);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': from,
        'to': to,
        'bcc': bcc,
        'cc': cc,
        'plainBody': plainBody,
        'htmlBody': htmlBody,
      };
}

class SendEmailResponse {
  // ignore: avoid_positional_boolean_parameters
  SendEmailResponse(this.success, this.exception);
  bool success;
  // If success if false then this will contain an error message.
  String exception;
}
