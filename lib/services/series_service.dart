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

  Future<List<UserSeries>> getByName(String name) async {
    final Response res =
        await client.get(Uri.parse('$endpoint/series/names/$name'));
    final response = HttpResponse(res);
    return createUserSeries(response.content());
  }

  Future<HttpResponse> getInfosBySeriesId(int seriesId) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/series/$seriesId/infos'));
    return HttpResponse(response);
  }

  Future<HttpResponse> deleteBySeriesId(int seriesId) async {
    final Response response =
        await client.delete(Uri.parse('$endpoint/series/$seriesId'));
    return HttpResponse(response);
  }
}
