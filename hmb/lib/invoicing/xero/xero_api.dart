import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../entity/invoice.dart';
import 'models/xero_invoice.dart';
import 'xero_auth.dart';

class XeroApi {
  factory XeroApi() => _instance;

  XeroApi._internal() : xeroAuth = XeroAuth();

  static final XeroApi _instance = XeroApi._internal();

  Future<void> login() async {
    await xeroAuth.login();
    await getTenantId();
  }

  final String _baseUrl = 'https://api.xero.com/api.xro/2.0/';

  String? _tenantId;

  XeroAuth xeroAuth;

  Future<http.Response> createInvoice(XeroInvoice xeroInvoice) async {
    final tenantId = await getTenantId();
    final response = await http.post(
      Uri.parse('${_baseUrl}Invoices'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Content-Type': 'application/json',
        'Xero-tenant-id': tenantId,
      },
      body: jsonEncode({
        'Invoices': [xeroInvoice.toJson()]
      }),
    );
    return response;
  }

  Future<http.Response> deleteInvoice(Invoice invoice) async {
    final tenantId = await getTenantId();
    final response = await http.post(
      Uri.parse('${_baseUrl}Invoices/${invoice.invoiceNum}'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Content-Type': 'application/json',
        'Xero-tenant-id': tenantId,
      },
      body: '''
{
    "InvoiceNumber": "${invoice.invoiceNum}",
    "Status": "DELETED"
}
''',
    );
    if (response.statusCode != 200) {
      throw Exception('Error deleting invoice: ${response.body}');
    }
    return response;
  }

  /// Instruct xero to send the invoice to the jobs primary contact.
  Future<http.Response> sendInvoice(Invoice invoice) async {
    final tenantId = await getTenantId();

    await _markAsAuthorised(invoice);
    final response = await http.post(
        Uri.parse('${_baseUrl}Invoices/${invoice.externalInvoiceId}/Email'),
        headers: {
          'Authorization': 'Bearer ${xeroAuth.accessToken}',
          'Content-Type': 'application/json',
          'Xero-tenant-id': tenantId,
        },
        body: '');
    if (response.statusCode != 204) {
      throw Exception('Error sending invoice: ${response.body}');
    }

    await _markAsSent(invoice);
    return response;
  }

  /// Instruct xero to send the invoice to the jobs primary contact.
  Future<http.Response> _markAsAuthorised(Invoice invoice) async {
    final tenantId = await getTenantId();
    final response = await http.post(
      Uri.parse('${_baseUrl}Invoices/${invoice.externalInvoiceId}'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Content-Type': 'application/json',
        'Xero-tenant-id': tenantId,
      },
      body: '''
{
    "InvoiceID": "${invoice.externalInvoiceId}",
    "Status": "AUTHORISED"
}
''',
    );
    if (response.statusCode != 200) {
      throw Exception('Error marking invoice as authorised: ${response.body}');
    }
    return response;
  }

  /// Instruct xero to send the invoice to the jobs primary contact.
  Future<http.Response> _markAsSent(Invoice invoice) async {
    final tenantId = await getTenantId();
    final response = await http.post(
      Uri.parse('${_baseUrl}Invoices/${invoice.externalInvoiceId}'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Content-Type': 'application/json',
        'Xero-tenant-id': tenantId,
      },
      body: '''
{
    "InvoiceID": "${invoice.externalInvoiceId}",
    "SentToContact": "true"
}
''',
    );
    if (response.statusCode != 200) {
      throw Exception('Error marking invoice as sent: ${response.body}');
    }
    return response;
  }

  Future<http.Response> getContact(String contactName) async {
    final tenantId = await getTenantId();
    final response = await http.get(
      Uri.parse('${_baseUrl}Contacts?where=Name=="$contactName"'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Xero-tenant-id': tenantId,
      },
    );
    return response;
  }

  Future<http.Response> createContact(Map<String, dynamic> contact) async {
    final tenantId = await getTenantId();
    final response = await http.post(
      Uri.parse('${_baseUrl}Contacts'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
        'Content-Type': 'application/json',
        'Xero-tenant-id': tenantId,
      },
      body: jsonEncode({
        'Contacts': [contact]
      }),
    );
    return response;
  }

  Future<String> getTenantId() async {
    if (_tenantId != null) {
      return _tenantId!;
    }

    final response = await http.get(
      Uri.parse('https://api.xero.com/connections'),
      headers: {
        'Authorization': 'Bearer ${xeroAuth.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final connections = jsonDecode(response.body) as List<dynamic>;
      if (connections.isNotEmpty) {
        _tenantId =
            // ignore: avoid_dynamic_calls
            connections[0]['tenantId'] as String; // Get the first tenant ID
        return _tenantId!;
      } else {
        throw Exception('No tenant connections found.');
      }
    } else {
      throw Exception('Failed to get tenant ID: ${response.body}');
    }
  }
}