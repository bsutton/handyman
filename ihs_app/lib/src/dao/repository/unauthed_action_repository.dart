import 'dart:async';

import 'package:flutter/material.dart';

import '../entities/entity.dart';
import '../transaction/api/retry/retry_data.dart';
import '../types/phone_number.dart';
import 'actions/action_activate_first_user.dart';
import 'repository.dart';

///
/// A fake Entity to allow us to use peform unauthorised actions
/// with a repository.
///
///
/// The UnAuthedAction is used by the likes of the registration wizard to send
/// data to the backend whilst we are still unauthenticated.
///
/// NOTE: all unauthed requests MUST passed the FirebaseTempUserUid which
/// is obtained during phase 1 of the firebase signing (mobile has been verified).
///
///  ServiceLocator.getPersistentKeyStore().getFirebaseTempUserUid();

class UnAuthedAction extends Entity<UnAuthedAction> {
  @override
  Map<String, dynamic> toJson() => {};
}

///
/// Not a classic repository but rather an api
/// used by the RegistrationWizard pre-authentication
/// of the user.
///
/// NOTE: all unauthed requests MUST passed the FirebaseTempUserUid which
/// is obtained during phase 1 of the firebase signing (mobile has been verified).
///
///  ServiceLocator.getPersistentKeyStore().getFirebaseTempUserUid();
class UnAuthedActionRepository extends Repository<UnAuthedAction> {
  UnAuthedActionRepository() : super(const Duration(minutes: 5));

  Future<FirstUserDetails> activateFirstUser(BuildContext context,
      GUID progressUUID, PhoneNumber mobileNumber, RetryData retryData) {
    final action = ActionActivateFirstUser<UnAuthedAction>(
        progressUUID, mobileNumber, this, retryData);
    Repository.findTransaction(null).addAction(action);
    return action.future;
  }

  @override
  UnAuthedAction fromJson(Map<String, dynamic> json) {
    throw Exception('Not implemented');
  }
}
