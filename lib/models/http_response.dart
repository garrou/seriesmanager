import 'dart:convert';
import 'package:http/http.dart';

class HttpResponse {
  late final dynamic _body;
  late final bool _success;

  HttpResponse(Response response) {
    _body = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : null;
    _success = response.statusCode >= 200 && response.statusCode < 300;
  }

  bool success() => _success;

  String? message() => _body?['message'];

  dynamic content() => _body?['data'];
}
