import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class SearchService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> discoverSeries() async {
    final Response response =
        await client.get(Uri.parse('$endpoint/api/search/discover'));
    return HttpResponse(response);
  }

  Future<HttpResponse> searchSeriesByName(String name) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/api/search/names/$name'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getDetailsById(int id) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/api/search/series/$id'));
    return HttpResponse(response);
  }
}
