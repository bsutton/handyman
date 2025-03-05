import 'package:date_time_format/date_time_format.dart';
import 'package:dcli/dcli.dart';
import 'package:shelf/shelf.dart';
import 'package:yaml/yaml.dart';

import 'config.dart';
import 'logger.dart';
import 'middleware/log_client_ip.dart';

const myIpAddress = '139.218.9.129';

/// Handler to display start records from hmb_starts.yaml for the last 90 days.
Future<Response> handleStart(Request request) async {
  qlog('start requested');
  final clientIp = getClientIp(request);
  qlog('clientIp: $clientIp');
  // Only allow requests from the allowed IP address.
  if (clientIp != myIpAddress && clientIp != '127.0.0.1') {
    return Response.notFound('Not found.');
  }
  if (!exists(Config.hmbStartsYaml)) {
    return Response.notFound('No records found.');
  }

  // Read the entire file.
  final content = read(Config.hmbStartsYaml).toParagraph();

  // Regular expression to capture each YAML record.
  // This assumes each record is exactly three lines:
  //   - A line beginning with "start:" followed by the date in the new format.
  //   - A line beginning with "business name:" followed by the obfuscated
  // business name.
  //   - A line beginning with "app version:" followed by the version.
  // The record ends when a new line starting with "start:" is encountered
  //  or the end of string is reached.
  final recordRegex = RegExp(
    r'(start:\s*.*?\nbusiness name:\s*.*?\napp version:\s*.*?)(?=\nstart:|$)',
    multiLine: true,
    dotAll: true,
  );

  final matches = recordRegex.allMatches(content);
  final records = <Map<String, dynamic>>[];

  print('matches: ${matches.length}');

  for (final match in matches) {
    qlog('match: $match');
    final recordYaml = match.group(0);
    qlog('gorup 0: $recordYaml');
    try {
      // Parse the YAML record.
      final doc = loadYaml(recordYaml!);
      qlog('doc $doc');
      if (doc is YamlMap) {
        // Convert to a regular map.
        records.add(Map<String, dynamic>.from(doc));
      }
    } catch (e) {
      qlog('Error parsing record: $e');
      // Ignore malformed records.
    }
  }

  qlog('records: ${records.length}');

  // Filter records to those with a start date within the last 90 days.
  final now = DateTime.now();
  final cutoff = now.subtract(const Duration(days: 90));

  final filteredRecords =
      records.where((record) {
        try {
          final startStr = record['start'] as String;
          final startDate = DateTime.parse(startStr);
          return startDate.isAfter(cutoff);
        } catch (e) {
          return false;
        }
      }).toList();

  // Generate simple HTML output.
  final buffer =
      StringBuffer()
        ..writeln('<!DOCTYPE html>')
        ..writeln('<html>')
        ..writeln('<head>')
        ..writeln('<meta charset="utf-8">')
        ..writeln('<title>Start Records</title>')
        ..writeln('</head>')
        ..writeln('<body>')
        ..writeln('<h1>Start Records (Last 90 Days)</h1>');

  if (filteredRecords.isEmpty) {
    buffer.writeln('<p>No records found.</p>');
  } else {
    buffer.writeln('<ul>');
    for (final record in filteredRecords) {
      var start = DateTime.tryParse(record['start'] as String);
      start ??= DateTime(1900);
      final formattedStart = DateTimeFormat.format(
        start,
        format: 'Y-M-d h:m a',
      );
      final businessName = record['business name'];
      final appVersion = record['app version'];
      buffer.writeln(
        '<li>Start: $formattedStart &mdash; Business Name: $businessName &mdash; App Version: $appVersion</li>',
      );
    }
    buffer.writeln('</ul>');
  }

  buffer
    ..writeln('</body>')
    ..writeln('</html>');

  return Response.ok(buffer.toString(), headers: {'Content-Type': 'text/html'});
}
