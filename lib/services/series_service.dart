import 'dart:convert';

import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class SeriesService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> getAll() async {
    final Response response = await client.get(Uri.parse('$endpoint/series/'));
    return HttpResponse(response);
  }

  Future<HttpResponse> add(UserSeries series) async {
    final Response response = await client.post(
      Uri.parse('$endpoint/series/'),
      body: jsonEncode(series),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getByTitle(String title) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/series/titles/$title'));
    return HttpResponse(response);
  }
}
