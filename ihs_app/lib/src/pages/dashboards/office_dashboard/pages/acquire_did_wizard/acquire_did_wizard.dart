import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../../app/app_scaffold.dart';
import '../../../../../app/router.dart';
import '../../../../../dao/entities/call_forward_target.dart';
import '../../../../../dao/entities/did_allocation.dart';
import '../../../../../dao/entities/priced_did_range.dart';
import '../../../../../dao/entities/region.dart';
import '../../../../../dao/repository/repos.dart';
import '../../../../../dao/types/er.dart';
import '../../../../../util/ref.dart';
import '../../../../../widgets/wizard.dart';
import '../../../../../widgets/wizard_step.dart';
import '../../../dashboard_page.dart';
import '../../dashboard/office_page_thumb_menu.dart';
import 'call_forward_step.dart';
import 'select_did_step.dart';
import 'select_region_step.dart';

///
/// A page that allows a user to acquire a new DID
///
class AcquireDIDWizard extends StatefulWidget {
  const AcquireDIDWizard({super.key});

  static const RouteName routeName = RouteName('acquiredidwizard');

  @override
  State<StatefulWidget> createState() => AcquireDIDWizardState();
}

class AcquireDIDWizardState extends State<AcquireDIDWizard> {
  AcquireDIDWizardState();
  final List<WizardStep> steps = [];

  // choice made during the wizard.
  // CompleterEx<Region> regionFetched = CompleterEx();
  FutureRef<Region> selectedRegion = FutureRef();
  Ref<PricedDIDRange> selectedPricedDID = Ref(null);
  ER<CallForwardTarget> target = ER(CallForwardTarget.forInsert());

  @override
  void initState() {
    super.initState();

    steps.add(SelectRegionStep(selectedRegion));
    steps.add(SelectDIDStep(selectedRegion, selectedPricedDID));
    steps.add(CallForwardStep(target));
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => FutureBuilderEx<void>(
            future: resolve,
            builder: (context, _) => DashboardPage(
                title: 'Purchase Phone No.',
                currentRouteName: AcquireDIDWizard.routeName,
                builder: (context) =>
                    Wizard(initialSteps: steps, onFinished: onComplete),
                thumbMenu: OfficePageThumbMenu()),
          ));

  Future<void> onComplete(WizardCompletionReason reason) async {
    if (reason == WizardCompletionReason.completed) {
      final user = await Repos().user.loggedInUser;
      final customer = await user.owner!.resolve;
      if (customer != null) {
        await DIDAllocation.assign(
            customer, selectedPricedDID.obj!, target.entity);
      }
    }
    SQRouter().pop<void>();
  }

  Future<void> resolve() async {
    // return Resolver().untilResolved(() async {
    await Future.wait([
      Repos()
          .region
          .defaultRegion
          .then((region) => selectedRegion.obj = region!),
      target.resolve
    ]);

    target.entity.colleague = ER.fromGUID(Repos().user.viewAsUser);
    target.entity.forwardCallsTo = ForwardCallsTo.coleague;
    //   });
  }
}

class Resolver {
  Future<void> untilResolved(Future<void> Function() func) async {
    await func();
  }
}
