import 'package:seriesmanager/models/api_details_series.dart';
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

  Future<List<ApiDetailsSeries>> getSeriesByName(String name) async {
    final Response res =
        await client.get(Uri.parse('$endpoint/search/names/$name'));
    final response = HttpResponse(res);
    return createDetailsSeries(response.content()?["shows"]);
  }

  Future<HttpResponse> getSeasonsBySid(int sid) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/series/$sid/seasons'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getEpisodesBySidBySeason(int sid, int season) async {
    final Response response = await client.get(
        Uri.parse('$endpoint/search/series/$sid/seasons/$season/episodes'));
    return HttpResponse(response);
  }

  Future<List<String>> getSeriesImagesByName(String name) async {
    final Response res =
        await client.get(Uri.parse('$endpoint/search/names/$name/images'));
    final response = HttpResponse(res);
    return List<String>.from(response.content() ?? List.empty());
  }

  Future<HttpResponse> getCharactersBySid(int sid) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/series/$sid/characters'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getActorInfoById(String id) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/search/actors/$id'));
    return HttpResponse(response);
  }
}
