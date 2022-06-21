import 'dart:convert';

import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:seriesmanager/utils/time.dart';

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

  Future<HttpResponse> getDetailsSeasonsViewed(int seriesId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/seasons/series/$seriesId/viewed'));
    return HttpResponse(response);
  }

  Future<HttpResponse> addAllSeasons(
      int seriesId, List<ApiSeason> seasons, DateTime viewedAt) async {
    final Response response = await client.post(
      Uri.parse('$endpoint/seasons/series/$seriesId/all'),
      body: jsonEncode(
        <String, dynamic>{
          'seasons': seasons,
          'viewedAt': Time.dateToString(viewedAt),
        },
      ),
    );
    return HttpResponse(response);
  }
}
