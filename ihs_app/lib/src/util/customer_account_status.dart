enum CustomerAccountStatus {
  /// The customer has started to register but has not completed the
  /// registration process.
  REGISTRATION_PENDING,

  /// The user is conducting a trial
  IN_TRIAL,

  /// the users trial will expire in 3 days.
  TRIAL_EXPIRING_SOON,

  /// The trial has expired the user must re-register.
  TRIAL_EXPIRED,

  /// The customer has transitioned from trial to a customer.
  /// This is the most common state.
  SUBSCRIBED,

  /// a customer payment failed but they are still in the grace period.
  PAYMENT_FAILED,

  /// the user is subscribed but a CC payment failed some time ago.
  SUSPENSION_PENDING,

  /// a customer payment failed and we will suspend if they don't rectify.
  SUSPENDED,

  /// customer cancelled their subscription.
  CUSTOMER_CANCELLED,

  /// The cusomter is active but this users account has been deleted.
  USER_DELETED,

  /// the customer is active but this user's account has been disabled.
  USER_DISABLED,

  /// an unexpected error occured.
  UNKNOWN_STATE,
}

extension CustomerAccountStatusHelper on CustomerAccountStatus {
  static bool isCustomerActive(CustomerAccountStatus status) {
    return status == CustomerAccountStatus.IN_TRIAL ||
        status == CustomerAccountStatus.TRIAL_EXPIRING_SOON ||
        status == CustomerAccountStatus.SUBSCRIBED ||
        status == CustomerAccountStatus.PAYMENT_FAILED ||
        status == CustomerAccountStatus.SUSPENSION_PENDING;
  }
}
