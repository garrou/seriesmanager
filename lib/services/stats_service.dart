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

  Future<HttpResponse> getTimeSeasonsByYear() async {
    Response response =
        await client.get(Uri.parse('$endpoint/stats/seasons/time'));
    return HttpResponse(response);
  }
}
