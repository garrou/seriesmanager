import 'dart:convert';

import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
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
        await client.get(Uri.parse('$endpoint/series/$seriesId/seasons'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getByNumberBySeriesId(int number, int seriesId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/series/$seriesId/seasons/$number'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getDetailsSeasonsViewed(int seriesId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/series/$seriesId/seasons/viewed'));
    return HttpResponse(response);
  }

  Future<HttpResponse> add(
      int seriesId, List<ApiSeason> seasons, DateTime viewedAt) async {
    final Response response = await client.post(
      Uri.parse('$endpoint/seasons'),
      body: jsonEncode(
        <String, dynamic>{
          'seasons': seasons,
          'viewedAt': Time.dateToString(viewedAt),
          'seriesId': seriesId,
        },
      ),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getSeriesToContinue() async {
    final Response response =
        await client.get(Uri.parse('$endpoint/seasons/continue'));
    return HttpResponse(response);
  }

  Future<HttpResponse> update(int seasonId, DateTime viewedAt) async {
    final Response response = await client.patch(
      Uri.parse('$endpoint/seasons/$seasonId'),
      body: jsonEncode(
        <String, dynamic>{
          'id': seasonId,
          'viewedAt': Time.dateToString(viewedAt)
        },
      ),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> delete(int seasonId) async {
    final Response response = await client.delete(
      Uri.parse('$endpoint/seasons/$seasonId'),
    );
    return HttpResponse(response);
  }
}
