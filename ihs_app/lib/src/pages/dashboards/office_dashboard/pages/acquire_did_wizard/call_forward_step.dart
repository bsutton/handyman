import 'package:flutter/material.dart';
import '../../../../../dao/entities/call_forward_target.dart';

import '../../../../../dao/types/er.dart';
import '../../../../../util/log.dart';
import '../../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../../widgets/wizard_step.dart';

///
/// A page that allows a user to acquire a new DID
///
class CallForwardStep extends WizardStep {

  CallForwardStep(this.settings) : super(title: 'Action');
  ER<CallForwardTarget> settings;
  static const providerName = 'call_forward_step';

  @override
  Widget build(BuildContext context) => ListTileTheme(
        selectedColor: Colors.red,
        child: SizedBox(
            // height: height,
            child: Column(children: [CallForwardPanelV2<CallForwardStepState>(settings, initiallyOpen: true)])));

  void onChange() {}
}

class CallForwardStepState extends CallForwardMiniRowState {
  CallForwardStepState()
      : super(saveHandler: (_) {
          Log.d('SaveHandler ignored');
          return Future.value();
        });
}
