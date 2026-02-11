import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:booking_request/booking_request.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

import 'config.dart';

class BookingRequestStore {
  static Future<void> _writeChain = Future.value();

  Future<T> _queue<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _writeChain = _writeChain.then((_) async {
      try {
        completer.complete(await action());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  String get _path => Config().bookingRequestsPath;

  String get _lockName => 'booking-requests';

  String? get _lockPath {
    final parent = dirname(_path);
    return parent.isEmpty ? null : parent;
  }

  Future<T> _withLock<T>(Future<T> Function() action) async {
    final lock = NamedLock(
      name: _lockName,
      lockPath: _lockPath,
      description: 'booking requests store',
    );
    late T result;
    await lock.withLockAsync(() async {
      result = await action();
    });
    return result;
  }

  Future<List<BookingRequest>> _listAllUnlocked() async {
    final file = File(_path);
    if (!file.existsSync()) {
      await _ensureParentDir();
      await file.writeAsString(jsonEncode([]));
      return <BookingRequest>[];
    }

    final contents = await file.readAsString();
    if (contents.trim().isEmpty) {
      return <BookingRequest>[];
    }
    final decoded = jsonDecode(contents) as List<dynamic>;
    return decoded
        .map(
          (e) => BookingRequest.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<List<BookingRequest>> listAll() =>
      _queue(() => _withLock(_listAllUnlocked));

  Future<List<BookingRequest>> listNew() async {
    final all = await listAll();
    return all.where((r) => !r.imported).toList();
  }

  Future<BookingRequest> add({
    required String businessName,
    required String firstName,
    required String surname,
    required String email,
    required String phone,
    required String description,
    required String street,
    required String suburb,
    required String day1,
    required String day2,
    required String day3,
  }) => _queue(
    () => _withLock(() async {
      final all = await _listAllUnlocked();
      final request = BookingRequest(
        id: _generateId(),
        createdAt: DateTime.now().toUtc(),
        businessName: businessName,
        firstName: firstName,
        surname: surname,
        email: email,
        phone: phone,
        description: description,
        street: street,
        suburb: suburb,
        day1: day1,
        day2: day2,
        day3: day3,
        imported: false,
      );
      all.add(request);
      await _writeAll(all);
      return request;
    }),
  );

  Future<BookingRequest?> getById(String id) => _queue(
    () => _withLock(() async {
      final all = await _listAllUnlocked();
      for (final request in all) {
        if (request.id == id) {
          return request;
        }
      }
      return null;
    }),
  );

  Future<void> markImported(List<String> ids) => _queue(
    () => _withLock(() async {
      final all = await _listAllUnlocked();
      final updated =
          all
              .map(
                (r) =>
                    ids.contains(r.id)
                        ? BookingRequest(
                          id: r.id,
                          createdAt: r.createdAt,
                          businessName: r.businessName,
                          firstName: r.firstName,
                          surname: r.surname,
                          email: r.email,
                          phone: r.phone,
                          description: r.description,
                          street: r.street,
                          suburb: r.suburb,
                          day1: r.day1,
                          day2: r.day2,
                          day3: r.day3,
                          imported: true,
                        )
                        : r,
              )
              .toList();
      await _writeAll(updated);
    }),
  );

  Future<void> _writeAll(List<BookingRequest> requests) async {
    await _ensureParentDir();
    final file = File(_path);
    final payload = requests.map((r) => r.toJson()).toList();
    await file.writeAsString(jsonEncode(payload));
  }

  Future<void> _ensureParentDir() async {
    final parent = dirname(_path);
    if (parent.isEmpty) {
      return;
    }
    await Directory(parent).create(recursive: true);
  }

  String _generateId() {
    final rand = Random.secure();
    final suffix = rand.nextInt(0x7fffffff);
    return '${DateTime.now().millisecondsSinceEpoch}-$suffix';
  }
}
