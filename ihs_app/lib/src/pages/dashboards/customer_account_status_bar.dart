import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../app/router.dart';
import '../../dao/entities/customer.dart';
import '../../dao/repository/repos.dart';
import '../../dao/repository/user_repository.dart';
import '../../dao/transaction/api/retry/retry_data.dart';
import '../../dao/transaction/transaction.dart';
import '../../registration_wizard/re_registration.dart';
import '../../registration_wizard/registration_type_page.dart';
import '../../registration_wizard/state_machine/registration_fsm.dart';
import '../../util/customer_account_status.dart';
import '../../util/format.dart';
import '../../util/local_date.dart';
import '../../util/schedule_now.dart';
import '../../widgets/empty.dart';
import '../../widgets/theme/nj_button.dart';
import '../../widgets/theme/nj_text_themes.dart';
import '../../widgets/theme/nj_theme.dart';
import '../account_status/payment_failed_page.dart';
import '../account_status/pending_suspension_page.dart';
import '../account_status/suspended_page.dart';
import '../account_status/trail_expiring_page.dart';
import '../account_status/trial_expired_page.dart';
import '../error_page.dart';
import 'user_dashboard/pages/user_deleted_page.dart';
import 'user_dashboard/pages/user_disabled_page.dart';

class CustomerAccountStatusBar extends StatelessWidget {
  CustomerAccountStatusBar({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilderEx<CustomerAccountStatus>(
        future: () async => Repos().unAuthedActions.getCustomerAccountStatus(
            await UserRepository().loggedInUser, RetryData.defaultRetry),
        waitingBuilder: (context) => const Empty(),
        builder: (context, customerAccountStatus) =>
            buildBar(customerAccountStatus!),
        errorBuilder: (context, error) {
          scheduleNow(() async => SQRouter()
              .replaceWithNamedAndArg(ErrorPage.routeName, error.toString()));
          return const Empty();
        },
      );

  Future<Customer?> getCustomer() async {
    try {
      return await (await Repos().user.loggedInUser).owner!.resolve;
    } on AuthException catch (_) {
      // If the apiKey is not attached to a valid user
      // then we will get an error.
      // This can occur if a user's account has been disabled
      // or deleted.
      // If this occurs all things stop and we send them to the
      // re-registration page.
      await SQRouter().replaceWithNamed(ReRegistrationPage.routeName);

      /// not certain what rethrow will do here?
      rethrow;
    }
  }

  /// Selet which 'first' page to send the user to based on their
  /// current status include:
  /// Registration
  /// Re-registration
  /// Trial Expiring in less than 3 days.
  /// Trial Expired
  /// Payment failed - for 3 days post billing attempt.
  ///  tell them they are late option to pay, but let them in.
  /// Pending Suspension - bill unpaid for more than 3 days but less than 7
  ///   The user can take calls but can't make calls or change settings.
  ///   offer to take new credit card
  ///
  /// Suspended - bill unpaid for more than 7 days
  ///  - can't make or take calls - offer to take new credit card.
  ///
  Widget buildBar(CustomerAccountStatus customerAccountStatus) {
    Widget content = const Empty();

    switch (customerAccountStatus) {
      case CustomerAccountStatus.registrationPending:
        // This path shouldn't normally be executed as the
        // call to getMobileRegistration should have already detected
        // this state.
        scheduleNow(() => RegistrationFSM()
            .applyEvent(OnForceRegistration(RegistrationType.notSelected)));
        break;
      case CustomerAccountStatus.subscribed:
      case CustomerAccountStatus.inTrial:
        break;
      case CustomerAccountStatus.trialExpiringSoon:
        content = expiryBuilder(
            customerAccountStatus, TrialExpiringPage.routeName, Level.warning);
        break;
      case CustomerAccountStatus.trialExpired:
        content = expiryBuilder(
            customerAccountStatus, TrialExpiredPage.routeName, Level.error);
        break;
      case CustomerAccountStatus.paymentFailed:
        content = buildContent(NJTextSubheading('You payment failed.'),
            PaymentFailedPage.routeName, 'Pay Now', Level.warning);
        break;
      case CustomerAccountStatus.suspensionPending:
        content = FutureBuilderEx(
            future: () async => pendingSuspensionMessage(),
            builder: (context, data) => buildContent(data!,
                PendingSuspensionPage.routeName, 'Pay Now', Level.error));
        break;
      case CustomerAccountStatus.suspended:
        content = buildContent(NJTextSubheading('Account suspended.'),
            SuspendedPage.routeName, 'Pay Now', Level.error);
        break;

      case CustomerAccountStatus.customerCancelled:
        // This path shouldn't normally be executed as the
        // call to getMobileRegistration should have already detected
        // this state.
        scheduleNow(() async =>
            SQRouter().replaceWithNamed(ReRegistrationPage.routeName));
        break;
      case CustomerAccountStatus.userDeleted:
        scheduleNow(
            () async => SQRouter().replaceWithNamed(UserDeletedPage.routeName));

        break;
      case CustomerAccountStatus.userDisabled:
        scheduleNow(() async =>
            SQRouter().replaceWithNamed(UserDisabledPage.routeName));
        break;
      case CustomerAccountStatus.unknownState:
        scheduleNow(() async =>
            SQRouter().replaceWithNamedAndArg(ErrorPage.routeName, ''));
        break;
    }
    return content;
  }

  FutureBuilderEx<Customer?> expiryBuilder(
          CustomerAccountStatus customerAccountStatus,
          RouteName routeName,
          Level level) =>
      FutureBuilderEx<Customer?>(
        future: getCustomer,
        waitingBuilder: (context) => const Empty(),
        builder: (context, customer) => buildContent(
            expiryDetails(customerAccountStatus, customer!),
            routeName,
            'Activate',
            level),
      );

  final Map<Level, ColorPair> colorScheme = {
    Level.error: ColorPair(NJColors.errorBackground, NJColors.errorText),
    Level.warning: ColorPair(NJColors.alertBackground, NJColors.alertText),
    Level.notice: ColorPair(NJColors.defaultBackground, NJColors.textPrimary),
  };

  Widget buildContent(
      Widget message, RouteName routeName, String buttonLabel, Level level) {
    final activate = Padding(
        padding: const EdgeInsets.only(right: NJTheme.padding),
        child: NJButtonPrimary(
          label: buttonLabel,
          onPressed: () async => SQRouter().pushNamed(routeName),
        ));
    return ColoredBox(
      color: colorScheme[level]!.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [message, activate],
      ),
    );
  }

  Widget expiryDetails(
      CustomerAccountStatus customerAccountStatus, Customer customer) {
    final expiryDate = customer.trialExpiryDate;
    final today = LocalDate.today();
    final daysRemaining = expiryDate!.subtractDays(3).isBefore(today);

    String message;
    var color = NJColors.textPrimary;

    if (customerAccountStatus == CustomerAccountStatus.trialExpired) {
      message = 'Trial has expired';
      color = NJColors.errorText;
    } else if (expiryDate.isEqual(today)) {
      message = 'Trial expires today';
      color = NJColors.errorText;
    } else if (customerAccountStatus ==
        CustomerAccountStatus.trialExpiringSoon) {
      if (daysRemaining) {
        message = 'Trial expires in $daysRemaining day';
      } else {
        message = 'Trial expires in $daysRemaining days';
      }
      color = NJColors.alertText;
    } else {
      message = 'Trial expires ${Format.onDate(expiryDate, abbr: true)}';
      color = NJColors.alertText;
    }

    return NJTextSubheading(message, color: color);
  }

  // var customerguid = (await UserRepository().loggedInUser).owner!.guid;
  // var customer = await Repos().customer.getByGUID(customerguid);
  // var suspensionDate = customer.suspensionDate;
  // suspensionDate ??= LocalDate.today();
  Future<Widget> pendingSuspensionMessage() async =>
      NJTextSubheading('Urgent action required!');
}

enum Level { error, warning, notice }

class ColorPair {
  ColorPair(this.background, this.foreground);
  Color background;
  Color foreground;
}
