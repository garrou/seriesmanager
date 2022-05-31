import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/utils/constants.dart';
import 'package:seriesmanager/models/interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class SeriesService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpInterceptor(),
  ]);

  Future<HttpResponse> discoverSeries() async {
    final response = await client.get(Uri.parse('$endpoint/api/discover'));
    return HttpResponse(response);
  }

  Future<HttpResponse> searchSeries(String name) async {
    final response = await client.get(Uri.parse('$endpoint/api/search/$name'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getUserSeries() async {
    final response = await client.get(Uri.parse('$endpoint/api/series'));
    return HttpResponse(response);
  }

  Future<HttpResponse> searchUserSeries(String name) async {
    final response = await client.get(Uri.parse('$endpoint/api/series/$name'));
    return HttpResponse(response);
  }
}
