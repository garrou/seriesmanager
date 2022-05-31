import 'dart:async';

import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/user_service.dart';

class Guard {
  static checkAuth(StreamController streamController) async {
    HttpResponse response = await UserService().getUser();
    streamController.add(response.success());
  }
}
