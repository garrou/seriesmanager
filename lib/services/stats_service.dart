import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:seriesmanager/utils/constants.dart';

class StatsService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> getNbSeasonsByYear() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/seasons/years'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getNbEpisodesByYear() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/episodes/years'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getTimeSeasonsByYear() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/seasons/time'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getTotalSeries() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/series/count'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getTotalTime() async {
    Response response = await client.get(Uri.parse('$endpoint/stats/time'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getTimeCurrentWeek() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/time/week'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getAddedSeriesByYears() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/series/years'));
    return HttpResponse(response);
  }
}
