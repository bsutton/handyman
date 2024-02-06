import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../transaction/transaction.dart';
import '../non_entity_repository.dart';
import 'action.dart';

@immutable
class ActionSendEmail extends CustomAction<SendEmailResponse> {
  final String from;
  final List<String> to;
  final List<String> cc;
  final List<String> bcc;

  final String plainBody;
  final String htmlBody;

  ActionSendEmail({@required this.from, @required this.to, this.bcc, this.cc, this.plainBody, this.htmlBody});

  @override
  SendEmailResponse decodeResponse(ActionResponse response) {
    return SendEmailResponse(response.success, response.exception);
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'sendEmail';
    map[Action.MUTATES] = causesMutation;
    map['details'] = toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [];

  @override
  Future<SendEmailResponse> run() async {
    return await NonEntityRepository().taskAction(this);
  }

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
  bool success;
  // If success if false then this will contain an error message.
  String exception;

  // ignore: avoid_positional_boolean_parameters
  SendEmailResponse(this.success, this.exception);
}
