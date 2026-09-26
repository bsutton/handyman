import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Persist before issuing an ACME request, so failures and crashes cannot turn
/// the supervisor's restart loop into repeated authorization attempts.
class CertificateRequestBackoff {
  CertificateRequestBackoff(this.directory, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final Directory directory;
  final DateTime Function() _now;

  Future<bool> request(String domain, Future<bool> Function() issue) async {
    final retryAfter = _update(domain, (state) {
      final now = _now().toUtc();
      if (state != null && now.isBefore(state.retryAfter)) {
        throw CertificateRequestDeferred(domain, state.retryAfter);
      }
      final failures = min((state?.failures ?? 0) + 1, 6);
      return _Attempt(
        failures,
        now.add(Duration(hours: min(1 << (failures - 1), 24))),
      );
    })!.retryAfter;
    final success = await issue();
    if (success) {
      _update(
        domain,
        (state) => state?.retryAfter == retryAfter ? null : state,
      );
    }
    return success;
  }

  _Attempt? _update(String domain, _Attempt? Function(_Attempt?) update) {
    directory.createSync(recursive: true);
    final key = base64Url.encode(utf8.encode(domain.toLowerCase()));
    final file = File('${directory.path}/$key.json');
    final lock = File(
      '${directory.path}/$key.lock',
    ).openSync(mode: FileMode.append);
    try {
      lock.lockSync(FileLock.blockingExclusive);
      _Attempt? state;
      if (file.existsSync()) {
        // Invalid/unreadable state fails closed: never discard it and contact
        // the CA, as that would remove the protection during a disk failure.
        final json =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final failures = json['failures'] as int;
        if (failures < 1 || failures > 6) {
          throw const FormatException('Invalid ACME retry state.');
        }
        state = _Attempt(
          failures,
          DateTime.parse(json['retryAfter'] as String).toUtc(),
        );
      }
      final next = update(state);
      if (next == null) {
        if (file.existsSync()) {
          file.deleteSync();
        }
      } else {
        File('${file.path}.$pid.tmp')
          ..writeAsStringSync(
            jsonEncode({
              'failures': next.failures,
              'retryAfter': next.retryAfter.toIso8601String(),
            }),
            flush: true,
          )
          ..renameSync(file.path);
      }
      return next;
    } finally {
      lock.closeSync();
    }
  }
}

class CertificateRequestDeferred implements Exception {
  CertificateRequestDeferred(this.domain, this.retryAfter);

  final String domain;
  final DateTime retryAfter;

  @override
  String toString() =>
      'Certificate request for $domain deferred until '
      '${retryAfter.toIso8601String()} after an earlier attempt. '
      'Check the previous ACME validation failure before retrying.';
}

class _Attempt {
  _Attempt(this.failures, this.retryAfter);

  final int failures;
  final DateTime retryAfter;
}
