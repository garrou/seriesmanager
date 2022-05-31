import 'dart:convert';
import 'package:http/http.dart';

class HttpResponse {
  late final dynamic _body;

  HttpResponse(Response response) {
    print(response.body);
    _body = jsonDecode(response.body);
  }

  bool success() => _body['status'];

  String message() => _body['message'];

  String content() => _body['data'];
}
