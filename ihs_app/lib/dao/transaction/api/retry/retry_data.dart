// ignore_for_file: constant_identifier_names

enum RetryOption { NONE, ONCE, WITH_BACK_OFF, USER, USER_RETRY_ONLY }

class RetryData {
  const RetryData(this.option, this.userMessage);

  const RetryData.userOnly(this.userMessage)
      : option = RetryOption.USER_RETRY_ONLY;
  const RetryData.user(this.userMessage) : option = RetryOption.USER;
  const RetryData.none()
      : option = RetryOption.NONE,
        userMessage = 'A connection error occured.';

  /// The default retry setting which will prompt the user
  /// as to whether a retry should occur.
  static const RetryData defaultRetry =
      RetryData(RetryOption.USER, 'A connection error occured.');

  final RetryOption option;
  final String? userMessage;
}
