import 'dart:convert';

import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class SeasonService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> getBySeriesId(int seriesId) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/seasons/series/$seriesId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> add(UserSeason season) async {
    final Response response = await client.post(
      Uri.parse('$endpoint/seasons/'),
      body: jsonEncode(season),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getInfosByNumberBySeriesId(
      int number, int seriesId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/seasons/$number/series/$seriesId/infos'));
    return HttpResponse(response);
  }
}
