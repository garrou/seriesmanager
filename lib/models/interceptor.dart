import 'package:http_interceptor/http_interceptor.dart';
import 'package:seriesmanager/utils/storage.dart';

class HttpInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String accessToken = await Storage.getToken();

    data.headers['Content-Type'] = 'application/json; charset=UTF-8';
    data.headers['Authorization'] = accessToken;
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
