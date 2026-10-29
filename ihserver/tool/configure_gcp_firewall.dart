#! /usr/bin/env dcli

import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';

/// Limit Handyman HTTP and HTTPS to Cloudflare and the administrator's home.
/// Preview by default; an operator must pass --apply to update GCP.
Future<void> main(List<String> args) async {
  if (args.length > 1 || (args.isNotEmpty && args.single != '--apply')) {
    stderr.writeln('Usage: ./tool/configure_gcp_firewall.dart [--apply]');
    exitCode = 2;
    return;
  }

  const project = 'production-365402';
  const network =
      'https://www.googleapis.com/compute/v1/projects/'
      '$project/global/networks/handyman-dual-stack';
  const home = '2401:d002:350c:8100::/56';
  final ranges = await _cloudflareIpv6Ranges();
  final desired = <String>{...ranges, home}.toList()..sort();
  final changes = <(String, String)>[];

  for (final (name, port, tag) in [
    ('handyman-http-ipv6', '80', 'hmb'),
    ('handyman-allow-https', '443', 'https-server'),
  ]) {
    final text = await _gcloud([
      'compute',
      'firewall-rules',
      'describe',
      name,
      '--project=$project',
      '--format=json',
    ]);
    final rule = jsonDecode(text) as Map<String, dynamic>;
    _verifyRule(rule, name, port, tag, network, desired);
    final current = (rule['sourceRanges'] as List<dynamic>).cast<String>()
      ..sort();
    if (_same(current, desired)) {
      stdout.writeln(
        '$name already allows Cloudflare IPv6 and home on TCP $port.',
      );
      continue;
    }
    stdout.writeln(
      '$name: replace ${current.join(',')} with ${desired.join(',')}',
    );
    changes.add((name, port));
  }

  if (args.isEmpty) {
    stdout.writeln('Preview only. Pass --apply to update both rules.');
    return;
  }
  for (final (name, port) in changes) {
    await _gcloud([
      'compute',
      'firewall-rules',
      'update',
      name,
      '--project=$project',
      '--source-ranges=${desired.join(',')}',
      '--quiet',
    ]);
    stdout.writeln(green('$name updated for TCP $port.'));
  }
}

Future<List<String>> _cloudflareIpv6Ranges() async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(
      Uri.parse('https://www.cloudflare.com/ips-v6'),
    );
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw StateError(
        'Cloudflare IP list returned HTTP ${response.statusCode}.',
      );
    }
    final ranges =
        (await utf8.decoder.bind(response).join())
            .split(RegExp(r'\s+'))
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    if (ranges.length < 5 ||
        ranges.length > 30 ||
        ranges.any((range) => !_validIpv6Cidr(range))) {
      throw StateError('Cloudflare IPv6 list is not in the expected format.');
    }
    return ranges;
  } finally {
    client.close(force: true);
  }
}

bool _validIpv6Cidr(String value) {
  final parts = value.split('/');
  if (parts.length != 2) {
    return false;
  }
  final address = InternetAddress.tryParse(parts[0]);
  final prefix = int.tryParse(parts[1]);
  return address?.type == InternetAddressType.IPv6 &&
      prefix != null &&
      prefix > 0 &&
      prefix <= 128;
}

void _verifyRule(
  Map<String, dynamic> rule,
  String name,
  String port,
  String tag,
  String network,
  List<String> desired,
) {
  final allowed = rule['allowed'] as List<dynamic>?;
  final allowedRule = allowed?.length == 1
      ? (allowed!.single as Map<String, dynamic>)
      : null;
  final tags = (rule['targetTags'] as List<dynamic>?)?.cast<String>() ?? [];
  final current = (rule['sourceRanges'] as List<dynamic>?)?.cast<String>();
  final sourceOkay =
      current != null &&
      ((current.length == 1 && current.single == '::/0') ||
          (current.contains('2401:d002:350c:8100::/56') &&
              current.every(
                (range) =>
                    range == '2401:d002:350c:8100::/56' ||
                    desired.contains(range),
              )));
  if (rule['name'] != name ||
      rule['network'] != network ||
      rule['direction'] != 'INGRESS' ||
      rule['disabled'] != false ||
      rule['priority'] != 1000 ||
      allowedRule == null ||
      allowedRule['IPProtocol'] != 'tcp' ||
      jsonEncode(allowedRule['ports']) != jsonEncode([port]) ||
      tags.length != 1 ||
      tags.single != tag ||
      !sourceOkay) {
    throw StateError('$name differs from the reviewed rule; no update made.');
  }
}

bool _same(List<String> left, List<String> right) =>
    left.length == right.length &&
    List.generate(
      left.length,
      (i) => left[i] == right[i],
    ).every((equal) => equal);

Future<String> _gcloud(List<String> args) async {
  final result = await Process.run('gcloud', args);
  if (result.exitCode != 0) {
    throw StateError('gcloud failed: ${result.stderr}');
  }
  return result.stdout as String;
}
