import 'dart:convert';
import '../../../entities/priced_did_range.dart';
import '../../../entities/region.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetDIDChoices extends CustomAction<List<PricedDIDRange>> {
  // final var repository = repos.

  final Region region;

  ActionGetDIDChoices(this.region);
  @override
  List<PricedDIDRange> decodeResponse(ActionResponse data) {
    var results = <PricedDIDRange>[];

    for (var entity in data.entityList) {
      results.add(PricedDIDRange.fromJson(entity as Map<String, Object>));
    }

    return results;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'getDIDChoices';
    map[Action.MUTATES] = causesMutation;
    map['region'] = region;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [];

  @override
  Future<List<PricedDIDRange>> run() async {
    var action = ActionGetDIDChoices(region);
    await Repository.findTransaction(null).addAction(action);
    return action.future;
  }

  PricedDIDRange fromJson(Map<String, dynamic> json) {
    return PricedDIDRange.fromJson(json);
  }
}
