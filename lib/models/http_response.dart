import 'dart:convert';
import 'package:http/http.dart';

class HttpResponse {
  late final dynamic _body;

  HttpResponse(Response response) {
    _body = jsonDecode(utf8.decode(response.bodyBytes));
  }

  bool success() => _body['status'];

  String message() => _body['message'];

  dynamic content() => _body['data'];
}
