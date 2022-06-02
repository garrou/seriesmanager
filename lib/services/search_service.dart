import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class SearchService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> discover() async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/discover'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getSeriesByName(String name) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/names/$name'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getSeriesById(int seriesId) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/series/$seriesId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getSeasonsBySeriesId(int seriesId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/search/series/$seriesId/seasons'));
    return HttpResponse(response);
  }
}
