import 'dart:io';

import 'package:path/path.dart' as path;

typedef ScpCommand = ({String executable, List<String> arguments});

/// Work around gcloud's missing brackets around IPv6 SCP destinations.
/// https://issuetracker.google.com/issues/566267326
/// Keep gcloud's resolved user, identity and host-key options. Remove this
/// workaround when gcloud emits valid IPv6 SCP destinations itself.
/// Already bracketed destinations pass through unchanged.
ScpCommand parseGcloudScp(
  String output, {
  required String source,
  required String destination,
}) {
  final command = output.trim();
  if (command.contains('\n') || !command.endsWith(':$destination')) {
    throw const FormatException('Unexpected gcloud SCP dry-run output.');
  }
  // gcloud prints argv joined with spaces, without shell quoting. Recover the
  // known source/path verbatim instead of shell-parsing (or executing) that text.
  final sourceMarker = ' $source ';
  final sourceOffset = command.lastIndexOf(sourceMarker);
  if (sourceOffset < 0) {
    throw const FormatException('Missing source in gcloud SCP dry-run output.');
  }
  final remote = command.substring(sourceOffset + sourceMarker.length);
  final host = remote.substring(0, remote.length - destination.length - 1);
  if (host.isEmpty || RegExp(r'\s').hasMatch(host)) {
    throw const FormatException('Invalid SCP destination host.');
  }
  final at = host.lastIndexOf('@');
  final user = at < 0 ? '' : host.substring(0, at + 1);
  final address = host.substring(at + 1);
  final ipv6 =
      InternetAddress.tryParse(address)?.type == InternetAddressType.IPv6;
  final corrected = ipv6 ? '$user[$address]:$destination' : remote;

  final prefix = command.substring(0, sourceOffset);
  final firstOption = prefix.indexOf(' -');
  if (firstOption < 0) {
    throw const FormatException(
      'Missing SCP options in gcloud dry-run output.',
    );
  }
  final executable = prefix.substring(0, firstOption);
  if (path.basename(executable) != 'scp') {
    throw const FormatException('Expected an OpenSSH scp command from gcloud.');
  }
  final arguments = <String>[];
  // Only the OpenSSH options generated for our direct recursive upload are
  // supported. Fail closed if gcloud changes format or adds an unfamiliar flag.
  final options = prefix
      .substring(firstOption + 1)
      .split(RegExp(' (?=-[A-Za-z])'));
  for (final option in options) {
    if (option == '-r' || option == '-C') {
      arguments.add(option);
    } else if (option.startsWith('-i ') ||
        option.startsWith('-o ') ||
        option.startsWith('-P ')) {
      final value = option.substring(3);
      if (value.isEmpty) {
        throw const FormatException('Empty SCP option from gcloud.');
      }
      arguments.addAll([option.substring(0, 2), value]);
    } else {
      throw FormatException('Unsupported SCP dry-run option: $option');
    }
  }
  return (executable: executable, arguments: [...arguments, source, corrected]);
}
