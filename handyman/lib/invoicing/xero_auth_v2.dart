// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

import '../dao/dao_system.dart';
import 'models/models.dart';

class InvoiceException implements Exception {
  InvoiceException(this.message);
  final String message;
}

class XeroAuthScreenV2 extends StatefulWidget {
  const XeroAuthScreenV2({super.key});

  static const routeName = '/xero-auth';

  @override
  // ignore: library_private_types_in_public_api
  _XeroAuthScreenV2State createState() => _XeroAuthScreenV2State();
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

class _XeroAuthScreenV2State extends State<XeroAuthScreenV2> {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _discoveryUrl =
      'https://identity.xero.com/.well-known/openid-configuration';

  String? _accessToken;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _authenticate() async {
    final _scopes = <String>[
      'openid',
      'profile',
      'email',
      'offline_access',
      'accounting.transactions'
    ];

    final system = await DaoSystem().get();
    final manager = OidcUserManager.lazy(
        discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
          Uri.parse('https://identity.xero.com'),
        ),
        clientCredentials: OidcClientAuthentication.clientSecretBasic(
            clientId: system!.xeroClientId!,
            clientSecret: system.xeroClientSecret!),
        store: OidcDefaultStore(),
        settings: OidcUserManagerSettings(
          scope: _scopes,
          
          redirectUri: kIsWeb
              // this url must be an actual html page.
              // see the file in /web/redirect.html for an example.
              //
              // for debugging in flutter, you must run this app with --web-port 22433
              // TODO(bsutton): copy a redirect.html from the oidc project
              // somewhere and use that path here.
              ? Uri.parse('http://localhost:22433/redirect.html')
              : Platform.isIOS || Platform.isMacOS || Platform.isAndroid
                  // scheme: reverse domain name notation of your package name.
                  // path: anything.
                  ? Uri.parse('au.com.ivanhoehandyman.hmb://app_auth_redirect')
                  : Platform.isWindows || Platform.isLinux
                      // using port 0 means that we don't care which port is used,
                      // and a random unused port will be assigned.
                      //
                      // this is safer than passing a port yourself.
                      //
                      // note that you can also pass a path like /redirect,
                      // but it's completely optional.
                      // ? Uri.parse('http://localhost:0')
                      ? Uri.parse(
                          'https://au.com.ivanhoehandyman/app_auth_redirect')
                      : Uri(),
          // Uri.parse(
          //     'http://ivanhoehandyman.com.au/app_auth_redirect.html')),
        ));

//2. init()
    await manager.init();

//3. listen to user changes
    manager.userChanges().listen((user) {
      print('currentUser changed to $user');
    });

//4. login
    final newUser = await manager.loginAuthorizationCodeFlow();

//5. logout
    await manager.logout();
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
