enum CustomerAccountStatus {
  /// The customer has started to register but has not completed the
  /// registration process.
  registrationPending,

  /// The user is conducting a trial
  inTrial,

  /// the users trial will expire in 3 days.
  trialExpiringSoon,

  /// The trial has expired the user must re-register.
  trialExpired,

  /// The customer has transitioned from trial to a customer.
  /// This is the most common state.
  subscribed,

  /// a customer payment failed but they are still in the grace period.
  paymentFailed,

  /// the user is subscribed but a CC payment failed some time ago.
  suspensionPending,

  /// a customer payment failed and we will suspend if they don't rectify.
  suspended,

  /// customer cancelled their subscription.
  customerCancelled,

  /// The cusomter is active but this users account has been deleted.
  userDeleted,

  /// the customer is active but this user's account has been disabled.
  userDisabled,

  /// an unexpected error occured.
  unknownState,
}

extension CustomerAccountStatusHelper on CustomerAccountStatus {
  static bool isCustomerActive(CustomerAccountStatus status) =>
      status == CustomerAccountStatus.inTrial ||
      status == CustomerAccountStatus.trialExpiringSoon ||
      status == CustomerAccountStatus.subscribed ||
      status == CustomerAccountStatus.paymentFailed ||
      status == CustomerAccountStatus.suspensionPending;
}
