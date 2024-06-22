import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../dao/dao_system.dart';
import 'models/models.dart';

class InvoiceException implements Exception {
  InvoiceException(this.message);
  final String message;
}

class XeroAuthScreen extends StatefulWidget {
  const XeroAuthScreen({super.key});

  static const routeName = '/xero-auth';

  @override
  // ignore: library_private_types_in_public_api
  _XeroAuthScreenState createState() => _XeroAuthScreenState();
}

class Credentials {}

class XeroCredentials implements Credentials {
  XeroCredentials(
      {required this.clientId,
      required this.clientSecret,
      required this.redirectUrl});
  String clientId;
  String clientSecret;
  String redirectUrl;
}

class _XeroAuthScreenState extends State<XeroAuthScreen> {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _discoveryUrl =
      'https://identity.xero.com/.well-known/openid-configuration';
  final List<String> _scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
    'accounting.transactions'
  ];

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    unawaited(_checkStoredRefreshToken());
  }

  Future<void> _checkStoredRefreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken != null) {
      await _refreshToken(refreshToken);
    }
  }

  Future<XeroCredentials> _fetchCredentials() async {
    final system = await DaoSystem().get();

    if (system!.xeroClientId == null ||
        system.xeroClientSecret == null ||
        system.xeroRedirectUrl == null) {
      throw InvoiceException('Xero credentials not set');
    }

    return XeroCredentials(
        clientId: system.xeroClientId!,
        clientSecret: system.xeroClientSecret!,
        redirectUrl: system.xeroRedirectUrl!);
  }

  Future<void> _authenticate() async {
    try {
      final credentials = await _fetchCredentials();
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          credentials.clientId,
          credentials.redirectUrl,
          clientSecret: credentials.clientSecret,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
        ),
      );

      setState(() {
        _accessToken = result?.accessToken;
      });

      if (result?.refreshToken != null) {
        await _secureStorage.write(
            key: 'refresh_token', value: result?.refreshToken);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _refreshToken(String refreshToken) async {
    try {
      final credentials = await _fetchCredentials();
      final result = await _appAuth.token(TokenRequest(
        credentials.clientId,
        credentials.redirectUrl,
        clientSecret: credentials.clientSecret,
        refreshToken: refreshToken,
        discoveryUrl: _discoveryUrl,
        scopes: _scopes,
      ));

      setState(() {
        _accessToken = result?.accessToken;
      });

      if (result?.refreshToken != null) {
        await _secureStorage.write(
            key: 'refresh_token', value: result?.refreshToken);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Error refreshing token: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Xero Auth & Invoice'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Authenticate with Xero'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async => Invoice.create(_accessToken),
                child: const Text('Create Invoice'),
              ),
            ],
          ),
        ),
      );
}
