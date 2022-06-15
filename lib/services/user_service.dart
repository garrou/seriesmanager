import 'dart:convert';

import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class UserService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> getUser() async {
    final Response response = await client.get(Uri.parse('$endpoint/user'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getProfile() async {
    final Response response = await client.get(Uri.parse('$endpoint/user'));
    return HttpResponse(response);
  }

  Future<HttpResponse> updateBanner(String banner) async {
    final Response response = await client.patch(
      Uri.parse('$endpoint/user/banner'),
      body: jsonEncode(<String, String>{'banner': banner}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> updateProfile(String username, String email) async {
    final Response response = await client.patch(
      Uri.parse('$endpoint/user/profile'),
      body: jsonEncode(<String, String>{'username': username, 'email': email}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> updatePassword(
      String current, String password, String confirm) async {
    final Response response = await client.patch(
      Uri.parse('$endpoint/user/password'),
      body: jsonEncode(<String, String>{
        'current': current,
        'password': password,
        'confirm': confirm
      }),
    );
    return HttpResponse(response);
  }
}
