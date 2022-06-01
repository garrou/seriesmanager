import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/utils/constants.dart';

class AuthService {
  Future<HttpResponse> login(String email, String password) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> register(String email, String password) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }
}
